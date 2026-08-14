import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Step 2 of starting a game: name the manager, then create the save (which
/// starts the 2026→2030 cycle in September 2026).
class NewGameScreen extends ConsumerStatefulWidget {
  const NewGameScreen({required this.nationId, super.key});

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
    setState(() => _creating = true);
    final result = await ref
        .read(careerServiceProvider)
        .create(
          nationId: widget.nationId,
          managerName: _controller.text,
        );
    if (!mounted) return;
    setState(() => _creating = false);
    final l = AppLocalizations.of(context);

    result.fold(
      (career) => context.go('${Routes.hub}?careerId=${career.id}'),
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
