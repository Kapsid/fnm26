import 'package:flutter/widgets.dart';

/// What a tablet detail pane is showing. Stage 2 has players; nations, team
/// stats and head to head join in later stages.
sealed class DetailTarget {
  const DetailTarget();
}

final class PlayerTarget extends DetailTarget {
  const PlayerTarget(this.playerId);

  final int playerId;

  @override
  bool operator ==(Object other) =>
      other is PlayerTarget && other.playerId == playerId;

  @override
  int get hashCode => playerId.hashCode;
}

/// The selection of one detail pane.
class DetailPaneController extends ValueNotifier<DetailTarget?> {
  DetailPaneController([super.value]);

  void show(DetailTarget target) => value = target;
  void clear() => value = null;
}

/// Marks a subtree whose screen hosts a detail pane, so anything in it that
/// opens a player can put him in the pane instead of routing away.
class DetailPaneScope extends InheritedNotifier<DetailPaneController> {
  const DetailPaneScope({
    required DetailPaneController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// The nearest pane's controller, or null when the screen has none.
  ///
  /// Not a dependency: callers use it from a tap handler, and must not
  /// rebuild when the selection changes. A sheet or dialog is NOT under the
  /// screen's scope (it sits on the root navigator), so code inside one gets
  /// null here and routes, which is why a sheet closes itself first.
  static DetailPaneController? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DetailPaneScope>()?.notifier;
}
