part of 'new_game_screen.dart';

/// Naming the manager on a landscape tablet: the nation he is taking on (the
/// nation pick's preview: rank, strength, budget, best player, the board's
/// first demands) on the left; the name, what the career is and Start career
/// on the right. The field, the button and the write are the screen State's
/// ([_NewGameScreenState._controller], [_NewGameScreenState._start]), so a
/// resize keeps a half-typed name and a save being made.
class _NewGameTabletLayout extends StatelessWidget {
  const _NewGameTabletLayout({required this.state, required this.nationAsync});

  final _NewGameScreenState state;
  final AsyncValue<Nation?> nationAsync;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: NewGameScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.careerNewGame,
                onBack: () => context.go(Routes.nations),
              ),
              Expanded(
                child: nationAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) =>
                      Center(child: Text(l.careerCouldNotLoadNation('$e'))),
                  data: (nation) {
                    if (nation == null) {
                      return Center(child: Text(l.careerNationNotFound));
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: PanelBox(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: NationPreview(nation: nation),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 6,
                          // Scrolls, so the keyboard never pushes the
                          // button off the bottom.
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            children: [
                              AppTextField(
                                label: l.careerManagerName,
                                hint: l.careerManagerNameHint,
                                controller: state._controller,
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => state._start(),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                l.careerBeginsBlurb,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const _FreeCycleNote(gapBelow: AppSpacing.lg),
                              PrimaryButton(
                                key: NewGameScreen.startKey,
                                label: l.careerStartCareer,
                                icon: Icons.play_arrow_rounded,
                                isLoading: state._creating,
                                onPressed: state._creating
                                    ? null
                                    : state._start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
