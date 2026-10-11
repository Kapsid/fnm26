import 'package:flutter/widgets.dart';

/// Marks the subtree the tablet shell draws its routed screen into.
///
/// Phone-era chrome that the shell replaces (the bottom navigation bar) asks
/// [isActive] and steps aside. On a phone there is no scope, so nothing
/// changes.
class TabletShellScope extends InheritedWidget {
  const TabletShellScope({required super.child, super.key});

  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabletShellScope>() != null;

  @override
  bool updateShouldNotify(TabletShellScope oldWidget) => false;
}
