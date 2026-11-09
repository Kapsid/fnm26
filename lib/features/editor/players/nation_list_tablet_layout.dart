part of 'nation_list_screen.dart';

/// The nations on a landscape tablet: the search and the confederation
/// chips side by side above a grid of nations, as many columns as fit.
class _NationListTabletLayout extends StatelessWidget {
  const _NationListTabletLayout({
    required this.state,
    required this.title,
    required this.rows,
  });

  final _NationListScreenState state;
  final String title;
  final List<_NationRow> rows;

  static const double _searchWidth = 340;
  static const double _tileWidth = 340;
  static const double _tileHeight = 64;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return EditorFrame(
      tablet: true,
      tabletKey: NationListScreen.tabletLayoutKey,
      title: title,
      onBack: state._back,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: _searchWidth,
                child: _SearchField(state: state),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _ConfChips(state: state, horizontal: false)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: rows.isEmpty
                ? state._nothingShown(l)
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: _tileWidth,
                          mainAxisExtent: _tileHeight,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                        ),
                    itemCount: rows.length,
                    itemBuilder: (context, i) => _NationTile(
                      row: rows[i],
                      onTap: () => state._open(rows[i].nation.id),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
