import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

/// The world managers of every career (see [WorldManagerService]). Kept for
/// the app's life, so a career's seeding is shared by all who ask.
final worldManagerServiceProvider = Provider<WorldManagerService>(
  WorldManagerService.new,
);
