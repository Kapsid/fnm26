import 'package:flutter/widgets.dart';

/// Where a share sheet points from: the global rect of the widget at
/// [context], or null when it has not been laid out.
///
/// An iPad shows the share sheet as a popover and refuses to show it with
/// nowhere to point; an iPhone and Android ignore the origin. Take it BEFORE
/// any await: the widget may be gone, or moved, once the file is written.
Rect? shareOriginOf(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}
