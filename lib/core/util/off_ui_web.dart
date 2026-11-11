/// [computation], run inline: the browser has no isolates.
Future<R> runOffUi<R>(R Function() computation, {String? debugName}) =>
    Future<R>(computation);
