import 'package:flutter/material.dart';
import 'package:fnm/features/shell/detail_pane_host.dart';

/// Makes an already labelled nation (a flag and name, a team block) open that
/// nation's page: the side pane where the screen has one, otherwise the full
/// page (see [openNation]).
///
/// Wrap identifiable entries only (standings rows, fixture sides, bracket
/// slots); a decorative flag in news or Y text stays inert.
class NationTap extends StatelessWidget {
  const NationTap({
    required this.careerId,
    required this.nationId,
    required this.child,
    super.key,
  });

  final int careerId;
  final int nationId;
  final Widget child;

  /// [child] as it is when [careerId] is null (a screen that has not been told
  /// which career it is in stays inert), otherwise wrapped in a [NationTap].
  static Widget maybe({
    required int? careerId,
    required int nationId,
    required Widget child,
  }) => careerId == null
      ? child
      : NationTap(careerId: careerId, nationId: nationId, child: child);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => openNation(context, careerId: careerId, nationId: nationId),
    child: child,
  );
}
