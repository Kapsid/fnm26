import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// The manager's inbox: draws made, qualifications, champions crowned and board
/// news, newest first. Opening the screen marks everything read.
class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({required this.careerId, super.key});

  final int careerId;

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  bool _marked = false;

  @override
  Widget build(BuildContext context) {
    final inboxAsync = ref.watch(messageInboxProvider(widget.careerId));

    // Mark everything read once the inbox has loaded (after this frame).
    if (!_marked && inboxAsync.hasValue) {
      _marked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(competitionRepositoryProvider)
            .markMessagesRead(widget.careerId);
        ref
          ..invalidate(messageInboxProvider(widget.careerId))
          ..invalidate(unreadMessagesProvider(widget.careerId));
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.go('${Routes.hub}?careerId=${widget.careerId}'),
        ),
        title: Text(
          'MESSAGES',
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: inboxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load messages.\n$e')),
        data: (inbox) {
          if (inbox.messages.isEmpty) {
            return Center(
              child: Text(
                'No messages yet.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: inbox.messages.length,
            itemBuilder: (context, i) =>
                _MessageCard(message: inbox.messages[i]),
          );
        },
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

  final MessageItem message;

  ({IconData icon, Color color}) get _style => messageStyle(message.category);

  @override
  Widget build(BuildContext context) {
    final s = _style;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _open(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: s.color.withValues(alpha: 0.14),
                borderRadius: AppRadii.smAll,
              ),
              child: Icon(s.icon, color: s.color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight:
                      message.read ? FontWeight.w500 : FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '${message.year}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the full message in a popup.
  void _open(BuildContext context) {
    unawaited(showAppPopup<void>(
      context: context,
      builder: (context) => MessageSheet(message: message),
    ));
  }
}
