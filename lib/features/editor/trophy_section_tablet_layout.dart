part of 'trophy_section_screen.dart';

/// The Trophies section on a landscape tablet: the grid on the left, the
/// picked trophy (large, with its actions) on the right.
class _TrophySectionTabletLayout extends StatelessWidget {
  const _TrophySectionTabletLayout({
    required this.state,
    required this.title,
    required this.trophies,
    required this.picked,
  });

  final _TrophySectionScreenState state;
  final String title;
  final List<_Trophy> trophies;
  final _Trophy? picked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final shown = picked;
    return EditorFrame(
      tablet: true,
      tabletKey: TrophySectionScreen.tabletLayoutKey,
      title: title,
      onBack: state._back,
      body: _Opening(
        opening: state._opening,
        child: MasterDetail(
          initialFraction: 0.58,
          maxFraction: 0.7,
          minDetailWidth: 340,
          master: _TrophyGrid(
            trophies: trophies,
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            picked: shown?.key,
            onTap: (t) => state._open(t, tablet: true),
          ),
          detail: shown == null
              ? null
              // Top, not centred: the split's row hands the detail a loose
              // height.
              : Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: _TrophyDetail(
                        key: ValueKey('editorTrophies.detail.${shown.key}'),
                        trophy: shown,
                        onChoose: () => unawaited(state._choose(shown)),
                        onGallery: () => unawaited(
                          state._choose(shown, gallery: true),
                        ),
                        onReset: () => unawaited(state._reset(shown)),
                      ),
                    ),
                  ),
                ),
          placeholder: EditorMessage(
            l.editorTrophyPick,
            icon: Icons.touch_app_outlined,
          ),
        ),
      ),
    );
  }
}
