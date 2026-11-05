import Flutter
import UIKit

/// Flutter's own scene delegate, plus the `.fnmdb` files the system opens
/// the app with (Files, Mail, WhatsApp, AirDrop): see [IncomingFile].
class SceneDelegate: FlutterSceneDelegate {
  /// Cold start: the file the app was launched to open.
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    IncomingFile.shared.receive(connectionOptions.urlContexts)
  }

  /// A file opened while the app runs, in the foreground or the background.
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)
    IncomingFile.shared.receive(URLContexts)
  }
}

/// Copies an opened `.fnmdb` into the app's cache and hands the copy to
/// lib/features/world_pack/incoming_file.dart over `fnm/incoming_file`.
/// Dart deletes the copy once it has read it.
///
/// Dart asks `initial()` once it can import; until then the file waits here
/// (the file that started the app). After that, files go to `opened(path)`.
/// A file over [maxBytes] is never copied: Dart gets [tooBig] instead.
final class IncomingFile {
  static let shared = IncomingFile()

  /// PackCodec.maxFileBytes on the Dart side.
  static let maxBytes = 8 << 20
  static let tooBig = "fnm:tooBig"
  static let unreadable = "fnm:unreadable"

  private var channel: FlutterMethodChannel?
  private var ready = false
  private var pending: String?

  /// Called when the implicit engine is up (AppDelegate).
  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "fnm/incoming_file", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return result(nil) }
      switch call.method {
      case "initial":
        // Answered once: a hot restart asks again and gets nothing.
        self.ready = true
        result(self.pending)
        self.pending = nil
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.channel = channel
  }

  func receive(_ contexts: Set<UIOpenURLContext>) {
    for context in contexts where context.url.isFileURL {
      let url = context.url
      DispatchQueue.global(qos: .userInitiated).async {
        let path = IncomingFile.copy(url)
        DispatchQueue.main.async { self.deliver(path) }
      }
    }
  }

  private func deliver(_ path: String) {
    if ready, let channel {
      channel.invokeMethod("opened", arguments: path)
    } else {
      pending = path
    }
  }

  /// Copies [url] into the cache: the copy's path, [tooBig] or [unreadable].
  private static func copy(_ url: URL) -> String {
    // Without LSSupportsOpeningDocumentsInPlace the system hands over its
    // own copy in Documents/Inbox, which needs no security scope; a file
    // handed over in place (a future change, or another route in) does.
    let scoped = url.startAccessingSecurityScopedResource()
    defer {
      if scoped { url.stopAccessingSecurityScopedResource() }
      removeInboxCopy(url)
    }
    if let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize, size > maxBytes {
      return tooBig
    }
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(
      "incoming", isDirectory: true)
    let out = dir.appendingPathComponent("\(UUID().uuidString).fnmdb")
    do {
      try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
      guard let input = InputStream(url: url) else { return unreadable }
      guard FileManager.default.createFile(atPath: out.path, contents: nil) else {
        return unreadable
      }
      let sink = try FileHandle(forWritingTo: out)
      input.open()
      defer {
        input.close()
        try? sink.close()
      }
      var buffer = [UInt8](repeating: 0, count: 64 * 1024)
      var total = 0
      while true {
        let n = input.read(&buffer, maxLength: buffer.count)
        if n < 0 {
          try? FileManager.default.removeItem(at: out)
          return unreadable
        }
        if n == 0 { break }
        total += n
        // A size the file system did not report is still never copied
        // past the limit.
        if total > maxBytes {
          try? FileManager.default.removeItem(at: out)
          return tooBig
        }
        try sink.write(contentsOf: Data(buffer[0..<n]))
      }
      return out.path
    } catch {
      try? FileManager.default.removeItem(at: out)
      return unreadable
    }
  }

  /// The system's copy in Documents/Inbox has served its purpose; anything
  /// else (a file opened in place) is not ours to delete.
  private static func removeInboxCopy(_ url: URL) {
    guard
      let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        .first
    else { return }
    let inbox = documents.appendingPathComponent("Inbox", isDirectory: true)
      .resolvingSymlinksInPath().standardizedFileURL.path
    let file = url.resolvingSymlinksInPath().standardizedFileURL.path
    if file.hasPrefix(inbox + "/") {
      try? FileManager.default.removeItem(atPath: file)
    }
  }
}
