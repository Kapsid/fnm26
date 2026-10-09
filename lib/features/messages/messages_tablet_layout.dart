part of 'messages_screen.dart';

/// The tablet inbox's filters: the manager's own groupings of the inbox's
/// categories. Press and scouting are not inbox categories.
enum InboxFilter { all, board, competitions, squad }

/// Which filter a message [category] belongs to, or null for a category this
/// list does not know (shown under All only, never lost).
InboxFilter? inboxGroupOf(String category) => switch (category) {
  'board' || 'cycle' => InboxFilter.board,
  'draw' ||
  'qualify' ||
  'eliminated' ||
  'champion' ||
  'triumph' ||
  'ranking' => InboxFilter.competitions,
  'aging' ||
  'youth' ||
  'injury' ||
  'discipline' ||
  'retirement' ||
  'milestone' ||
  'award' ||
  'halloffame' ||
  'naturalize' ||
  'transfer' ||
  'record' => InboxFilter.squad,
  _ => null,
};

/// The inbox on a tablet: the list and the open message side by side. State
/// (filter, open message) is the screen's; this only draws it.
class _MessagesTabletLayout extends StatelessWidget {
  const _MessagesTabletLayout({
    required this.inboxAsync,
    required this.filter,
    required this.openId,
    required this.onFilter,
    required this.onOpen,
    required this.onRetry,
  });

  final AsyncValue<MessageInbox> inboxAsync;
  final InboxFilter filter;
  final int? openId;
  final ValueChanged<InboxFilter> onFilter;
  final ValueChanged<int> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      key: MessagesScreen.tabletLayoutKey,
      body: inboxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          message: l.messagesCouldNotLoad('').trim(),
          onRetry: onRetry,
        ),
        data: (inbox) {
          final visible = [
            for (final m in inbox.messages)
              if (filter == InboxFilter.all ||
                  inboxGroupOf(m.category) == filter)
                m,
          ];
          final open =
              visible.where((m) => m.id == openId).firstOrNull ??
              visible.firstOrNull;
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: MasterDetail(
              initialFraction: 0.36,
              minFraction: 0.28,
              maxFraction: 0.5,
              master: PanelBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: Text(l.sideInbox, style: TabletText.screenTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          for (final f in InboxFilter.values)
                            ChoiceChip(
                              label: Text(switch (f) {
                                InboxFilter.all => l.inboxFilterAll,
                                InboxFilter.board => l.sideBoard,
                                InboxFilter.competitions =>
                                  l.sideGroupCompetitions,
                                InboxFilter.squad => l.sideSquad,
                              }),
                              visualDensity: VisualDensity.compact,
                              selected: f == filter,
                              onSelected: (_) => onFilter(f),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Divider(height: 1),
                    Expanded(
                      child: visible.isEmpty
                          ? Center(
                              child: Text(
                                l.messagesNoMessagesYet,
                                style: TabletText.barMeta,
                              ),
                            )
                          : ListView.builder(
                              itemCount: visible.length,
                              itemBuilder: (context, i) => _InboxRow(
                                key: ValueKey('inbox.row.${visible[i].id}'),
                                message: visible[i],
                                selected: visible[i].id == open?.id,
                                onTap: () => onOpen(visible[i].id),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              detail: open == null
                  ? null
                  : PanelBox(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: AppSpacing.md),
                        // A new message is a new page: no scroll carried over.
                        child: MessageSheet(
                          key: ValueKey(open.id),
                          message: open,
                        ),
                      ),
                    ),
              placeholder: MasterDetailPlaceholder(text: l.inboxPickMessage),
            ),
          );
        },
      ),
    );
  }
}

/// One message in the tablet list: its category's mark, its title, its year.
class _InboxRow extends StatelessWidget {
  const _InboxRow({
    required this.message,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final MessageItem message;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = messageStyle(message.category);
    return Material(
      color: selected ? AppColors.surfaceContainerHighest : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              Icon(style.icon, color: style.color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  readMessage(AppLocalizations.of(context), message).title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.cell.copyWith(
                    fontWeight: message.read
                        ? FontWeight.w500
                        : FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('${message.year}', style: TabletText.barMeta),
            ],
          ),
        ),
      ),
    );
  }
}
