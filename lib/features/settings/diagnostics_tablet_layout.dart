part of 'diagnostics_screen.dart';

/// The log on a landscape tablet: the heading with Copy and Clear beside it,
/// and the log in one panel across the screen, scrolling both ways (stack
/// traces are long lines and are never reflowed). The read, the copy and the
/// clear are the screen State's.
class _DiagnosticsTabletLayout extends StatelessWidget {
  const _DiagnosticsTabletLayout({required this.state});

  final _DiagnosticsScreenState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: DiagnosticsScreen.tabletLayoutKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: FutureBuilder<String>(
            future: state._log,
            builder: (context, snapshot) {
              final text = snapshot.data?.trim() ?? '';
              final hasLog = text.isNotEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabletScreenHeader(
                    title: l.settingsDiagnosticsTitle,
                    onBack: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.settings),
                    trailing: hasLog
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => state._copy(context, text),
                                icon: const Icon(Icons.copy_rounded, size: 18),
                                label: Text(l.diagnosticsCopy),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton.icon(
                                onPressed: state._clear,
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 18,
                                ),
                                label: Text(l.diagnosticsClear),
                              ),
                            ],
                          )
                        : null,
                  ),
                  Expanded(
                    child: !snapshot.hasData
                        ? const Center(child: CircularProgressIndicator())
                        : !hasLog
                        ? Center(
                            child: Text(
                              l.diagnosticsEmpty,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          )
                        : PanelBox(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SelectableText(
                                  text,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    height: 1.35,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
