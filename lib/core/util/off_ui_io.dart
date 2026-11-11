import 'dart:isolate';

/// [computation] on a background isolate ([Isolate.run]).
Future<R> runOffUi<R>(R Function() computation, {String? debugName}) =>
    Isolate.run(computation, debugName: debugName);
