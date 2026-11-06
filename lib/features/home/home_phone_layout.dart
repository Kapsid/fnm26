part of 'home_screen.dart';

/// One way back into a game: a normal save or a campaign run, as the phone's
/// bento grid shows it, big or slim.
class _Resumable {
  const _Resumable({
    required this.key,
    required this.label,
    required this.date,
    required this.nationName,
    required this.nationCode,
    required this.name,
    required this.subtitle,
    required this.onResume,
    this.worldName,
    this.locked = false,
  });

  /// [HomeScreen.continueCareerKey] or [HomeScreen.campaignContinueKey].
  final Key key;

  /// "CONTINUE" or "CONTINUE CAMPAIGN".
  final String label;

  /// The in-game month, after the label on the big card.
  final String date;

  /// The nation, large on the big card.
  final String nationName;
  final String? nationCode;

  /// What the slim row calls it: the nation, or the campaign's title.
  final String name;

  /// What comes next: the road to the World Championship, or the campaign's
  /// title and cycle.
  final String subtitle;

  /// The database a normal save runs on; null for the game's own world.
  final String? worldName;
  final bool locked;
  final VoidCallback onResume;
}

/// A campaign run as the grid shows it: its nation, its title and the cycle
/// it is on.
_Resumable _campaignResumable(
  BuildContext context, {
  required CampaignDef def,
  required Career run,
  required String nationName,
  required String? nationCode,
  required bool locked,
  required VoidCallback onResume,
}) {
  final l = AppLocalizations.of(context);
  final title = campaignWords(l, def).title;
  final cycle = (run.cyclePointer + 1).clamp(1, def.cycles);
  return _Resumable(
    key: HomeScreen.campaignContinueKey,
    label: l.homeContinueCampaign,
    date: AppDate.monthYear(context, run.inGameDate),
    nationName: nationName,
    nationCode: nationCode,
    name: title,
    // A one-cycle campaign has no progress worth stating.
    subtitle: def.cycles > 1
        ? '$title · ${l.homeCampaignCycleOnly(cycle, def.cycles)}'
        : title,
    locked: locked,
    onResume: onResume,
  );
}

/// The phone home, a bento grid: the logo and the title on top, and at the
/// foot of the screen the save played last, the other way back in (if there
/// is one), a tall New Game tile beside Saves and Campaigns, and Editor and
/// Settings below. Spare height goes around the title, never into the grid.
class _HomePhoneLayout extends StatelessWidget {
  const _HomePhoneLayout({
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

  /// Each of the two tall rows (New Game beside Saves and Campaigns) at full
  /// size, and the least it shrinks to once the logo has given way.
  static const double tileMax = 82;
  static const double tileMin = 70;

  /// The row of small tiles (Editor, Settings).
  static const double smallMax = 52;
  static const double smallMin = 48;

  /// The big continue card, at full size and at its least.
  static const double heroMax = 116;
  static const double heroMin = 100;

  /// The slim continue row.
  static const double slimHeight = 64;

  static const double gap = 10;
  static const double _side = 20;

  /// What the title and the tagline take, and the least logo worth drawing.
  static const double _brandText = 62;
  static const double _logoMin = 48;

  @override
  Widget build(BuildContext context) {
    final hero = this.hero;
    final second = this.second;
    return Scaffold(
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
            padding: const EdgeInsets.fromLTRB(
              _side,
              AppSpacing.sm,
              _side,
              AppSpacing.md,
            ),
            child: LayoutBuilder(
              builder: (context, box) {
                // The logo gives way first, down to [_logoMin]; only then do
                // the tiles shrink, the tall rows before the small one, and
                // last the big card.
                final grid =
                    (hero == null ? 0 : heroMax + gap) +
                    (second == null ? 0 : slimHeight + gap) +
                    2 * tileMax +
                    gap +
                    gap +
                    smallMax;
                var short =
                    grid +
                    AppSpacing.md +
                    _brandText +
                    _logoMin -
                    box.maxHeight;
                final tallCut = short.clamp(0.0, 2 * (tileMax - tileMin));
                short -= tallCut;
                final smallCut = short.clamp(0.0, smallMax - smallMin);
                short -= smallCut;
                final heroCut = short.clamp(0.0, heroMax - heroMin);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _HomeBrand(roomy: hero == null)),
                    const SizedBox(height: AppSpacing.md),
                    if (hero != null) ...[
                      _HeroCard(
                        key: HomeScreen.heroKey,
                        entry: hero,
                        minHeight: heroMax - heroCut,
                      ),
                      const SizedBox(height: gap),
                    ],
                    if (second != null) ...[
                      _SlimContinueCard(
                        key: HomeScreen.secondContinueKey,
                        entry: second,
                      ),
                      const SizedBox(height: gap),
                    ],
                    _HomeTiles(
                      hasSave: hasSave,
                      tall: tileMax - tallCut / 2,
                      small: smallMax - smallCut,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// The logo, the title and the tagline, centred in whatever height the grid
/// leaves. The logo gives way first. A first launch, with no continue card,
/// lets it grow.
class _HomeBrand extends StatelessWidget {
  const _HomeBrand({required this.roomy});

  final bool roomy;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final logo = roomy ? 200.0 : 140.0;
    return Column(
      key: HomeScreen.brandKey,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The box MATCHES THE ARTWORK's aspect (about 0.96:1, a shade taller
        // than square). A box of the wrong shape does not crop: it
        // letterboxes, so the logo is drawn to whichever side runs out first
        // and the rest of the box is wasted. Re-measure this if the artwork
        // is ever replaced.
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: logo),
            child: AspectRatio(
              aspectRatio: 200 / 208,
              child: Image.asset(
                'assets/images/fnm_logo.png',
                fit: BoxFit.contain,
                excludeFromSemantics: true,
                // Graceful fallback if the asset is missing in a bare test env.
                errorBuilder: (context, error, stack) => Icon(
                  Icons.sports_soccer,
                  size: logo / 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Football Nations Manager',
            maxLines: 1,
            style: AppTypography.headlineMedium.copyWith(
              fontSize: 22,
              height: 28 / 22,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.homeLeadTheNation,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 11,
            letterSpacing: 1.5,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A nation's flag clipped to a rounded rectangle or square.
class _FlagTile extends StatelessWidget {
  const _FlagTile(this.code, {required this.width, required this.height});

  final String code;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: ClipRRect(
      borderRadius: width >= 48 ? AppRadii.lgAll : AppRadii.smAll,
      child: CountryFlag(code),
    ),
  );
}

/// A bento cell: a rounded tile that is one button.
class _Cell extends StatelessWidget {
  const _Cell({
    required this.onTap,
    required this.child,
    this.color = AppColors.surfaceContainer,
    this.border = AppColors.outlineVariant,
    this.radius = AppRadii.lgAll,
    this.gradient,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;
  final Color color;
  final Color? border;
  final BorderRadius radius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final border = this.border;
    return Semantics(
      button: true,
      container: true,
      child: Material(
        color: gradient == null ? color : Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: border == null ? BorderSide.none : BorderSide(color: border),
        ),
        child: Ink(
          decoration: gradient == null
              ? null
              : BoxDecoration(gradient: gradient, borderRadius: radius),
          child: InkWell(onTap: onTap, child: child),
        ),
      ),
    );
  }
}

/// The big continue card across the grid: a flag tile, "CONTINUE · month",
/// the nation large, what comes next, and a chevron (a padlock when locked).
class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.entry,
    required this.minHeight,
    super.key,
  });

  final _Resumable entry;
  final double minHeight;

  @override
  Widget build(BuildContext context) => _Cell(
    key: entry.key,
    onTap: entry.onResume,
    color: AppColors.surfaceContainerHigh,
    border: AppColors.outline,
    radius: AppRadii.xlAll,
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            if (entry.nationCode case final code?) ...[
              _FlagTile(code, width: 64, height: 64),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.label} · ${entry.date}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.3,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.nationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (entry.worldName case final world?)
                    SaveWorldLine(
                      key: HomeScreen.continueWorldKey,
                      name: world,
                    ),
                  Text(
                    entry.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (entry.locked) const SaveLockedNote(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              entry.locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
              size: 24,
              color: entry.locked ? AppColors.warning : AppColors.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

/// The other way back in, slim under the big card: flag, "CONTINUE" or
/// "CONTINUE CAMPAIGN", the name and a chevron (a padlock when locked).
class _SlimContinueCard extends StatelessWidget {
  const _SlimContinueCard({required this.entry, super.key});

  final _Resumable entry;

  @override
  Widget build(BuildContext context) => _Cell(
    key: entry.key,
    onTap: entry.onResume,
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: _HomePhoneLayout.slimHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            if (entry.nationCode case final code?) ...[
              _FlagTile(code, width: 36, height: 24),
              const SizedBox(width: AppSpacing.md - 4),
            ],
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.3,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(
              entry.locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
              color: entry.locked ? AppColors.warning : AppColors.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

/// New Game (tall, silver) beside Saves and Campaigns, then Editor and
/// Settings.
class _HomeTiles extends StatelessWidget {
  const _HomeTiles({
    required this.hasSave,
    required this.tall,
    required this.small,
  });

  final bool hasSave;

  /// The height of each of the two tall rows.
  final double tall;

  /// The height of the small row.
  final double small;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const gap = _HomePhoneLayout.gap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 2 * tall + gap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _NewGameTile(
                  title: l.homeNewGame,
                  blurb: l.homeNewGameBlurb,
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _MenuTile(
                        key: HomeScreen.savesKey,
                        icon: Icons.save_outlined,
                        label: hasSave ? l.homeAllSaves : l.homeLoadGame,
                        onTap: () => context.go(Routes.saves),
                      ),
                    ),
                    const SizedBox(height: gap),
                    Expanded(
                      child: _MenuTile(
                        key: HomeScreen.campaignsKey,
                        icon: Icons.emoji_events_outlined,
                        label: l.homeCampaigns,
                        onTap: () => context.go(Routes.campaigns),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: gap),
        SizedBox(
          height: small,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SmallTile(
                  key: HomeScreen.editorKey,
                  icon: Icons.edit_outlined,
                  label: l.homeEditor,
                  onTap: () => context.go(Routes.editor),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: Tooltip(
                  message: l.homeSettings,
                  excludeFromSemantics: true,
                  child: _SmallTile(
                    key: HomeScreen.settingsKey,
                    icon: Icons.settings_outlined,
                    label: l.homeSettings,
                    onTap: () => context.go(Routes.settings),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The tall silver New Game tile: a play icon at the top, the title and one
/// line about it at the foot.
class _NewGameTile extends StatelessWidget {
  const _NewGameTile({required this.title, required this.blurb});

  final String title;
  final String blurb;

  @override
  Widget build(BuildContext context) => _Cell(
    key: HomeScreen.newGameKey,
    onTap: () => context.go(Routes.nations),
    border: null,
    radius: AppRadii.xlAll,
    gradient: const LinearGradient(
      begin: Alignment(-0.17, -1),
      end: Alignment(0.17, 1),
      colors: [AppColors.primaryFixed, AppColors.primaryContainer],
    ),
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.play_arrow_rounded,
            size: 32,
            color: AppColors.onPrimaryFixed,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  style: AppTypography.headlineMedium.copyWith(
                    fontSize: 22,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                blurb,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onPrimaryFixedVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Saves or Campaigns: the label at the bottom left, its icon at the right.
class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Cell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                height: 22 / 18,
                color: AppColors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 24, color: AppColors.primary),
        ],
      ),
    ),
  );
}

/// Editor or Settings: an icon and its label on one line.
class _SmallTile extends StatelessWidget {
  const _SmallTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _Cell(
    onTap: onTap,
    color: AppColors.surfaceContainerLow,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelLarge.copyWith(
                fontSize: 15,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
