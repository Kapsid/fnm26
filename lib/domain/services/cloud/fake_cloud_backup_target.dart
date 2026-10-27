import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fnm/domain/services/cloud/cloud_backup_target.dart';

/// An in-memory [CloudBackupTarget] for tests: a map of names to bytes, with
/// switches to make it unavailable or fail.
class FakeCloudBackupTarget implements CloudBackupTarget {
  FakeCloudBackupTarget({this.provider = CloudProvider.icloud});

  @override
  final CloudProvider provider;

  /// The folder's contents.
  final Map<String, Uint8List> files = {};

  /// What [availability] answers.
  CloudAvailability state = CloudAvailability.available;

  /// When set, the next [upload] throws and clears it.
  bool failNextUpload = false;

  /// Names whose [delete] throws.
  final Set<String> undeletable = {};

  int uploads = 0;
  final List<String> deleted = [];

  @override
  Future<CloudAvailability> availability() async => state;

  @override
  Future<void> upload(File local, String name) async {
    if (failNextUpload) {
      failNextUpload = false;
      throw const FileSystemException('cloud said no');
    }
    uploads++;
    files[name] = await local.readAsBytes();
  }

  @override
  Future<void> writeText(String name, String text) async {
    files[name] = Uint8List.fromList(utf8.encode(text));
  }

  @override
  Future<List<CloudFile>> list() async => [
    for (final e in files.entries) CloudFile(name: e.key, size: e.value.length),
  ];

  @override
  Future<String?> readText(String name) async {
    final bytes = files[name];
    return bytes == null ? null : utf8.decode(bytes);
  }

  @override
  Future<void> download(String name, String toPath) async {
    final bytes = files[name];
    if (bytes == null) throw FileSystemException('missing', name);
    await File(toPath).writeAsBytes(bytes);
  }

  @override
  Future<void> delete(String name) async {
    if (undeletable.contains(name)) {
      throw FileSystemException('locked', name);
    }
    deleted.add(name);
    files.remove(name);
  }
}
