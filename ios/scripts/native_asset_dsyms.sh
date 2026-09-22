#!/bin/sh
# Emit a dSYM for every embedded framework that does not already have one.
#
# Frameworks built by Dart build hooks (native assets) reach the app bundle
# outside both CocoaPods and Xcode's own compile steps, so nothing in the
# Flutter toolchain ever writes a dSYM for them. App Store Connect then warns
# that the archive is missing dSYMs for, e.g., sqlite3.framework and
# objective_c.framework, and crashes inside them arrive unsymbolicated.
#
# Those binaries carry no DWARF (their hooks compile without -g, and sqlite3 is
# a prebuilt download), so the dSYM produced here holds the Mach-O symbol table
# rather than line tables: crash frames resolve to function names, not to file
# and line. That is the most that can be recovered from the binaries as shipped.
set -eu

[ "${DEBUG_INFORMATION_FORMAT:-}" = "dwarf-with-dsym" ] || exit 0
[ -n "${DWARF_DSYM_FOLDER_PATH:-}" ] || exit 0

frameworks_dir="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH:-}"
[ -d "$frameworks_dir" ] || exit 0

mkdir -p "$DWARF_DSYM_FOLDER_PATH"

for framework in "$frameworks_dir"/*.framework; do
  [ -d "$framework" ] || continue
  name=$(basename "$framework" .framework)
  binary="$framework/$name"
  [ -f "$binary" ] || continue

  dsym="$DWARF_DSYM_FOLDER_PATH/$name.framework.dSYM"
  if [ -d "$dsym" ]; then
    continue
  fi

  if dsymutil "$binary" -o "$dsym" 2>/dev/null; then
    echo "note: generated $name.framework.dSYM"
  else
    echo "warning: could not generate a dSYM for $name.framework"
    rm -rf "$dsym"
  fi
done
