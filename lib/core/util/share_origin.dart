import 'package:flutter/widgets.dart';

/// Where a share sheet points from: the part of the widget at [context] that
/// is on screen, as a global rect.
///
/// An iPad shows the share sheet as a popover and refuses to show it unless
/// the origin is non-empty and lies wholly inside the app's view (share_plus
/// checks `CGRectContainsRect(view.frame, origin)`); an iPhone and Android
/// ignore the origin. So the widget's rect is clipped to the view: a card
/// scrolled half off the top, or a tile under the status bar, still points at
/// its visible part, and a widget wholly off screen points at the whole view.
///
/// Take it BEFORE any await: the widget may be gone, or moved, once the file
/// is written. Null means the widget has not been laid out, which should not
/// happen for a button the user just tapped; it is NOT a safe fallback, as an
/// iPad then refuses the share.
Rect? shareOriginOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  final rect = box.localToGlobal(Offset.zero) & box.size;
  // The root view, not MediaQuery: a phone frame on a tablet narrows the
  // MediaQuery, while global coordinates are the whole view's.
  final view = View.maybeOf(context);
  if (view == null) return rect;
  final bounds = Offset.zero & (view.physicalSize / view.devicePixelRatio);
  final visible = rect.intersect(bounds);
  if (visible.width <= 0 || visible.height <= 0) return bounds;
  return visible;
}
