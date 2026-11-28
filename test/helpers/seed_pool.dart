import 'dart:convert';
import 'dart:io';

import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/player.dart';

List<Player>? _pool;

/// The world's players as a new career seeds them: the bundled players
/// padded into deep national pools by [PoolGenerator.expand] (names aside,
/// which nothing read from it here depends on). Read once per test run.
List<Player> seedPool() => _pool ??= PoolGenerator.expand([
  for (final e
      in jsonDecode(File('assets/data/players.json').readAsStringSync())
          as List)
    Player.fromJson(e as Map<String, Object?>),
]);
