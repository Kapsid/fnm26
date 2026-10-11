part of 'intercontinental_playoff_screen.dart';

/// The play-off on a tablet: the heading with Continue on its right, the
/// body held to a readable width under it.
class _PlayoffTabletLayout extends ConsumerWidget {
  const _PlayoffTabletLayout({required this.screen});

  final IntercontinentalPlayoffScreen screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(intercontinentalPlayoffProvider(screen.careerId));
    final data = async.valueOrNull;
    return Scaffold(
      key: IntercontinentalPlayoffScreen.tabletLayoutKey,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabletScreenHeader(
              title: l.tourContIntercontinentalPlayoff,
              // As on the phone: only with a play-off to have seen.
              trailing: data == null
                  ? null
                  : SizedBox(
                      width: 220,
                      child: PrimaryButton(
                        label: l.tourContContinue,
                        icon: Icons.check_rounded,
                        height: 44,
                        onPressed: () => screen._continue(context, ref),
                      ),
                    ),
            ),
            Expanded(
              child: async.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l.tourContCouldNotLoad(e.toString()))),
                data: (data) {
                  if (data == null) {
                    return Center(child: Text(l.tourContNoPlayoffThisCycle));
                  }
                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: ListView(children: _playoffBody(l, data)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
