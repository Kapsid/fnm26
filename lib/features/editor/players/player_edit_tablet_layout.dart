part of 'player_edit_screen.dart';

/// A player on a landscape tablet: the form in two columns (who he is; how
/// good he is), centred at a readable width and scrolling when it must.
class _PlayerEditTabletBody extends StatelessWidget {
  const _PlayerEditTabletBody({required this.form});

  final PlayerEditForm form;

  static const double _maxWidth = 1040;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: form,
      ),
    ),
  );
}
