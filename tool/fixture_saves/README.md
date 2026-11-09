1. `git worktree add --detach ../fnm26-fx-<build> <commit>` (v109 = e34168ea, v110_37 = e70e731c, pre55 = main just before schema 55), then `flutter pub get` in it.
2. Copy `make_fixture_saves_test.dart.txt` into it as `test/story/make_fixture_saves_test.dart` (a build that renamed an API gets a `// BUILD:` switch there).
3. Run it alone: `FIXTURE_OUT=<dir> caffeinate -dimsu timeout 3600 flutter test test/story/make_fixture_saves_test.dart`.
4. Copy `<dir>/*` into `test/fixtures/saves/<build>/`, run `test/story/save_upgrade_test.dart`, and `git worktree remove --force` the worktree.
