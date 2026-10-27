part of 'settings_screen.dart';

/// Settings on a landscape tablet in three columns: the game's own settings
/// (sound, language, text size, what the free game covers) on the left; the
/// maker's note, the walk through, the log and the ways to reach the maker in
/// the middle; the saves' backups, the tallest card, alone on the right.
/// Every card is the phone's own, writes and share sheet included.
class _SettingsTabletLayout extends StatelessWidget {
  const _SettingsTabletLayout();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: SettingsScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabletScreenHeader(
                title: l.homeSettings,
                onBack: () =>
                    context.canPop() ? context.pop() : context.go(Routes.home),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView(
                        children: const [
                          _SoundHapticsCard(),
                          SizedBox(height: AppSpacing.md),
                          _LanguageCard(),
                          SizedBox(height: AppSpacing.md),
                          _TextSizeCard(),
                          SizedBox(height: AppSpacing.md),
                          _FreeScopeCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ListView(
                        children: const [
                          _FromDeveloperCard(),
                          SizedBox(height: AppSpacing.md),
                          _TourCard(),
                          SizedBox(height: AppSpacing.md),
                          _DiagnosticsCard(),
                          SizedBox(height: AppSpacing.md),
                          _ContactCard(),
                          SizedBox(height: AppSpacing.md),
                          CommunityCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: SingleChildScrollView(child: BackupsCard()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
