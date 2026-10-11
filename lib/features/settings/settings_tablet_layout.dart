part of 'settings_screen.dart';

/// Settings on a landscape tablet: the game's own settings (sound, language,
/// what the free game covers, the walk through) on the left; the log, the
/// way to reach the maker and the saves' backup on the right. Every card is
/// the phone's own, writes and share sheet included.
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
                          _FreeScopeCard(),
                          SizedBox(height: AppSpacing.md),
                          _FromDeveloperCard(),
                          SizedBox(height: AppSpacing.md),
                          _TourCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ListView(
                        children: const [
                          _DiagnosticsCard(),
                          SizedBox(height: AppSpacing.md),
                          _ContactCard(),
                          SizedBox(height: AppSpacing.md),
                          _BackupCard(),
                        ],
                      ),
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
