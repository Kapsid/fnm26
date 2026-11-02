import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/features/friendlies/warm_up_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// A qualified nation's invitation to a send-off friendly, made to a manager
/// whose side is not in its tournament: accept (it is booked as an ordinary
/// friendly, with a call-up of its own) or decline. Reached from the hub,
/// which offers each one until it is answered (see
/// [pendingWarmUpOfferProvider]); the camp scandal screen's shape.
class WarmUpOfferScreen extends ConsumerStatefulWidget {
  const WarmUpOfferScreen({required this.careerId, super.key});

  /// The tablet layout's scaffold, for tests.
  static const Key tabletLayoutKey = Key('warmUpOffer.tabletLayout');

  /// The two answers, for tests.
  static const Key acceptKey = Key('warmUpOffer.accept');
  static const Key declineKey = Key('warmUpOffer.decline');

  final int careerId;

  @override
  ConsumerState<WarmUpOfferScreen> createState() => _WarmUpOfferScreenState();
}

class _WarmUpOfferScreenState extends ConsumerState<WarmUpOfferScreen> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // In the inbox by the time he answers, even when it was made while he
    // was watching a draw rather than stepping the world.
    unawaited(
      ref.read(warmUpOfferServiceProvider).fileMessages(widget.careerId),
    );
  }

  Future<void> _answer(WarmUpOffer o, {required bool accept}) async {
    setState(() => _busy = true);
    final container = ProviderScope.containerOf(context);
    final router = GoRouter.of(context);
    final id = widget.careerId;
    final service = container.read(warmUpOfferServiceProvider);
    try {
      if (accept) {
        await service.accept(id, o);
      } else {
        await service.decline(id, o);
      }
    } finally {
      // A failed write must not leave both answers dead.
      if (mounted) setState(() => _busy = false);
    }
    if (router.state.uri.path == Routes.warmUpOffer) {
      router.go('${Routes.hub}?careerId=$id');
    }
  }

  void _leave() {
    final id = widget.careerId;
    ref
      ..invalidate(nextEventProvider(id))
      ..invalidate(hubDataProvider(id));
    context.go('${Routes.hub}?careerId=$id');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final offer = ref.watch(pendingWarmUpOfferProvider(widget.careerId));
    final content = switch (offer) {
      AsyncData(value: final o?) => _body(context, l, o),
      // Answered meanwhile, or lapsed: nothing to decide, so the way out is
      // always on screen.
      AsyncData() || AsyncError() => Center(
        child: SizedBox(
          width: 320,
          child: PrimaryButton(
            label: l.federationContinue,
            icon: Icons.check_rounded,
            onPressed: _leave,
          ),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
    if (TabletShellScope.isActive(context)) {
      return TabletPage(
        scaffoldKey: WarmUpOfferScreen.tabletLayoutKey,
        title: l.warmUpOfferTitle,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: content,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: _leave,
        ),
        title: Text(l.warmUpOfferTitle, style: AppTypography.labelMedium),
        centerTitle: true,
      ),
      body: content,
    );
  }

  Widget _body(BuildContext context, AppLocalizations l, WarmUpOffer o) {
    final muted = AppTypography.bodySmall.copyWith(
      color: AppColors.onSurfaceVariant,
    );
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.handshake_rounded,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                o.nationName,
                                style: AppTypography.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l.warmUpOfferBody(
                            o.nationName,
                            competitionLabel(l, o.competition),
                            AppDate.dayMonthYear(context, o.date),
                          ),
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          o.theyHost
                              ? l.warmUpOfferAway(o.nationName)
                              : l.warmUpOfferHome,
                          style: muted,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(l.warmUpOfferNote, style: muted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              key: WarmUpOfferScreen.acceptKey,
              label: l.warmUpOfferAccept,
              icon: Icons.check_rounded,
              isLoading: _busy,
              onPressed: _busy
                  ? null
                  : () => unawaited(_answer(o, accept: true)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              key: WarmUpOfferScreen.declineKey,
              onPressed: _busy
                  ? null
                  : () => unawaited(_answer(o, accept: false)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l.warmUpOfferDecline, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
