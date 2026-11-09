import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/features/world_managers/world_manager_service.dart';

/// The world managers of every career (see [WorldManagerService]). Kept for
/// the app's life, so a career's seeding is shared by all who ask.
final worldManagerServiceProvider = Provider<WorldManagerService>(
  WorldManagerService.new,
);

/// Whether the AI's tactics read the world manager in charge (see
/// [WorldManagerService.styleOn]). Always on in the app; a test switches it
/// off to replay a world exactly as it was before world managers.
final worldManagerStyleEnabledProvider = Provider<bool>((_) => true);
