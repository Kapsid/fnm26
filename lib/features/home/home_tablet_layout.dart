part of 'home_screen.dart';

/// The home on a tablet, the phone's bento grown up. In landscape the logo,
/// the title and the tagline sit centred in the left half and the grid in
/// the right: the save played last, the other way back in (if there is one),
/// New Game beside Saves and Campaigns, and Editor and Settings below. In
/// portrait the logo stacks over the grid, both centred. Every tile is the
/// phone's own, with the same actions and the same padlocks.
class _HomeTabletLayout extends StatelessWidget {
  const _HomeTabletLayout({
    required this.hasSave,
    required this.hero,
    required this.second,
  });

  /// Whether a normal save exists (the saves tile then says "All saves").
  final bool hasSave;

  /// The save or run played last; null on a first launch.
  final _Resumable? hero;

  /// The other one, when both a save and a run exist.
  final _Resumable? second;

  static const double _tall = 104;
  static const double _small = 60;
  static const double _hero = 132;
  static const double _slim = 72;
  static const double _gap = 12;

  /// How wide the grid grows, and the logo's size against the phone's.
  static const double _gridMaxWidth = 500;
  static const double _brandScale = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomeScreen.tabletLayoutKey,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [AppColors.surfaceContainerHigh, AppColors.surface],
            stops: [0, 0.6],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.lg,
            ),
            child: LayoutBuilder(
              builder: (context, box) =>
                  box.maxWidth > box.maxHeight ? _landscape() : _portrait(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _landscape() => Row(
    children: [
      const Expanded(
        child: Center(
          child: _HomeBrand(roomy: true, scale: _brandScale),
        ),
      ),
      const SizedBox(width: AppSpacing.xxl),
      Expanded(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _gridMaxWidth),
              child: _grid(),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _portrait() => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _gridMaxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The logo gives way first if the window is short.
          Flexible(
            child: _HomeBrand(
              roomy: hero == null,
              scale: _brandScale,
              shrinkWrap: true,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          _grid(),
        ],
      ),
    ),
  );

  Widget _grid() {
    final hero = this.hero;
    final second = this.second;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hero != null) ...[
          _HeroCard(key: HomeScreen.heroKey, entry: hero, minHeight: _hero),
          const SizedBox(height: _gap),
        ],
        if (second != null) ...[
          _SlimContinueCard(
            key: HomeScreen.secondContinueKey,
            entry: second,
            height: _slim,
          ),
          const SizedBox(height: _gap),
        ],
        _HomeTiles(hasSave: hasSave, tall: _tall, small: _small, gap: _gap),
      ],
    );
  }
}
