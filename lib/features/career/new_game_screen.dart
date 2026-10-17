import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/result/result.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/nations/nation_preview.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

part 'new_game_tablet_layout.dart';

/// Step 2 of starting a game: name the manager, then create the save (which
/// starts the 2026→2030 cycle in September 2026).
class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({required this.nationId, super.key});

  static const Key tabletLayoutKey = Key('newGame.tabletLayout');
  static const Key startKey = Key('newGame.start');

  final int nationId;

  @override
  ConsumerState<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends ConsumerState<NewGameScreen> {
  final _controller = TextEditingController();
  bool _creating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    // The button is disabled while a save is made, but the field's keyboard
    // Done also calls this: without the guard it would make a second save.
    if (_creating) return;
    setState(() => _creating = true);
    // Taken before the await: a resize across 1000 px rebuilds this page in
    // the other layout meanwhile, and a manager who has gone elsewhere (a
    // pushed Settings, the back arrow) is left there rather than pulled into
    // the new save. `router.state` is the top-most route, pushed ones too.
    final router = GoRouter.of(context);
    final careers = ref.read(careerServiceProvider);
    final Result<Career> result;
    try {
      result = await careers.create(
        nationId: widget.nationId,
        managerName: _controller.text,
      );
    } finally {
      // A create that throws must give Start back, not leave it spinning.
      if (mounted) setState(() => _creating = false);
    }
    if (!mounted) return;
    final l = AppLocalizations.of(context);

    result.fold(
      (career) {
        if (router.state.uri.path == Routes.newGame) {
          router.go('${Routes.hub}?careerId=${career.id}');
        }
      },
      (failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(failure.message),
              action: SnackBarAction(
                label: l.careerManageSaves,
                onPressed: () => context.go(Routes.saves),
              ),
            ),
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nationAsync = ref.watch(nationByIdProvider(widget.nationId));
    if (useTabletLayout(context, ref)) {
      return _NewGameTabletLayout(state: this, nationAsync: nationAsync);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go(Routes.nations),
        ),
        title: Text(
          l.careerNewGameTitle,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: nationAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(l.careerCouldNotLoadNation('$e'))),
            data: (nation) {
              if (nation == null) {
                return Center(child: Text(l.careerNationNotFound));
              }
              // Scrolls (and keeps the Spacer layout via IntrinsicHeight) so
              // the on-screen keyboard can't overflow the fixed content.
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          Center(child: FlagDisc(nation.code, size: 96)),
                          const SizedBox(height: AppSpacing.md),
                          Center(
                            child: Text(
                              nation.name,
                              style: AppTypography.headlineMedium,
                            ),
                          ),
                          Center(
                            child: Text(
                              l.careerWorldRankNum(nation.ranking),
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AppTextField(
                            label: l.careerManagerName,
                            hint: l.careerManagerNameHint,
                            controller: _controller,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _start(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l.careerBeginsBlurb,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          // What the manager is about to get for nothing, and
                          // what the one payment is for. Said HERE, before the
                          // save exists, rather than only at the wall four
                          // years later: a player who finds out what is paid
                          // for at the moment he is asked to pay reads it as a
                          // trap, even when the free part was the whole game.
                          const _FreeCycleNote(gapBelow: AppSpacing.md),
                          PrimaryButton(
                            label: l.careerStartCareer,
                            icon: Icons.play_arrow_rounded,
                            isLoading: _creating,
                            onPressed: _creating ? null : _start,
                          ),
                          const SizedBox(height: AppSpacing.md),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// What the manager is getting for nothing, and what the one payment is for:
/// the phone's note under the name, shared with the tablet's form. A manager
/// who has already paid has nothing left to be told, so it (and the gap
/// under it) is gone for him.
class _FreeCycleNote extends ConsumerWidget {
  const _FreeCycleNote({required this.gapBelow});

  final double gapBelow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(premiumUnlockedProvider)) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final note = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(l.careerFreeCycleNote, style: AppTypography.bodyMedium),
        ),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(bottom: gapBelow),
      child: note,
    );
  }
}
