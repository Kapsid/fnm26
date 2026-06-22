import 'package:drift/native.dart';
import 'package:fnm/data/db/app_database.dart';

/// Creates a fresh in-memory [AppDatabase] for a test. Each call is fully
/// isolated. Remember to `close()` it in `tearDown`.
AppDatabase createTestDatabase() =>
    AppDatabase.forTesting(NativeDatabase.memory());
