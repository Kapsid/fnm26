import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/share/cabinet_share_card.dart';
import 'package:fnm/features/share/share_data.dart';
import 'package:fnm/features/share/share_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The trophy cabinet's Share icon: the MANAGER's cabinet, every nation he
/// has won with. Nothing at all until he has won a trophy.
class ShareCabinetButton extends ConsumerWidget {
  const ShareCabinetButton({required this.history, super.key});

  final ManagerHistory history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = cabinetShareData(
      AppLocalizations.of(context),
      history,
      ref.watch(localizedWorldProvider),
    );
    if (data == null) return const SizedBox.shrink();
    return ShareCardButton(
      compact: true,
      fileStem: 'fnm-trophy-cabinet',
      flagCodes: cabinetShareFlags(data),
      images: cabinetShareImages(data),
      card: (format) => CabinetShareCard(data: data, format: format),
    );
  }
}

/// [ShareCabinetButton] for a screen that has the career, not its history.
class ShareCabinetButtonFor extends ConsumerWidget {
  const ShareCabinetButtonFor({required this.careerId, super.key});

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = ref.watch(managerHistoryProvider(careerId)).valueOrNull;
    if (h == null) return const SizedBox.shrink();
    return ShareCabinetButton(history: h);
  }
}
