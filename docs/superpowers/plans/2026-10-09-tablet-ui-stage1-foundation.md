# Tablet UI, Stage 1: Foundation. Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the tablet foundation: iPad enabled, landscape lock, form-factor detection, an FM-style shell (sidebar + top bar with Continue) wrapped around the existing routes on tablets only, the shared tablet widget kit, and one adaptive sheet helper replacing every direct `showModalBottomSheet`.

**Architecture:** The form factor is decided once at startup from the first view's logical size and injected into Riverpod. On tablet, `routerProvider` wraps the in-save routes in a go_router `ShellRoute` whose builder is `TabletShell`; full-screen routes stay top level. On phone, the route list is built exactly as today (no `ShellRoute`). Every existing screen renders inside the shell as its phone layout, centred at max width 600, until later stages register a tablet layout for it.

**Tech Stack:** Flutter, flutter_riverpod 2.6 (manual providers, no codegen), go_router 17, gen_l10n (7 ARB locales).

**Spec:** `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

## Global Constraints

- Phones keep the current UI exactly. Nothing in the phone path changes behaviour.
- Tablet = `shortestSide >= 600` logical px. Landscape only on tablets.
- Release target: v1.0.4 on both iOS and Android. Do not bump `pubspec.yaml` in this stage.
- No `@riverpod` codegen; write providers by hand (`Provider`, `StateProvider`, `FutureProvider`).
- If any `build_runner` step is needed, run it with `--force-jit`. (Nothing in this plan should need it.)
- All new user-facing strings go into all 7 ARB files (`en cs de es fr it pl`), then `flutter gen-l10n`, then `dart run tool/export_copy.dart` so `copy/strings.csv` stays in sync.
- No em dashes in user-facing copy. Never "World Cup" in English copy (it is "World Championship").
- Never run `flutter install` against a physical device. Use simulators/emulators for this stage.
- Commit messages end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`.
- Run all tests with `flutter test` from the repo root. `test/flutter_test_config.dart` loads the real fonts automatically.

## Spec adjustments made for stage 1

These are recorded in the spec by Task 13.

- **Training camp** and **Naturalization** are not in the sidebar. They are event screens that the Continue button opens at the right moment; opened cold they have nothing to show.
- **Settings, diagnostics and the dev gallery** are full-screen routes (outside the shell). They carry no `careerId`, so the shell has no save to show in its top bar.
- **`DetailPaneHost` and the `*View` extractions** (player, nation, team stats, H2H) move to stage 2, where Squad is the first screen that hosts a detail pane. `MasterDetail` (this stage) is the pane mechanism they will plug into.
- **Route sweep:** stage 1 checks route parity (every path still registered on tablet, full-screen paths outside the shell). Pumping every route on a seeded save moves to stage 2, once screens have tablet layouts worth sweeping.

## Review Focus

1. **Opponent shown before the draw is watched.** The top bar's next-fixture chip must hide the opponent while `HubData.nextDrawWatched` is false, as the hub does. Pinned in Task 6.
2. **Double advance.** Continue in the top bar and the hub's own button are both on screen on tablet. Tapping one while the other is busy must not start a second `season.advance`. Pinned in Task 5 (shared busy flag).
3. **Duplicate GlobalKey.** `TourKeys.hubAction` is a `GlobalKey`; if both buttons carried it the app would crash. Only the hub's in-body button carries it. Pinned in Task 5.
4. **Narrow window on a tablet** (iPad split view, Android freeform). When the window's shortest side drops below 600, the shell must step aside and render the plain phone screen. Pinned in Task 8.
5. **Shell route without a `careerId`.** If an in-shell route is opened without `?careerId=`, the shell must render the bare screen, not a top bar with no save behind it. Pinned in Task 8.

---

## File structure

**Create**
- `lib/core/layout/form_factor.dart`: `FormFactor` enum, `formFactorProvider`, `BuildContext.isTabletWindow`.
- `lib/shared/tablet/tablet_shell_scope.dart`: `TabletShellScope` inherited marker.
- `lib/shared/tablet/tablet_text.dart`: dense text styles for tablet widgets.
- `lib/shared/tablet/panel.dart`: `Panel`.
- `lib/shared/tablet/dashboard_grid.dart`: `DashboardGrid`, `DashboardTile`.
- `lib/shared/tablet/master_detail.dart`: `MasterDetail`, `MasterDetailPlaceholder`.
- `lib/shared/tablet/data_grid.dart`: `DataGrid<T>`, `GridColumn<T>`, `GridColumnSet<T>`.
- `lib/shared/tablet/adaptive_sheet.dart`: `showAdaptiveSheet<T>`.
- `lib/shared/tablet/tablet.dart`: barrel export of the kit.
- `lib/features/hub/hub_event_button.dart`: `HubEventButton` (extracted from `hub_screen.dart`), `hubActionBusyProvider`.
- `lib/features/shell/shell_destinations.dart`: sidebar model + `activeDestination`.
- `lib/features/shell/tablet_sidebar.dart`: `TabletSidebar`.
- `lib/features/shell/tablet_top_bar.dart`: `TabletTopBar`.
- `lib/features/shell/tablet_shell.dart`: `TabletShell`, `PhoneWidthFrame`, `tabletReadyPaths`.
- Tests listed per task.

**Modify**
- `lib/main.dart`: detect form factor, lock landscape on tablet, pass to `FnmRoot`.
- `lib/core/routing/app_router.dart`: `Routes.fullScreen`, tablet `ShellRoute`.
- `lib/shared/widgets/app_bottom_nav.dart`: render nothing inside `TabletShellScope`.
- `lib/features/hub/hub_screen.dart`: use `HubEventButton`; drop `_EventButton`.
- 11 files with `showModalBottomSheet` (Task 12).
- `ios/Runner.xcodeproj/project.pbxproj`, `ios/Runner/Info.plist`.
- `lib/l10n/app_{en,cs,de,es,fr,it,pl}.arb`, generated `app_localizations*.dart`, `copy/strings.csv`.

---

### Task 1: Form factor detection and landscape lock

**Files:**
- Create: `lib/core/layout/form_factor.dart`
- Modify: `lib/main.dart`
- Test: `test/unit/core/layout/form_factor_test.dart`, `test/widget/form_factor_window_test.dart`

**Interfaces:**
- Produces: `enum FormFactor { phone, tablet }` with `static FormFactor fromLogicalSize(Size)` and `static const double tabletShortestSide = 600`; `final Provider<FormFactor> formFactorProvider` (default `FormFactor.phone`); `extension FormFactorContext on BuildContext { bool get isTabletWindow; }`; `FnmRoot({FormFactor formFactor = FormFactor.phone})`.

- [ ] **Step 1: Write the failing unit test**

`test/unit/core/layout/form_factor_test.dart`:

```dart
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';

void main() {
  group('FormFactor.fromLogicalSize', () {
    test('a phone in portrait is a phone', () {
      expect(FormFactor.fromLogicalSize(const Size(390, 844)), FormFactor.phone);
    });
    test('a phone in landscape is still a phone', () {
      expect(FormFactor.fromLogicalSize(const Size(844, 390)), FormFactor.phone);
    });
    test('an 11in iPad in landscape is a tablet', () {
      expect(FormFactor.fromLogicalSize(const Size(1194, 834)), FormFactor.tablet);
    });
    test('600 on the short side is exactly the threshold', () {
      expect(FormFactor.fromLogicalSize(const Size(960, 600)), FormFactor.tablet);
      expect(FormFactor.fromLogicalSize(const Size(960, 599)), FormFactor.phone);
    });
  });
}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `flutter test test/unit/core/layout/form_factor_test.dart`
Expected: FAIL, `form_factor.dart` does not exist.

- [ ] **Step 3: Implement `form_factor.dart`**

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which family of layouts the app is running.
///
/// Decided once at startup from the first window (see `main.dart`) and held in
/// [formFactorProvider]: the router is built around it, and a tablet is locked
/// to landscape, so it does not change while the app runs.
enum FormFactor {
  phone,
  tablet;

  /// The shortest side, in logical pixels, from which a window is a tablet.
  static const double tabletShortestSide = 600;

  static FormFactor fromLogicalSize(Size size) =>
      size.shortestSide >= tabletShortestSide ? tablet : phone;
}

/// The form factor detected at startup. Overridden in `main.dart`; phone when
/// nothing overrides it, which is what every existing test expects.
final Provider<FormFactor> formFactorProvider = Provider<FormFactor>(
  (ref) => FormFactor.phone,
);

extension FormFactorContext on BuildContext {
  /// Whether the window this widget is drawn in is tablet sized RIGHT NOW.
  ///
  /// Differs from [formFactorProvider] when a tablet app is squeezed into a
  /// split-screen window: the shell then steps aside for the phone layout.
  bool get isTabletWindow =>
      FormFactor.fromLogicalSize(MediaQuery.sizeOf(this)) == FormFactor.tablet;
}
```

- [ ] **Step 4: Run the unit test, expect PASS**

Run: `flutter test test/unit/core/layout/form_factor_test.dart`

- [ ] **Step 5: Write the failing widget test for `isTabletWindow`**

`test/widget/form_factor_window_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';

void main() {
  Future<bool> probe(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    late bool result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            result = context.isTabletWindow;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return result;
  }

  testWidgets('tablet window', (tester) async {
    expect(await probe(tester, const Size(1194, 834)), isTrue);
  });

  testWidgets('phone window', (tester) async {
    expect(await probe(tester, const Size(390, 844)), isFalse);
  });

  testWidgets('a tablet squeezed into split view is not a tablet window', (
    tester,
  ) async {
    expect(await probe(tester, const Size(507, 834)), isFalse);
  });
}
```

- [ ] **Step 6: Run it, expect PASS** (implementation already exists)

Run: `flutter test test/widget/form_factor_window_test.dart`

- [ ] **Step 7: Wire startup in `lib/main.dart`**

Add imports:

```dart
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/services.dart';
import 'package:fnm/core/layout/form_factor.dart';
```

Inside the zone body, replace `runApp(const FnmRoot());` with:

```dart
      // The form factor is read once, from the first window, before anything
      // is built: the router's shape depends on it, and a tablet is held in
      // landscape so it will not change under us.
      final view = PlatformDispatcher.instance.implicitView;
      final formFactor = view == null
          ? FormFactor.phone
          : FormFactor.fromLogicalSize(
              view.physicalSize / view.devicePixelRatio,
            );
      if (formFactor == FormFactor.tablet) {
        await SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
      runApp(FnmRoot(formFactor: formFactor));
```

Change `FnmRoot`:

```dart
class FnmRoot extends StatefulWidget {
  const FnmRoot({this.formFactor = FormFactor.phone, super.key});

  /// Detected at startup; survives [restart], which rebuilds the scope.
  final FormFactor formFactor;
  // ... generation and restart() unchanged
```

and in `_FnmRootState.build`, give the `ProviderScope` the override:

```dart
    builder: (_, generation, _) => ProviderScope(
      key: ValueKey(generation),
      overrides: [formFactorProvider.overrideWithValue(widget.formFactor)],
      child: const FnmApp(),
    ),
```

- [ ] **Step 8: Analyze and run the whole suite**

Run: `flutter analyze && flutter test`
Expected: no issues; all tests pass (the default is phone, so nothing else changes).

- [ ] **Step 9: Commit**

```bash
git add lib/core/layout/form_factor.dart lib/main.dart test/unit/core/layout/form_factor_test.dart test/widget/form_factor_window_test.dart
git commit -m "feat(tablet): detect form factor at startup, lock tablets to landscape

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 2: Enable iPad in the iOS project

**Files:**
- Modify: `ios/Runner.xcodeproj/project.pbxproj` (3 occurrences of `TARGETED_DEVICE_FAMILY = 1;`)
- Modify: `ios/Runner/Info.plist` (the `UISupportedInterfaceOrientations~ipad` array; add `UIRequiresFullScreen`)

**Interfaces:** none (platform config).

- [ ] **Step 1: Set the device family to iPhone + iPad**

```bash
sed -i '' 's/TARGETED_DEVICE_FAMILY = 1;/TARGETED_DEVICE_FAMILY = "1,2";/' ios/Runner.xcodeproj/project.pbxproj
grep -c 'TARGETED_DEVICE_FAMILY = "1,2";' ios/Runner.xcodeproj/project.pbxproj
```

Expected output: `3`.

- [ ] **Step 2: Landscape only on iPad, full screen**

In `ios/Runner/Info.plist`, replace the `UISupportedInterfaceOrientations~ipad` array with:

```xml
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIRequiresFullScreen</key>
	<true/>
```

`UIRequiresFullScreen` is required: App Store validation rejects an iPad app that supports multitasking without all four orientations. It only affects iPad. The iPhone `UISupportedInterfaceOrientations` array is left unchanged.

- [ ] **Step 3: Validate**

```bash
plutil -lint ios/Runner/Info.plist
flutter build ios --simulator --debug
```

Expected: `OK`, then a successful simulator build. The AppIcon set already contains the iPad sizes (checked: `idiom: ipad` entries exist).

- [ ] **Step 4: Commit**

```bash
git add ios/Runner.xcodeproj/project.pbxproj ios/Runner/Info.plist
git commit -m "build(ios): support iPad, landscape only, full screen

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 3: Shell copy in all 7 languages

**Files:**
- Modify: `lib/l10n/app_en.arb`, `app_cs.arb`, `app_de.arb`, `app_es.arb`, `app_fr.arb`, `app_it.arb`, `app_pl.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`, `copy/strings.csv`
- Test: existing `test/unit/l10n/*` guards

**Interfaces:**
- Produces these `AppLocalizations` getters: `sideGroupHome`, `sideGroupTeam`, `sideGroupCompetitions`, `sideGroupFederation`, `sideGroupHistory`, `sideInbox`, `sideSquad`, `sideTactics`, `sideCallUps`, `sideTournaments`, `sideRanking`, `sideResults`, `sideFinances`, `sideBoard`, `sideManager`, `sideRecords`, `sideLegends`, `sideHeadToHead`, `sideAchievements`, `sideCareer`, `topBarNext`, `topBarDrawPending`.
- Reused existing getters (do not add): `navHub`, `navY`, `youthTitle`, `resultsCategoryNationsCup`, `homeSettings`, `hubMessages`, `hubContinue`, `hubVs`.

- [ ] **Step 1: Add the English strings with descriptions**

Append before the closing `}` of `lib/l10n/app_en.arb` (add a comma after the previous last entry):

```json
  "sideGroupHome": "Home",
  "@sideGroupHome": { "description": "Tablet sidebar: section heading over Hub, Inbox and Y." },
  "sideGroupTeam": "Team",
  "@sideGroupTeam": { "description": "Tablet sidebar: section heading over squad, tactics, call-ups and youth." },
  "sideGroupCompetitions": "Competitions",
  "@sideGroupCompetitions": { "description": "Tablet sidebar: section heading over tournaments, Nations Cup, ranking and results." },
  "sideGroupFederation": "Federation",
  "@sideGroupFederation": { "description": "Tablet sidebar: section heading over finances, board and manager." },
  "sideGroupHistory": "History",
  "@sideGroupHistory": { "description": "Tablet sidebar: section heading over records, legends, head to head, achievements and career." },
  "sideInbox": "Inbox",
  "@sideInbox": { "description": "Tablet sidebar item: the messages screen." },
  "sideSquad": "Squad",
  "@sideSquad": { "description": "Tablet sidebar item: the squad list." },
  "sideTactics": "Tactics",
  "@sideTactics": { "description": "Tablet sidebar item: line-up and instructions." },
  "sideCallUps": "Call-ups",
  "@sideCallUps": { "description": "Tablet sidebar item: squad selection." },
  "sideTournaments": "Tournaments",
  "@sideTournaments": { "description": "Tablet sidebar item: tournaments and standings." },
  "sideRanking": "Ranking",
  "@sideRanking": { "description": "Tablet sidebar item: the world ranking." },
  "sideResults": "Results",
  "@sideResults": { "description": "Tablet sidebar item: results and fixtures." },
  "sideFinances": "Finances",
  "@sideFinances": { "description": "Tablet sidebar item: federation finances." },
  "sideBoard": "Board",
  "@sideBoard": { "description": "Tablet sidebar item: board objectives." },
  "sideManager": "Manager & staff",
  "@sideManager": { "description": "Tablet sidebar item: manager skills, staff and training." },
  "sideRecords": "Records",
  "@sideRecords": { "description": "Tablet sidebar item: the record book." },
  "sideLegends": "Legends",
  "@sideLegends": { "description": "Tablet sidebar item: all-time XI and hall of fame." },
  "sideHeadToHead": "Head to head",
  "@sideHeadToHead": { "description": "Tablet sidebar item: compare two nations." },
  "sideAchievements": "Achievements",
  "@sideAchievements": { "description": "Tablet sidebar item: achievements." },
  "sideCareer": "Career",
  "@sideCareer": { "description": "Tablet sidebar item: the manager's careers." },
  "topBarNext": "Next",
  "@topBarNext": { "description": "Tablet top bar: label before the next fixture." },
  "topBarDrawPending": "Draw to come",
  "@topBarDrawPending": { "description": "Tablet top bar: shown instead of the opponent until the draw has been watched." }
```

- [ ] **Step 2: Add the translations**

Append the same keys (values only, no `@` entries) to each locale file:

| key | cs | de | es | fr | it | pl |
|---|---|---|---|---|---|---|
| sideGroupHome | Hlavní | Übersicht | Inicio | Accueil | Home | Start |
| sideGroupTeam | Tým | Team | Equipo | Équipe | Squadra | Drużyna |
| sideGroupCompetitions | Soutěže | Wettbewerbe | Competiciones | Compétitions | Competizioni | Rozgrywki |
| sideGroupFederation | Svaz | Verband | Federación | Fédération | Federazione | Federacja |
| sideGroupHistory | Historie | Geschichte | Historia | Histoire | Storia | Historia |
| sideInbox | Pošta | Posteingang | Bandeja de entrada | Boîte de réception | Posta | Skrzynka |
| sideSquad | Kádr | Kader | Plantilla | Effectif | Rosa | Kadra |
| sideTactics | Taktika | Taktik | Táctica | Tactique | Tattica | Taktyka |
| sideCallUps | Nominace | Nominierungen | Convocatorias | Convocations | Convocazioni | Powołania |
| sideTournaments | Turnaje | Turniere | Torneos | Tournois | Tornei | Turnieje |
| sideRanking | Žebříček | Weltrangliste | Clasificación | Classement | Ranking | Ranking |
| sideResults | Výsledky | Ergebnisse | Resultados | Résultats | Risultati | Wyniki |
| sideFinances | Finance | Finanzen | Finanzas | Finances | Finanze | Finanse |
| sideBoard | Vedení | Vorstand | Directiva | Direction | Dirigenza | Zarząd |
| sideManager | Trenér a štáb | Trainer & Stab | Entrenador y cuerpo técnico | Entraîneur et staff | Allenatore e staff | Trener i sztab |
| sideRecords | Rekordy | Rekorde | Récords | Records | Record | Rekordy |
| sideLegends | Legendy | Legenden | Leyendas | Légendes | Leggende | Legendy |
| sideHeadToHead | Vzájemné zápasy | Direktvergleich | Cara a cara | Face-à-face | Scontri diretti | Bilans spotkań |
| sideAchievements | Úspěchy | Erfolge | Logros | Succès | Obiettivi | Osiągnięcia |
| sideCareer | Kariéra | Karriere | Carrera | Carrière | Carriera | Kariera |
| topBarNext | Další | Nächstes | Próximo | Prochain | Prossima | Następny |
| topBarDrawPending | Čeká se na los | Auslosung folgt | Sorteo pendiente | Tirage à venir | Sorteggio in arrivo | Losowanie wkrótce |

- [ ] **Step 3: Regenerate typed strings and the copy file**

```bash
flutter gen-l10n
dart run tool/export_copy.dart
```

Expected: no "untranslated" warnings for the new keys; `copy/strings.csv` gains 22 rows.

- [ ] **Step 4: Run the l10n guards**

Run: `flutter test test/unit/l10n`
Expected: PASS (round trip, French colon spacing, Czech-only joke, etc.).

- [ ] **Step 5: Commit**

```bash
git add lib/l10n copy/strings.csv
git commit -m "feat(tablet): sidebar and top bar copy in all languages

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 4: Shell scope marker and bottom nav hiding

**Files:**
- Create: `lib/shared/tablet/tablet_shell_scope.dart`
- Modify: `lib/shared/widgets/app_bottom_nav.dart` (top of `build`)
- Test: `test/widget/app_bottom_nav_shell_test.dart`

**Interfaces:**
- Produces: `class TabletShellScope extends InheritedWidget { const TabletShellScope({required Widget child, Key? key}); static bool isActive(BuildContext context); }`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/pump_app.dart';

void main() {
  const nav = AppBottomNav(careerId: 1, current: AppTab.hub);

  testWidgets('on a phone the bottom nav is drawn as before', (tester) async {
    await tester.pumpApp(const Scaffold(bottomNavigationBar: nav));
    expect(find.text('Hub'), findsOneWidget);
    expect(find.text('Squad'), findsOneWidget);
  });

  testWidgets('inside the tablet shell the sidebar replaces it', (
    tester,
  ) async {
    await tester.pumpApp(
      const TabletShellScope(child: Scaffold(bottomNavigationBar: nav)),
    );
    expect(find.text('Hub'), findsNothing);
    expect(find.text('Squad'), findsNothing);
  });
}
```

- [ ] **Step 2: Run, expect FAIL** (`tablet_shell_scope.dart` missing)

Run: `flutter test test/widget/app_bottom_nav_shell_test.dart`

- [ ] **Step 3: Implement the scope**

```dart
import 'package:flutter/widgets.dart';

/// Marks the subtree the tablet shell draws its routed screen into.
///
/// Phone-era chrome that the shell replaces (the bottom navigation bar) asks
/// [isActive] and steps aside. On a phone there is no scope, so nothing
/// changes.
class TabletShellScope extends InheritedWidget {
  const TabletShellScope({required super.child, super.key});

  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabletShellScope>() != null;

  @override
  bool updateShouldNotify(TabletShellScope oldWidget) => false;
}
```

- [ ] **Step 4: Hide the bottom nav inside the scope**

In `lib/shared/widgets/app_bottom_nav.dart` add the import
`import 'package:fnm/shared/tablet/tablet_shell_scope.dart';` and make the first lines of `build`:

```dart
  @override
  Widget build(BuildContext context) {
    // On a tablet the shell's sidebar is the navigation.
    if (TabletShellScope.isActive(context)) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
```

- [ ] **Step 5: Run, expect PASS**

Run: `flutter test test/widget/app_bottom_nav_shell_test.dart`

- [ ] **Step 6: Commit**

```bash
git add lib/shared/tablet/tablet_shell_scope.dart lib/shared/widgets/app_bottom_nav.dart test/widget/app_bottom_nav_shell_test.dart
git commit -m "feat(tablet): shell scope; bottom nav steps aside inside it

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 5: Extract `HubEventButton` with a shared busy flag

The hub's Continue button (`_EventButton`, `lib/features/hub/hub_screen.dart` lines 541 to 766) becomes a public widget so the tablet top bar can reuse the exact same dispatch logic.

**Files:**
- Create: `lib/features/hub/hub_event_button.dart`
- Modify: `lib/features/hub/hub_screen.dart`
- Test: `test/widget/hub_event_button_test.dart`

**Interfaces:**
- Produces: `class HubEventButton extends ConsumerStatefulWidget { const HubEventButton({required int careerId, bool compact = false, Key? key}); }`; `final StateProviderFamily<bool, int> hubActionBusyProvider`.
- Consumes: `nextEventProvider(int careerId)` (`lib/features/hub/hub_event.dart`), `HubEvent`, `HubEventKind`, `TourKeys.hubAction`.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/onboarding/tour_keys.dart';
import 'package:fnm/shared/widgets/primary_button.dart';

import '../helpers/pump_app.dart';

void main() {
  const event = HubEvent(
    kind: HubEventKind.advance,
    label: 'Play match',
    icon: Icons.play_arrow_rounded,
    subtitle: 'Czechia v Norway',
  );
  final overrides = [nextEventProvider(1).overrideWith((ref) async => event)];

  testWidgets('full button shows label and subtitle and carries the tour key', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1)),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.text('Play match'), findsOneWidget);
    expect(find.text('Czechia v Norway'), findsOneWidget);
    expect(find.byKey(TourKeys.hubAction), findsOneWidget);
  });

  testWidgets('compact button has no subtitle and no tour key', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: HubEventButton(careerId: 1, compact: true)),
      overrides: overrides,
    );
    await tester.pump();
    expect(find.text('Play match'), findsOneWidget);
    expect(find.text('Czechia v Norway'), findsNothing);
    expect(find.byKey(TourKeys.hubAction), findsNothing);
  });

  testWidgets('both on screen at once: no duplicate key, one busy flag', (
    tester,
  ) async {
    await tester.pumpApp(
      const Scaffold(
        body: Column(
          children: [
            HubEventButton(careerId: 1, compact: true),
            HubEventButton(careerId: 1),
          ],
        ),
      ),
      overrides: overrides,
    );
    await tester.pump();
    expect(tester.takeException(), isNull);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(Scaffold)),
    );
    container.read(hubActionBusyProvider(1).notifier).state = true;
    await tester.pump();

    final buttons = tester.widgetList<PrimaryButton>(find.byType(PrimaryButton));
    expect(buttons, hasLength(2));
    expect(buttons.every((b) => b.isLoading), isTrue);
  });
}
```

(Add `import 'package:flutter_riverpod/flutter_riverpod.dart';` for `ProviderScope.containerOf`.)

- [ ] **Step 2: Run, expect FAIL** (`hub_event_button.dart` missing)

Run: `flutter test test/widget/hub_event_button_test.dart`

- [ ] **Step 3: Create `hub_event_button.dart` by moving `_EventButton`**

Cut `_EventButton` and `_EventButtonState` (from `class _EventButton extends ConsumerStatefulWidget {` down to the closing brace of `_EventButtonState`, just before the `/// Human-readable stage for a fixture` comment) out of `hub_screen.dart` into the new file. Bring every import the moved code uses (run `flutter analyze lib/features/hub/hub_event_button.dart` and add what it reports missing). Then make exactly these changes:

1. Rename `_EventButton` to `HubEventButton` and `_EventButtonState` to `_HubEventButtonState`; add `this.compact = false` to the constructor and a field:

```dart
  /// The top-bar variant: no subtitle under it, and not the tour's target
  /// (the hub's own button is; one GlobalKey cannot sit on two widgets).
  final bool compact;
```

2. Add the shared busy flag above the class, and delete the `bool _busy = false;` field (keep its comment on the provider):

```dart
/// Whether a world-simulating step started by a hub action is running.
///
/// Shared by every [HubEventButton] for a career: on a tablet the top bar and
/// the hub both show one, and two taps must not start two advances.
final StateProviderFamily<bool, int> hubActionBusyProvider =
    StateProvider.family<bool, int>((ref, careerId) => false);
```

3. In `build`, read the flag and honour `compact`:

```dart
    final busy = ref.watch(hubActionBusyProvider(careerId));
    final button = PrimaryButton(
      key: widget.compact ? null : TourKeys.hubAction,
      label: event?.label ?? l.hubContinue,
      icon: event?.icon ?? Icons.play_arrow_rounded,
      isLoading: busy,
      onPressed: event == null ? null : () => _dispatch(context, ref, event),
    );
    if (widget.compact) return button;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        // ... the existing subtitle block, unchanged
      ],
    );
```

4. Replace the body of `_guarded`'s busy handling:

```dart
  void _guarded(BuildContext context, Future<void> Function() op) {
    // Read once: the notifier outlives this widget, `ref` does not.
    final busy = ref.read(hubActionBusyProvider(careerId).notifier);
    if (busy.state) return;
    busy.state = true;
    unawaited(() async {
      try {
        await op();
      } on Object catch (e, st) {
        // ... existing error handling, unchanged
      } finally {
        busy.state = false;
      }
    }());
  }
```

5. In `hub_screen.dart`, import `hub_event_button.dart` and replace the one use `_EventButton(careerId: careerId)` with `HubEventButton(careerId: careerId)`. Remove imports that `flutter analyze` now reports unused.

- [ ] **Step 4: Run the new test, expect PASS**

Run: `flutter test test/widget/hub_event_button_test.dart`

- [ ] **Step 5: Phone guard: the existing hub tests still pass**

Run: `flutter test test/widget/hub_tour_news_test.dart test/widget/hub_ranking_test.dart test/widget/tour_navigation_test.dart test/unit/hub`
Expected: PASS, unchanged.

- [ ] **Step 6: Commit**

```bash
git add lib/features/hub/hub_event_button.dart lib/features/hub/hub_screen.dart test/widget/hub_event_button_test.dart
git commit -m "refactor(hub): public HubEventButton with a shared busy flag

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 6: Sidebar model and `TabletSidebar`

**Files:**
- Create: `lib/features/shell/shell_destinations.dart`, `lib/features/shell/tablet_sidebar.dart`
- Test: `test/unit/shell/shell_destinations_test.dart`, `test/widget/tablet_sidebar_test.dart`

**Interfaces:**
- Produces:
  - `enum ShellSection { home, team, competitions, federation, history }`
  - `enum ShellDestinationId { hub, inbox, y, squad, tactics, callUps, youth, tournaments, nationsCup, ranking, results, finances, board, manager, records, legends, headToHead, achievements, career }`
  - `class ShellDestination { final ShellDestinationId id; final ShellSection section; final IconData icon; final String path; final Map<String, String> query; final Set<String> alsoActiveOn; String location(int careerId); }`
  - `const List<ShellDestination> shellDestinations`
  - `ShellDestinationId? activeDestination(Uri uri)`
  - `String shellSectionTitle(AppLocalizations l, ShellSection s)`, `String shellDestinationLabel(AppLocalizations l, ShellDestinationId id)`
  - `class TabletSidebar extends StatelessWidget { const TabletSidebar({required int careerId, required Uri location, Key? key}); static const double width = 208; }`

- [ ] **Step 1: Write the failing unit test**

`test/unit/shell/shell_destinations_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/shell_destinations.dart';

void main() {
  Uri u(String s) => Uri.parse(s);

  test('every destination keeps the career in its link', () {
    for (final d in shellDestinations) {
      expect(
        Uri.parse(d.location(7)).queryParameters['careerId'],
        '7',
        reason: d.id.name,
      );
    }
  });

  test('squad and tactics share a screen but not a highlight', () {
    expect(activeDestination(u('/tactics?careerId=1&tab=3')), ShellDestinationId.squad);
    expect(activeDestination(u('/tactics?careerId=1')), ShellDestinationId.tactics);
    expect(activeDestination(u('/tactics?careerId=1&tab=1')), ShellDestinationId.tactics);
  });

  test('screens under a destination light it up', () {
    expect(activeDestination(u('${Routes.cup}?careerId=1')), ShellDestinationId.tournaments);
    expect(activeDestination(u('${Routes.careerSummary}?careerId=1')), ShellDestinationId.career);
  });

  test('a screen with no home in the sidebar lights nothing', () {
    expect(activeDestination(u('${Routes.player}?careerId=1&playerId=4')), isNull);
  });

  test('event-only screens are not in the sidebar', () {
    final paths = shellDestinations.map((d) => d.path).toSet();
    expect(paths, isNot(contains(Routes.trainingCamp)));
    expect(paths, isNot(contains(Routes.naturalization)));
  });
}
```

- [ ] **Step 2: Run, expect FAIL**

Run: `flutter test test/unit/shell/shell_destinations_test.dart`

- [ ] **Step 3: Implement `shell_destinations.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The sidebar's headings, top to bottom.
enum ShellSection { home, team, competitions, federation, history }

enum ShellDestinationId {
  hub,
  inbox,
  y,
  squad,
  tactics,
  callUps,
  youth,
  tournaments,
  nationsCup,
  ranking,
  results,
  finances,
  board,
  manager,
  records,
  legends,
  headToHead,
  achievements,
  career,
}

/// One entry in the tablet sidebar.
///
/// Training camp and naturalization are deliberately absent: they are event
/// screens the Continue button opens when they are due, and have nothing to
/// show when opened cold.
class ShellDestination {
  const ShellDestination({
    required this.id,
    required this.section,
    required this.icon,
    required this.path,
    this.query = const {},
    this.alsoActiveOn = const {},
  });

  final ShellDestinationId id;
  final ShellSection section;
  final IconData icon;
  final String path;

  /// Extra query parameters that pick out this destination when two share a
  /// path (Squad is the tactics screen opened on its squad tab).
  final Map<String, String> query;

  /// Other screens that sit under this one, so it stays lit while they are up.
  final Set<String> alsoActiveOn;

  String location(int careerId) => Uri(
    path: path,
    queryParameters: {'careerId': '$careerId', ...query},
  ).toString();
}

const List<ShellDestination> shellDestinations = [
  ShellDestination(
    id: ShellDestinationId.hub,
    section: ShellSection.home,
    icon: Icons.grid_view,
    path: Routes.hub,
    alsoActiveOn: {Routes.matchPreview, Routes.roundResults},
  ),
  ShellDestination(
    id: ShellDestinationId.inbox,
    section: ShellSection.home,
    icon: Icons.mail_outline,
    path: Routes.messages,
  ),
  ShellDestination(
    id: ShellDestinationId.y,
    section: ShellSection.home,
    icon: Icons.tag,
    path: Routes.y,
  ),
  ShellDestination(
    id: ShellDestinationId.squad,
    section: ShellSection.team,
    icon: Icons.groups,
    path: Routes.tactics,
    query: {'tab': '3'},
  ),
  ShellDestination(
    id: ShellDestinationId.tactics,
    section: ShellSection.team,
    icon: Icons.sports_soccer,
    path: Routes.tactics,
  ),
  ShellDestination(
    id: ShellDestinationId.callUps,
    section: ShellSection.team,
    icon: Icons.how_to_reg,
    path: Routes.callUps,
  ),
  ShellDestination(
    id: ShellDestinationId.youth,
    section: ShellSection.team,
    icon: Icons.child_care,
    path: Routes.youth,
  ),
  ShellDestination(
    id: ShellDestinationId.tournaments,
    section: ShellSection.competitions,
    icon: Icons.emoji_events,
    path: Routes.tournaments,
    alsoActiveOn: {
      Routes.cup,
      Routes.continental,
      Routes.continentalClash,
      Routes.intercontinentalPlayoff,
    },
  ),
  ShellDestination(
    id: ShellDestinationId.nationsCup,
    section: ShellSection.competitions,
    icon: Icons.layers,
    path: Routes.nationsCup,
  ),
  ShellDestination(
    id: ShellDestinationId.ranking,
    section: ShellSection.competitions,
    icon: Icons.leaderboard,
    path: Routes.ranking,
  ),
  ShellDestination(
    id: ShellDestinationId.results,
    section: ShellSection.competitions,
    icon: Icons.scoreboard,
    path: Routes.results,
    alsoActiveOn: {Routes.friendlies},
  ),
  ShellDestination(
    id: ShellDestinationId.finances,
    section: ShellSection.federation,
    icon: Icons.account_balance,
    path: Routes.finances,
    alsoActiveOn: {Routes.budgetSetup},
  ),
  ShellDestination(
    id: ShellDestinationId.board,
    section: ShellSection.federation,
    icon: Icons.flag,
    path: Routes.boardObjectives,
  ),
  ShellDestination(
    id: ShellDestinationId.manager,
    section: ShellSection.federation,
    icon: Icons.badge_outlined,
    path: Routes.manager,
  ),
  ShellDestination(
    id: ShellDestinationId.records,
    section: ShellSection.history,
    icon: Icons.menu_book,
    path: Routes.records,
    alsoActiveOn: {Routes.allTimeRecords},
  ),
  ShellDestination(
    id: ShellDestinationId.legends,
    section: ShellSection.history,
    icon: Icons.star_outline,
    path: Routes.legends,
  ),
  ShellDestination(
    id: ShellDestinationId.headToHead,
    section: ShellSection.history,
    icon: Icons.compare_arrows,
    path: Routes.headToHead,
    alsoActiveOn: {Routes.h2hMeetings},
  ),
  ShellDestination(
    id: ShellDestinationId.achievements,
    section: ShellSection.history,
    icon: Icons.military_tech,
    path: Routes.achievements,
    alsoActiveOn: {Routes.challenges},
  ),
  ShellDestination(
    id: ShellDestinationId.career,
    section: ShellSection.history,
    icon: Icons.account_circle,
    path: Routes.careers,
    alsoActiveOn: {Routes.careerSummary, Routes.managerHistory},
  ),
];

/// The destination to highlight for [uri], or null for a screen that has no
/// home in the sidebar (a player page, a nation page).
ShellDestinationId? activeDestination(Uri uri) {
  final onPath = shellDestinations.where((d) => d.path == uri.path).toList();
  if (onPath.isNotEmpty) {
    // Prefer the destination whose extra query matches; otherwise the plain
    // one. `/tactics?tab=3` is Squad, any other `/tactics` is Tactics.
    for (final d in onPath) {
      if (d.query.isNotEmpty &&
          d.query.entries.every((e) => uri.queryParameters[e.key] == e.value)) {
        return d.id;
      }
    }
    return onPath.firstWhere((d) => d.query.isEmpty, orElse: () => onPath.first).id;
  }
  for (final d in shellDestinations) {
    if (d.alsoActiveOn.contains(uri.path)) return d.id;
  }
  return null;
}

String shellSectionTitle(AppLocalizations l, ShellSection s) => switch (s) {
  ShellSection.home => l.sideGroupHome,
  ShellSection.team => l.sideGroupTeam,
  ShellSection.competitions => l.sideGroupCompetitions,
  ShellSection.federation => l.sideGroupFederation,
  ShellSection.history => l.sideGroupHistory,
};

String shellDestinationLabel(AppLocalizations l, ShellDestinationId id) =>
    switch (id) {
      ShellDestinationId.hub => l.navHub,
      ShellDestinationId.inbox => l.sideInbox,
      ShellDestinationId.y => l.navY,
      ShellDestinationId.squad => l.sideSquad,
      ShellDestinationId.tactics => l.sideTactics,
      ShellDestinationId.callUps => l.sideCallUps,
      ShellDestinationId.youth => l.youthTitle,
      ShellDestinationId.tournaments => l.sideTournaments,
      ShellDestinationId.nationsCup => l.resultsCategoryNationsCup,
      ShellDestinationId.ranking => l.sideRanking,
      ShellDestinationId.results => l.sideResults,
      ShellDestinationId.finances => l.sideFinances,
      ShellDestinationId.board => l.sideBoard,
      ShellDestinationId.manager => l.sideManager,
      ShellDestinationId.records => l.sideRecords,
      ShellDestinationId.legends => l.sideLegends,
      ShellDestinationId.headToHead => l.sideHeadToHead,
      ShellDestinationId.achievements => l.sideAchievements,
      ShellDestinationId.career => l.sideCareer,
    };
```

Before relying on the tab index, confirm in `lib/features/tactics/tactics_screen.dart` (around line 120) that the squad tab is the fourth tab (index 3: Lineup, Instructions, Roles & set pieces, Squad). If the order differs, change `{'tab': '3'}` and the test to match.

- [ ] **Step 4: Run, expect PASS**

Run: `flutter test test/unit/shell/shell_destinations_test.dart`

- [ ] **Step 5: Write the failing sidebar widget test**

`test/widget/tablet_sidebar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('highlights the current destination and navigates on tap', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1194, 834);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/hub?careerId=3',
      routes: [
        for (final p in ['/hub', '/messages', '/settings'])
          GoRoute(
            path: p,
            builder: (context, state) => Scaffold(
              body: Row(
                children: [
                  TabletSidebar(careerId: 3, location: state.uri),
                  Expanded(child: Text('at ${state.uri}')),
                ],
              ),
            ),
          ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.theme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Section headings are drawn in capitals.
    expect(find.text('COMPETITIONS'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sidebar.hub.active')),
      findsOneWidget,
    );

    await tester.tap(find.text('Inbox'));
    await tester.pumpAndSettle();
    expect(find.text('at /messages?careerId=3'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('sidebar.inbox.active')),
      findsOneWidget,
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.textContaining('at /settings'), findsOneWidget);
  });
}
```

- [ ] **Step 6: Run, expect FAIL**

- [ ] **Step 7: Implement `tablet_sidebar.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/features/shell/shell_destinations.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:go_router/go_router.dart';

/// The tablet's left-hand navigation: every area of the game, grouped the way
/// a desktop manager game groups them, one tap apart.
class TabletSidebar extends StatelessWidget {
  const TabletSidebar({
    required this.careerId,
    required this.location,
    super.key,
  });

  static const double width = 208;

  final int careerId;
  final Uri location;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final active = activeDestination(location);
    return Container(
      width: width,
      color: AppColors.surfaceContainerLowest,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md - 4,
              ),
              children: [
                for (final section in ShellSection.values) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                    child: Text(
                      shellSectionTitle(l, section).toUpperCase(),
                      style: TabletText.sectionLabel,
                    ),
                  ),
                  for (final d in shellDestinations.where(
                    (d) => d.section == section,
                  ))
                    _Item(
                      key: ValueKey(
                        'sidebar.${d.id.name}${d.id == active ? '.active' : ''}',
                      ),
                      icon: d.icon,
                      label: shellDestinationLabel(l, d.id),
                      active: d.id == active,
                      onTap: () => context.go(d.location(careerId)),
                    ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: _Item(
              icon: Icons.settings_outlined,
              label: l.homeSettings,
              active: false,
              // Pushed, as from the hub, so its back arrow returns here.
              onTap: () => context.push(Routes.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.onSurface : AppColors.onSurfaceVariant;
    return Material(
      color: active ? AppColors.surfaceContainerHighest : Colors.transparent,
      borderRadius: AppRadii.baseAll,
      child: InkWell(
        borderRadius: AppRadii.baseAll,
        onTap: onTap,
        child: SizedBox(
          height: AppSpacing.minHitArea - 8,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TabletText.navItem.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

This needs `TabletText` (Task 9 creates the file). Create `lib/shared/tablet/tablet_text.dart` now with the full content from Task 9 Step 1 so this task compiles; Task 9 then only adds its test.

The sidebar item rows are 36 px. That is below the 44 px phone hit area on purpose: this is a dense desktop-style list on a large screen, and the whole row width is the target.

- [ ] **Step 8: Run, expect PASS**

Run: `flutter test test/widget/tablet_sidebar_test.dart`

- [ ] **Step 9: Commit**

```bash
git add lib/features/shell lib/shared/tablet/tablet_text.dart test/unit/shell test/widget/tablet_sidebar_test.dart
git commit -m "feat(tablet): sidebar destinations and widget

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 7: `TabletTopBar`

**Files:**
- Create: `lib/features/shell/tablet_top_bar.dart`
- Test: `test/widget/tablet_top_bar_test.dart`

**Interfaces:**
- Consumes: `hubDataProvider(int)` → `HubData?` (`lib/features/hub/hub_providers.dart`), `unreadMessagesProvider(int)` → `int` (`lib/features/messages/message_providers.dart`), `HubEventButton(careerId:, compact: true)` (Task 5), `MatchStage.label(AppLocalizations, Fixture)` (`lib/core/util/match_stage.dart`), `AppDate.dayMonthYear` (`lib/core/util/app_date.dart`), `FlagDisc(code, size:)`.
- Produces: `class TabletTopBar extends ConsumerWidget { const TabletTopBar({required int careerId, Key? key}); static const double height = 56; }`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

HubData _hub({required bool drawWatched}) => HubData(
  career: Career(
    id: 1,
    managerName: 'M',
    nationId: 1,
    rngSeed: 1,
    createdAt: DateTime(2026),
    inGameDate: DateTime(2027, 9, 7),
  ),
  group: null,
  next: Fixture(
    id: 9,
    careerId: 1,
    competitionId: 1,
    matchday: 5,
    date: DateTime(2027, 9, 10),
    homeNationId: 1,
    awayNationId: 2,
  ),
  fixtures: const [],
  nations: {
    1: nation(id: 1, name: 'Czechia'),
    2: nation(id: 2, name: 'Norway'),
  },
  squadSize: 23,
  squadRating: 75,
  championNationId: null,
  hasFinals: false,
  nextDrawWatched: drawWatched,
);

Future<void> _pump(WidgetTester tester, HubData hub, {int unread = 0}) async {
  tester.view.physicalSize = const Size(1194, 834);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    const Scaffold(body: TabletTopBar(careerId: 1)),
    overrides: [
      hubDataProvider(1).overrideWith((ref) async => hub),
      unreadMessagesProvider(1).overrideWith((ref) async => unread),
      nextEventProvider(1).overrideWith(
        (ref) async => const HubEvent(
          kind: HubEventKind.advance,
          label: 'Continue',
          icon: Icons.play_arrow_rounded,
        ),
      ),
    ],
  );
  await tester.pump();
}

void main() {
  testWidgets('shows the nation, the next fixture and Continue', (tester) async {
    await _pump(tester, _hub(drawWatched: true), unread: 3);
    expect(find.text('Czechia'), findsWidgets);
    expect(find.textContaining('Norway'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the opponent hidden until the draw is watched', (
    tester,
  ) async {
    await _pump(tester, _hub(drawWatched: false));
    expect(find.textContaining('Norway'), findsNothing);
    expect(find.textContaining('Draw to come'), findsOneWidget);
  });
}
```

If `Career`'s constructor requires more fields than shown, copy the minimum from an existing test that builds a `Career` (search `test/` for `Career(`).

- [ ] **Step 2: Run, expect FAIL**

Run: `flutter test test/widget/tablet_top_bar_test.dart`

- [ ] **Step 3: Implement `tablet_top_bar.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/features/hub/hub_event_button.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';
import 'package:go_router/go_router.dart';

/// The bar across the top of every in-save tablet screen: who you are, what
/// day it is, what is next, and the button that moves the world on.
class TabletTopBar extends ConsumerWidget {
  const TabletTopBar({required this.careerId, super.key});

  static const double height = 56;

  final int careerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final hub = ref.watch(hubDataProvider(careerId)).valueOrNull;
    final unread = ref.watch(unreadMessagesProvider(careerId)).valueOrNull ?? 0;
    final nation = hub?.nations[hub.career.nationId];
    final next = hub?.next;
    return Container(
      height: height,
      color: AppColors.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          if (nation != null) ...[
            FlagDisc(nation.code, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Text(nation.name, style: TabletText.barTitle),
            const SizedBox(width: AppSpacing.lg),
          ],
          if (hub != null)
            Text(
              AppDate.dayMonthYear(context, hub.career.inGameDate),
              style: TabletText.barMeta,
            ),
          if (hub != null && next != null) ...[
            const SizedBox(width: AppSpacing.md),
            Flexible(child: _NextChip(hub: hub, next: next)),
          ],
          const Spacer(),
          IconButton(
            tooltip: l.hubMessages,
            onPressed: () =>
                context.go('${Routes.messages}?careerId=$careerId'),
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.mail_outline, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 220,
            child: HubEventButton(careerId: careerId, compact: true),
          ),
        ],
      ),
    );
  }
}

class _NextChip extends StatelessWidget {
  const _NextChip({required this.hub, required this.next});

  final HubData hub;
  final Fixture next;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    String name(int id) => hub.nations[id]?.name ?? l.hubUnknown;
    // The hub keeps the opponent back until the draw has been watched; the
    // top bar must not give it away first.
    final teams = hub.nextDrawWatched
        ? '${name(next.homeNationId)} ${l.hubVs.toLowerCase()} '
              '${name(next.awayNationId)}'
        : l.topBarDrawPending;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadii.lgAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '${l.topBarNext}  ', style: TabletText.barMeta),
            TextSpan(text: teams, style: TabletText.barStrong),
            TextSpan(
              text: '  ${MatchStage.label(l, next)}, '
                  '${AppDate.dayMonth(context, next.date)}',
              style: TabletText.barMeta,
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
```

Check `MatchStage.label`'s signature in `lib/core/util/match_stage.dart` (the hub calls it as `MatchStage.label(l, f)`); `AppDate.dayMonth(context, date)` exists at `lib/core/util/app_date.dart:78`.

- [ ] **Step 4: Run, expect PASS**

Run: `flutter test test/widget/tablet_top_bar_test.dart`

- [ ] **Step 5: Commit**

```bash
git add lib/features/shell/tablet_top_bar.dart test/widget/tablet_top_bar_test.dart
git commit -m "feat(tablet): top bar with next fixture, inbox and Continue

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 8: `TabletShell`, `PhoneWidthFrame` and the tablet router

**Files:**
- Create: `lib/features/shell/tablet_shell.dart`
- Modify: `lib/core/routing/app_router.dart`
- Test: `test/widget/tablet_shell_test.dart`, `test/unit/core/routing/tablet_router_test.dart`

**Interfaces:**
- Consumes: `formFactorProvider`, `BuildContext.isTabletWindow` (Task 1), `TabletShellScope` (Task 4), `TabletSidebar` (Task 6), `TabletTopBar` (Task 7).
- Produces: `class TabletShell extends StatelessWidget { const TabletShell({required Uri location, required Widget child, Key? key}); }`; `class PhoneWidthFrame extends StatelessWidget { const PhoneWidthFrame({required Widget child, Key? key}); static const double maxWidth = 600; }`; `const Set<String> tabletReadyPaths` (empty this stage); `Routes.fullScreen` (`Set<String>`).

- [ ] **Step 1: Write the failing shell widget test**

`test/widget/tablet_shell_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/messages/message_providers.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';

import '../helpers/pump_app.dart';

void main() {
  final overrides = [
    hubDataProvider(1).overrideWith((ref) async => null),
    unreadMessagesProvider(1).overrideWith((ref) async => 0),
    nextEventProvider(1).overrideWith(
      (ref) async => const HubEvent(
        kind: HubEventKind.advance,
        label: 'Continue',
        icon: Icons.play_arrow_rounded,
      ),
    ),
  ];
  const screen = Scaffold(body: Text('the screen'));

  Future<void> pump(WidgetTester tester, Size size, String location) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      TabletShell(location: Uri.parse(location), child: screen),
      overrides: overrides,
    );
    await tester.pump();
  }

  testWidgets('on a tablet the screen sits inside sidebar and top bar', (
    tester,
  ) async {
    await pump(tester, const Size(1194, 834), '/hub?careerId=1');
    expect(find.byType(TabletSidebar), findsOneWidget);
    expect(find.byType(TabletTopBar), findsOneWidget);
    expect(find.text('the screen'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a screen with no tablet layout yet is held at phone width', (
    tester,
  ) async {
    await pump(tester, const Size(1194, 834), '/hub?careerId=1');
    final frame = tester.getSize(find.byType(PhoneWidthFrame));
    final inner = tester.getSize(find.byType(Scaffold).last);
    expect(frame.width, greaterThan(PhoneWidthFrame.maxWidth));
    expect(inner.width, PhoneWidthFrame.maxWidth);
  });

  testWidgets('a split-view window gets the plain phone screen', (
    tester,
  ) async {
    await pump(tester, const Size(507, 834), '/hub?careerId=1');
    expect(find.byType(TabletSidebar), findsNothing);
    expect(find.text('the screen'), findsOneWidget);
  });

  testWidgets('no career in the link: no shell', (tester) async {
    await pump(tester, const Size(1194, 834), '/hub');
    expect(find.byType(TabletSidebar), findsNothing);
    expect(find.text('the screen'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run, expect FAIL**

Run: `flutter test test/widget/tablet_shell_test.dart`

- [ ] **Step 3: Implement `tablet_shell.dart`**

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/features/shell/tablet_sidebar.dart';
import 'package:fnm/features/shell/tablet_top_bar.dart';
import 'package:fnm/shared/tablet/tablet_shell_scope.dart';

/// Route paths whose screens have a tablet layout and may use the whole
/// content area. Everything else is drawn at phone width (see
/// [PhoneWidthFrame]). Each later stage adds the screens it converts.
const Set<String> tabletReadyPaths = <String>{};

/// The tablet frame around every in-save screen: sidebar on the left, top bar
/// above, the routed screen in what is left.
///
/// Steps aside entirely (returns [child]) when there is no save in the link,
/// or when the window is not tablet sized, as in iPad split view.
class TabletShell extends StatelessWidget {
  const TabletShell({required this.location, required this.child, super.key});

  final Uri location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final careerId = int.tryParse(location.queryParameters['careerId'] ?? '');
    if (careerId == null || careerId <= 0 || !context.isTabletWindow) {
      return child;
    }
    final content = tabletReadyPaths.contains(location.path)
        ? child
        : PhoneWidthFrame(child: child);
    return TabletShellScope(
      child: ColoredBox(
        color: AppColors.surface,
        child: SafeArea(
          child: Row(
            children: [
              TabletSidebar(careerId: careerId, location: location),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.outlineVariant,
              ),
              Expanded(
                child: Column(
                  children: [
                    TabletTopBar(careerId: careerId),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.outlineVariant,
                    ),
                    Expanded(child: content),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a phone screen in the middle of a wider area, at most [maxWidth]
/// wide, and tells it so: the [MediaQuery] it sees is the frame's size, so
/// anything it sizes from the screen comes out as it would on a large phone.
class PhoneWidthFrame extends StatelessWidget {
  const PhoneWidthFrame({required this.child, super.key});

  static const double maxWidth = 600;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, maxWidth);
        final media = MediaQuery.of(context);
        return Center(
          child: SizedBox(
            width: width,
            height: constraints.maxHeight,
            child: MediaQuery(
              data: media.copyWith(
                size: Size(width, constraints.maxHeight),
                padding: EdgeInsets.zero,
                viewPadding: EdgeInsets.zero,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Run, expect PASS**

Run: `flutter test test/widget/tablet_shell_test.dart`

- [ ] **Step 5: Write the failing router parity test**

`test/unit/core/routing/tablet_router_test.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

Set<String> _paths(List<RouteBase> routes) => {
  for (final r in routes) ...[
    if (r is GoRoute) r.path,
    ..._paths(r.routes),
  ],
};

List<RouteBase> _routes(FormFactor f) {
  final container = ProviderContainer(
    overrides: [formFactorProvider.overrideWithValue(f)],
  );
  addTearDown(container.dispose);
  return container.read(routerProvider).configuration.routes;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the phone router has no shell', () {
    expect(_routes(FormFactor.phone).whereType<ShellRoute>(), isEmpty);
  });

  test('the tablet router registers exactly the phone routes', () {
    expect(_paths(_routes(FormFactor.tablet)), _paths(_routes(FormFactor.phone)));
  });

  test('full-screen routes sit outside the shell, the rest inside it', () {
    final tablet = _routes(FormFactor.tablet);
    final shells = tablet.whereType<ShellRoute>().toList();
    expect(shells, hasLength(1));
    final inShell = _paths(shells.single.routes);
    final topLevel = {for (final r in tablet) if (r is GoRoute) r.path};
    expect(topLevel, Routes.fullScreen);
    expect(inShell.intersection(Routes.fullScreen), isEmpty);
    expect(inShell, containsAll([Routes.hub, Routes.messages, Routes.tactics]));
  });
}
```

- [ ] **Step 6: Run, expect FAIL** (`Routes.fullScreen` missing, router ignores form factor)

Run: `flutter test test/unit/core/routing/tablet_router_test.dart`

- [ ] **Step 7: Restructure `routerProvider`**

In `lib/core/routing/app_router.dart`:

1. Add imports: `package:fnm/core/layout/form_factor.dart` and `package:fnm/features/shell/tablet_shell.dart`.
2. Add to `Routes`:

```dart
  /// Routes drawn full screen on a tablet, outside the sidebar and top bar:
  /// the menus before a save is open, the screens with no save behind them,
  /// and the big occasions (a match, a draw, a kickoff, a new cycle).
  static const Set<String> fullScreen = {
    home,
    nations,
    saves,
    settings,
    diagnostics,
    startFromBottom,
    newGame,
    match,
    hostDraw,
    qualifyingDraw,
    finalsDraw,
    continentalDraw,
    nationsCupDraw,
    tournamentKickoff,
    cycleRollover,
    gallery,
  };
```

3. Change the provider body. Keep the existing `routes: [ ... ]` list literal exactly as it is, but assign it to a local first:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final formFactor = ref.watch(formFactorProvider);
  final routes = <GoRoute>[
    // ... the existing GoRoute entries, unchanged and in the same order
  ];
  return GoRouter(
    initialLocation: Routes.home,
    routes: formFactor == FormFactor.tablet ? _tabletRoutes(routes) : routes,
  );
});

/// The same routes, with every in-save screen inside the tablet shell.
List<RouteBase> _tabletRoutes(List<GoRoute> routes) => [
  ShellRoute(
    builder: (context, state, child) =>
        TabletShell(location: state.uri, child: child),
    routes: [
      for (final r in routes)
        if (!Routes.fullScreen.contains(r.path)) r,
    ],
  ),
  for (final r in routes)
    if (Routes.fullScreen.contains(r.path)) r,
];
```

If any other `GoRouter(...)` argument exists in the current constructor call (redirect, observers, errorBuilder), keep it unchanged. If the list contains a non-`GoRoute` entry, type it `List<RouteBase>` and filter with `r is GoRoute && ...`.

- [ ] **Step 8: Run the router tests and the existing routing tests**

Run: `flutter test test/unit/core/routing`
Expected: PASS, including `back_navigation_test.dart` unchanged.

- [ ] **Step 9: Run the whole suite**

Run: `flutter analyze && flutter test`
Expected: PASS. (Every existing test runs as phone.)

- [ ] **Step 10: Commit**

```bash
git add lib/features/shell/tablet_shell.dart lib/core/routing/app_router.dart test/widget/tablet_shell_test.dart test/unit/core/routing/tablet_router_test.dart
git commit -m "feat(tablet): shell route around in-save screens on tablets

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 9: Dense text styles, `Panel` and `DashboardGrid`

**Files:**
- Create (or complete): `lib/shared/tablet/tablet_text.dart`, `lib/shared/tablet/panel.dart`, `lib/shared/tablet/dashboard_grid.dart`
- Test: `test/widget/tablet_panel_grid_test.dart`

**Interfaces:**
- Produces: `abstract final class TabletText { static const TextStyle sectionLabel, navItem, barTitle, barMeta, barStrong, panelTitle, cell, cellNumeric, header; }`; `class Panel extends StatelessWidget { const Panel({required String title, required Widget child, Widget? action, EdgeInsetsGeometry padding, Key? key}); }`; `class DashboardTile { const DashboardTile({required int span, required Widget child}); }`; `class DashboardGrid extends StatelessWidget { const DashboardGrid({required List<DashboardTile> tiles, double gap = 12, Key? key}); }`

- [ ] **Step 1: `tablet_text.dart`** (skip if Task 6 already created it with this content)

```dart
import 'package:flutter/widgets.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_typography.dart';

/// The tablet's denser type: one step smaller than the phone's, for tables,
/// panels and the shell. Same faces and colours as [AppTypography].
abstract final class TabletText {
  static const sectionLabel = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    color: AppColors.outline,
  );
  static const navItem = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    color: AppColors.onSurfaceVariant,
  );
  static const barTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.onSurface,
  );
  static const barMeta = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    color: AppColors.onSurfaceVariant,
  );
  static const barStrong = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );
  static const panelTitle = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
    color: AppColors.onSurfaceVariant,
  );
  static const header = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.outline,
  );
  static const cell = TextStyle(
    fontFamily: AppFonts.sans,
    fontSize: 13,
    height: 1.2,
    color: AppColors.onSurface,
  );
  static const cellNumeric = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    height: 1.2,
    color: AppColors.onSurface,
  );
}
```

- [ ] **Step 2: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/dashboard_grid.dart';
import 'package:fnm/shared/tablet/panel.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('panel shows its title in capitals, action and body', (
    tester,
  ) async {
    await tester.pumpApp(
      Panel(
        title: 'Next match',
        action: TextButton(onPressed: () {}, child: const Text('Preview')),
        child: const Text('body'),
      ),
    );
    expect(find.text('NEXT MATCH'), findsOneWidget);
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('tiles fill 12 columns per row, sized by span', (tester) async {
    tester.view.physicalSize = const Size(1224, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      const Scaffold(
        body: SingleChildScrollView(
          child: DashboardGrid(
            gap: 12,
            tiles: [
              DashboardTile(span: 6, child: SizedBox(key: Key('a'), height: 40)),
              DashboardTile(span: 6, child: SizedBox(key: Key('b'), height: 80)),
              DashboardTile(span: 12, child: SizedBox(key: Key('c'), height: 40)),
            ],
          ),
        ),
      ),
    );
    final a = tester.getRect(find.byKey(const Key('a')));
    final b = tester.getRect(find.byKey(const Key('b')));
    final c = tester.getRect(find.byKey(const Key('c')));
    expect(a.top, b.top, reason: 'a and b share a row');
    expect(a.width, closeTo(606, 0.5)); // (1224 - 12) / 2
    expect(a.height, b.height, reason: 'a row is as tall as its tallest tile');
    expect(c.top, greaterThan(b.bottom));
    expect(c.width, closeTo(1224, 0.5));
  });
}
```

- [ ] **Step 3: Run, expect FAIL**

Run: `flutter test test/widget/tablet_panel_grid_test.dart`

- [ ] **Step 4: Implement `panel.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A titled box for tablet dashboards: tighter than `AppCard`, with a header
/// strip and an optional action on its right.
class Panel extends StatelessWidget {
  const Panel({
    required this.title,
    required this.child,
    this.action,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final String title;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadii.baseAll,
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: AppRadii.baseAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 34,
              color: AppColors.surfaceContainer,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TabletText.panelTitle,
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Implement `dashboard_grid.dart`**

```dart
import 'package:flutter/widgets.dart';

/// One tile of a [DashboardGrid], [span] columns wide out of 12.
class DashboardTile {
  const DashboardTile({required this.span, required this.child})
    : assert(span >= 1 && span <= 12, 'span is 1 to 12');

  final int span;
  final Widget child;
}

/// Lays tiles out on a 12-column grid, left to right, starting a new row when
/// the next tile would not fit. Tiles in a row share the row's height.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({required this.tiles, this.gap = 12, super.key});

  final List<DashboardTile> tiles;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final rows = <List<DashboardTile>>[];
    var used = 12;
    for (final t in tiles) {
      if (used + t.span > 12) {
        rows.add([]);
        used = 0;
      }
      rows.last.add(t);
      used += t.span;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var j = 0; j < rows[i].length; j++) ...[
                  if (j > 0) SizedBox(width: gap),
                  Expanded(flex: rows[i][j].span, child: rows[i][j].child),
                ],
                // A short row keeps its tiles at their column width.
                if (_spanOf(rows[i]) < 12) ...[
                  SizedBox(width: gap),
                  Expanded(flex: 12 - _spanOf(rows[i]), child: const SizedBox()),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  static int _spanOf(List<DashboardTile> row) =>
      row.fold(0, (sum, t) => sum + t.span);
}
```

The test expects `a.width` of `(1224 - 12) / 2`. Flex splits the space left after the gap boxes, so two span-6 tiles get exactly that.

- [ ] **Step 6: Run, expect PASS**

Run: `flutter test test/widget/tablet_panel_grid_test.dart`

- [ ] **Step 7: Commit**

```bash
git add lib/shared/tablet/tablet_text.dart lib/shared/tablet/panel.dart lib/shared/tablet/dashboard_grid.dart test/widget/tablet_panel_grid_test.dart
git commit -m "feat(tablet): dense text, Panel and DashboardGrid

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 10: `MasterDetail`

**Files:**
- Create: `lib/shared/tablet/master_detail.dart`
- Test: `test/widget/master_detail_test.dart`

**Interfaces:**
- Produces: `class MasterDetail extends StatefulWidget { const MasterDetail({required Widget master, Widget? detail, Widget? placeholder, double initialFraction = 0.4, double minFraction = 0.25, double maxFraction = 0.6, Key? key}); static const Key dividerKey; }`; `class MasterDetailPlaceholder extends StatelessWidget { const MasterDetailPlaceholder({required String text, Key? key}); }`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/master_detail.dart';

import '../helpers/pump_app.dart';

void main() {
  Future<void> pump(WidgetTester tester, {Widget? detail}) async {
    tester.view.physicalSize = const Size(1000, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: MasterDetail(
          master: const SizedBox.expand(key: Key('master')),
          detail: detail,
          placeholder: const MasterDetailPlaceholder(text: 'Pick a player'),
        ),
      ),
    );
  }

  testWidgets('starts at 40/60 with the placeholder when nothing is picked', (
    tester,
  ) async {
    await pump(tester);
    expect(tester.getSize(find.byKey(const Key('master'))).width, 400);
    expect(find.text('Pick a player'), findsOneWidget);
  });

  testWidgets('shows the detail once there is one', (tester) async {
    await pump(tester, detail: const Text('Vondráček'));
    expect(find.text('Vondráček'), findsOneWidget);
    expect(find.text('Pick a player'), findsNothing);
  });

  testWidgets('the divider drags, and stops at the limits', (tester) async {
    await pump(tester);
    await tester.drag(find.byKey(MasterDetail.dividerKey), const Offset(100, 0));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 500);
    await tester.drag(find.byKey(MasterDetail.dividerKey), const Offset(900, 0));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 600);
    await tester.drag(find.byKey(MasterDetail.dividerKey), const Offset(-900, 0));
    await tester.pump();
    expect(tester.getSize(find.byKey(const Key('master'))).width, 250);
  });
}
```

- [ ] **Step 2: Run, expect FAIL**

- [ ] **Step 3: Implement**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// A list on the left and the picked item's detail on the right, split by a
/// divider the player can drag.
class MasterDetail extends StatefulWidget {
  const MasterDetail({
    required this.master,
    this.detail,
    this.placeholder,
    this.initialFraction = 0.4,
    this.minFraction = 0.25,
    this.maxFraction = 0.6,
    super.key,
  });

  static const Key dividerKey = Key('masterDetail.divider');

  final Widget master;
  final Widget? detail;
  final Widget? placeholder;
  final double initialFraction;
  final double minFraction;
  final double maxFraction;

  @override
  State<MasterDetail> createState() => _MasterDetailState();
}

class _MasterDetailState extends State<MasterDetail> {
  static const double _dividerWidth = 12;
  late double _fraction = widget.initialFraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final masterWidth = width * _fraction;
        return Row(
          children: [
            SizedBox(width: masterWidth, child: widget.master),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                key: MasterDetail.dividerKey,
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (d) => setState(() {
                  _fraction = ((masterWidth + d.delta.dx) / width).clamp(
                    widget.minFraction,
                    widget.maxFraction,
                  );
                }),
                child: SizedBox(
                  width: _dividerWidth,
                  child: Center(
                    child: Container(width: 1, color: AppColors.outlineVariant),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  widget.detail ?? widget.placeholder ?? const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}

/// What the detail side says while nothing is picked.
class MasterDetailPlaceholder extends StatelessWidget {
  const MasterDetailPlaceholder({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      text,
      style: TabletText.cell.copyWith(color: AppColors.outline),
    ),
  );
}
```

Note: the drag test moves 100 px in one gesture; `tester.drag` delivers it in several updates, each re-reading `masterWidth` from the rebuilt layout, so the total is 100. If the first assertion is off by the touch slop (`kDragSlopDefault`, 18 px), change the test to `tester.timedDrag` or assert `closeTo(500, 20)`, and keep the clamp assertions exact.

- [ ] **Step 4: Run, expect PASS**

Run: `flutter test test/widget/master_detail_test.dart`

- [ ] **Step 5: Commit**

```bash
git add lib/shared/tablet/master_detail.dart test/widget/master_detail_test.dart
git commit -m "feat(tablet): MasterDetail with a draggable divider

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 11: `DataGrid`

**Files:**
- Create: `lib/shared/tablet/data_grid.dart`, `lib/shared/tablet/tablet.dart`
- Test: `test/widget/data_grid_test.dart`

**Interfaces:**
- Produces:
  - `class GridColumn<T> { const GridColumn({required String id, required String label, required Widget Function(T row) cell, Comparable<dynamic> Function(T row)? sortKey, double? width, int flex = 1, bool numeric = false}); }`
  - `class GridColumnSet<T> { const GridColumnSet({required String id, required String label, required List<GridColumn<T>> columns}); }`
  - `class DataGrid<T> extends StatefulWidget { const DataGrid({required List<T> rows, required List<GridColumnSet<T>> columnSets, T? selected, ValueChanged<T>? onSelect, Key? key}); static const double rowHeight = 36; }`
  - `tablet.dart` exports `adaptive_sheet.dart` (after Task 12), `dashboard_grid.dart`, `data_grid.dart`, `master_detail.dart`, `panel.dart`, `tablet_shell_scope.dart`, `tablet_text.dart`.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/data_grid.dart';

import '../helpers/pump_app.dart';

typedef P = ({String name, int ovr, int age});

const _rows = <P>[
  (name: 'Staněk', ovr: 79, age: 29),
  (name: 'Kubišta', ovr: 76, age: 23),
  (name: 'Rejthar', ovr: 80, age: 30),
];

final _sets = <GridColumnSet<P>>[
  GridColumnSet(
    id: 'overview',
    label: 'Overview',
    columns: [
      GridColumn(id: 'name', label: 'Name', flex: 3, cell: (p) => Text(p.name), sortKey: (p) => p.name),
      GridColumn(id: 'ovr', label: 'OVR', width: 48, numeric: true, cell: (p) => Text('${p.ovr}'), sortKey: (p) => p.ovr),
    ],
  ),
  GridColumnSet(
    id: 'career',
    label: 'Career',
    columns: [
      GridColumn(id: 'name', label: 'Name', flex: 3, cell: (p) => Text(p.name), sortKey: (p) => p.name),
      GridColumn(id: 'age', label: 'Age', width: 48, numeric: true, cell: (p) => Text('${p.age}'), sortKey: (p) => p.age),
    ],
  ),
];

List<String> _order(WidgetTester tester) => tester
    .widgetList<Text>(find.byType(Text))
    .map((t) => t.data ?? '')
    .where((s) => ['Staněk', 'Kubišta', 'Rejthar'].contains(s))
    .toList();

Future<void> _pump(WidgetTester tester, {List<P> rows = _rows, ValueChanged<P>? onSelect, P? selected}) async {
  tester.view.physicalSize = const Size(800, 700);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: DataGrid<P>(rows: rows, columnSets: _sets, onSelect: onSelect, selected: selected),
    ),
  );
}

void main() {
  testWidgets('rows keep their given order until a header is tapped', (tester) async {
    await _pump(tester);
    expect(_order(tester), ['Staněk', 'Kubišta', 'Rejthar']);
  });

  testWidgets('a numeric column sorts high to low first, then reverses', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(_order(tester), ['Rejthar', 'Staněk', 'Kubišta']);
    await tester.tap(find.text('OVR'));
    await tester.pump();
    expect(_order(tester), ['Kubišta', 'Staněk', 'Rejthar']);
  });

  testWidgets('a text column sorts A to Z first', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Name'));
    await tester.pump();
    expect(_order(tester), ['Kubišta', 'Rejthar', 'Staněk']);
  });

  testWidgets('switching views swaps the columns', (tester) async {
    await _pump(tester);
    expect(find.text('OVR'), findsOneWidget);
    await tester.tap(find.text('Career'));
    await tester.pump();
    expect(find.text('OVR'), findsNothing);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('23'), findsOneWidget);
  });

  testWidgets('tapping a row selects it', (tester) async {
    P? picked;
    await _pump(tester, onSelect: (p) => picked = p);
    await tester.tap(find.text('Kubišta'));
    expect(picked?.name, 'Kubišta');
  });

  testWidgets('a long list builds only what is on screen', (tester) async {
    final many = [for (var i = 0; i < 2000; i++) (name: 'P$i', ovr: i % 99, age: 20)];
    await _pump(tester, rows: many);
    expect(find.text('P0'), findsOneWidget);
    expect(find.text('P1999'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
```

- [ ] **Step 2: Run, expect FAIL**

Run: `flutter test test/widget/data_grid_test.dart`

- [ ] **Step 3: Implement `data_grid.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet_text.dart';

/// One column of a [DataGrid].
class GridColumn<T> {
  const GridColumn({
    required this.id,
    required this.label,
    required this.cell,
    this.sortKey,
    this.width,
    this.flex = 1,
    this.numeric = false,
  });

  final String id;
  final String label;
  final Widget Function(T row) cell;

  /// Null makes the column unsortable.
  final Comparable<dynamic> Function(T row)? sortKey;

  /// A fixed width; when null the column takes [flex] shares of what is left.
  final double? width;
  final int flex;

  /// Right-aligned, and sorted high to low on the first tap.
  final bool numeric;
}

/// A named set of columns: one "view" of the same rows (Overview, Attributes).
class GridColumnSet<T> {
  const GridColumnSet({
    required this.id,
    required this.label,
    required this.columns,
  });

  final String id;
  final String label;
  final List<GridColumn<T>> columns;
}

/// The tablet's table: sticky header, tap a header to sort (again to reverse),
/// zebra rows, a highlighted selection, and several column views of the same
/// rows. Rows are built lazily, so a 2000-row list costs a screenful.
class DataGrid<T> extends StatefulWidget {
  const DataGrid({
    required this.rows,
    required this.columnSets,
    this.selected,
    this.onSelect,
    super.key,
  }) : assert(columnSets.length > 0, 'at least one column set');

  static const double rowHeight = 36;

  final List<T> rows;
  final List<GridColumnSet<T>> columnSets;
  final T? selected;
  final ValueChanged<T>? onSelect;

  @override
  State<DataGrid<T>> createState() => _DataGridState<T>();
}

class _DataGridState<T> extends State<DataGrid<T>> {
  late GridColumnSet<T> _set = widget.columnSets.first;
  String? _sortId;
  bool _ascending = true;

  List<GridColumn<T>> get _columns => _set.columns;

  List<T> get _sorted {
    final column = _columns.where((c) => c.id == _sortId).firstOrNull;
    final key = column?.sortKey;
    if (key == null) return widget.rows;
    final rows = [...widget.rows]
      ..sort((a, b) {
        final c = key(a).compareTo(key(b));
        return _ascending ? c : -c;
      });
    return rows;
  }

  void _tapHeader(GridColumn<T> c) {
    if (c.sortKey == null) return;
    setState(() {
      if (_sortId == c.id) {
        _ascending = !_ascending;
      } else {
        _sortId = c.id;
        _ascending = !c.numeric;
      }
    });
  }

  void _pickSet(GridColumnSet<T> s) => setState(() {
    _set = s;
    if (!s.columns.any((c) => c.id == _sortId)) _sortId = null;
  });

  @override
  Widget build(BuildContext context) {
    final rows = _sorted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.columnSets.length > 1)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final s in widget.columnSets)
                  ChoiceChip(
                    label: Text(s.label),
                    selected: s.id == _set.id,
                    onSelected: (_) => _pickSet(s),
                  ),
              ],
            ),
          ),
        Container(
          height: 30,
          color: AppColors.surfaceContainer,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (final c in _columns)
                _cellBox(
                  c,
                  InkWell(
                    onTap: () => _tapHeader(c),
                    child: Row(
                      mainAxisAlignment: c.numeric
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            c.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TabletText.header.copyWith(
                              color: c.id == _sortId
                                  ? AppColors.onSurface
                                  : null,
                            ),
                          ),
                        ),
                        if (c.id == _sortId)
                          Icon(
                            _ascending
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 16,
                            color: AppColors.onSurface,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rows.length,
            itemExtent: DataGrid.rowHeight,
            itemBuilder: (context, i) {
              final row = rows[i];
              final selected = widget.selected != null && row == widget.selected;
              return Material(
                color: selected
                    ? AppColors.surfaceContainerHighest
                    : i.isOdd
                    ? AppColors.onSurface.withValues(alpha: 0.015)
                    : Colors.transparent,
                child: InkWell(
                  onTap: widget.onSelect == null
                      ? null
                      : () => widget.onSelect!(row),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.divider)),
                    ),
                    child: Row(
                      children: [
                        for (final c in _columns)
                          _cellBox(
                            c,
                            Align(
                              alignment: c.numeric
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: DefaultTextStyle.merge(
                                style: c.numeric
                                    ? TabletText.cellNumeric
                                    : TabletText.cell,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                child: c.cell(row),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cellBox(GridColumn<T> c, Widget child) => c.width != null
      ? SizedBox(width: c.width, child: child)
      : Expanded(flex: c.flex, child: child);
}
```

The test's record type `({String name, int ovr, int age})` has value equality, so `row == widget.selected` works. `sortKey` is typed `Comparable<dynamic>` so both `String` and `int` keys are accepted.

- [ ] **Step 4: Create the barrel `lib/shared/tablet/tablet.dart`**

```dart
export 'dashboard_grid.dart';
export 'data_grid.dart';
export 'master_detail.dart';
export 'panel.dart';
export 'tablet_shell_scope.dart';
export 'tablet_text.dart';
```

- [ ] **Step 5: Run, expect PASS**

Run: `flutter test test/widget/data_grid_test.dart`

- [ ] **Step 6: Commit**

```bash
git add lib/shared/tablet/data_grid.dart lib/shared/tablet/tablet.dart test/widget/data_grid_test.dart
git commit -m "feat(tablet): DataGrid with sorting, views and lazy rows

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 12: `showAdaptiveSheet` and migration of all bottom sheets

**Files:**
- Create: `lib/shared/tablet/adaptive_sheet.dart`
- Modify (each `showModalBottomSheet<` becomes `showAdaptiveSheet<`, arguments unchanged):
  - `lib/features/settings/settings_screen.dart:45`
  - `lib/features/records/head_to_head_screen.dart:124`
  - `lib/features/match/match_screen.dart:373`
  - `lib/features/tactics/tactics_screen.dart:531, 643, 749, 1285`
  - `lib/features/tactics/formation_picker.dart:39`
  - `lib/features/tactics/squad_legend_sheet.dart:22`
  - `lib/features/tactics/in_match_tactics.dart:1218`
  - `lib/features/federation/staff_card.dart:66`
  - `lib/features/paywall/paywall_sheet.dart:13`
  - `lib/features/hub/hub_event_button.dart` (2 sites, moved there from `hub_screen.dart` in Task 5)
- Modify: `lib/shared/tablet/tablet.dart` (export)
- Test: `test/widget/adaptive_sheet_test.dart`, `test/unit/core/no_raw_bottom_sheets_test.dart`

**Interfaces:**
- Produces: `Future<T?> showAdaptiveSheet<T>({required BuildContext context, required WidgetBuilder builder, Color? backgroundColor, bool isScrollControlled = false, bool isDismissible = true, bool enableDrag = true, bool? showDragHandle})`
- Consumes: `BuildContext.isTabletWindow` (Task 1).

- [ ] **Step 1: Write the failing widget test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/adaptive_sheet.dart';

import '../helpers/pump_app.dart';

Future<void> _open(WidgetTester tester, Size size, {bool dismissible = true}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () => showAdaptiveSheet<void>(
            context: context,
            isDismissible: dismissible,
            builder: (_) => const Text('sheet body'),
          ),
          child: const Text('open'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('on a phone it is a bottom sheet, as before', (tester) async {
    await _open(tester, const Size(390, 844));
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('sheet body'), findsOneWidget);
  });

  testWidgets('on a tablet it is a centred dialog', (tester) async {
    await _open(tester, const Size(1194, 834));
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    final rect = tester.getRect(find.byType(Dialog));
    expect(rect.width, lessThanOrEqualTo(560));
    expect(rect.center.dx, closeTo(597, 1));
  });

  testWidgets('a sheet that must not be dismissed is not, on a tablet', (
    tester,
  ) async {
    await _open(tester, const Size(1194, 834), dismissible: false);
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('sheet body'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Write the failing guard test**

`test/unit/core/no_raw_bottom_sheets_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every sheet goes through `showAdaptiveSheet`, which is a bottom sheet on a
/// phone and a dialog on a tablet. A raw `showModalBottomSheet` would slide a
/// phone-width strip up the bottom of an iPad.
void main() {
  test('no raw showModalBottomSheet outside adaptive_sheet.dart', () {
    final offenders = <String>[];
    for (final f in Directory('lib').listSync(recursive: true)) {
      if (f is! File || !f.path.endsWith('.dart')) continue;
      if (f.path.endsWith('adaptive_sheet.dart')) continue;
      if (f.readAsStringSync().contains('showModalBottomSheet')) {
        offenders.add(f.path);
      }
    }
    expect(offenders, isEmpty);
  });
}
```

- [ ] **Step 3: Run both, expect FAIL**

Run: `flutter test test/widget/adaptive_sheet_test.dart test/unit/core/no_raw_bottom_sheets_test.dart`

- [ ] **Step 4: Implement `adaptive_sheet.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';

/// A bottom sheet on a phone, a centred dialog on a tablet.
///
/// Takes the same arguments the app's sheets already pass to
/// [showModalBottomSheet], and on a phone forwards them unchanged.
Future<T?> showAdaptiveSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
}) {
  if (!context.isTabletWindow) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
    );
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (dialogContext) {
      final height = MediaQuery.sizeOf(dialogContext).height;
      return Dialog(
        backgroundColor: backgroundColor ?? AppColors.surfaceContainer,
        insetPadding: const EdgeInsets.all(AppSpacing.xl),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          // Bounded both ways: sheets built around a DraggableScrollableSheet
          // or a ListView need a finite height to lay out in.
          constraints: BoxConstraints(maxWidth: 560, maxHeight: height * 0.85),
          child: Builder(builder: builder),
        ),
      );
    },
  );
}
```

Add `export 'adaptive_sheet.dart';` to `lib/shared/tablet/tablet.dart`.

- [ ] **Step 5: Run the widget test, expect PASS**

Run: `flutter test test/widget/adaptive_sheet_test.dart`

- [ ] **Step 6: Migrate every call site**

For each file listed above: add `import 'package:fnm/shared/tablet/adaptive_sheet.dart';`, then replace `showModalBottomSheet<` with `showAdaptiveSheet<`. Leave every argument as it is. Then:

```bash
grep -rn "showModalBottomSheet" lib | grep -v adaptive_sheet.dart
```

Expected: no output. If a call site passes an argument `showAdaptiveSheet` does not accept, the analyzer will say so; add that parameter to `showAdaptiveSheet` and forward it to `showModalBottomSheet` (ignored on tablet) rather than dropping it.

- [ ] **Step 7: Run the guard, the sheet-related tests, and the suite**

```bash
flutter test test/unit/core/no_raw_bottom_sheets_test.dart test/widget/formation_picker_test.dart test/widget/press_conference_test.dart test/widget/premium_gate_test.dart
flutter analyze && flutter test
```

Known effect on existing tests: Flutter's default test window is 2400 x 1800 physical at DPR 3.0, which is **800 x 600 logical**. Its shortest side is 600, so `isTabletWindow` is true there and any existing test that opens a sheet will now get a dialog. For each test that fails because it looks for a `BottomSheet` (or drags one), give that test a phone window at its start:

```dart
tester.view.physicalSize = const Size(390, 844);
tester.view.devicePixelRatio = 1;
addTearDown(tester.view.reset);
```

Do not change the 600 threshold to make tests pass: 600 dp is the 7in Android tablet class and is meant to count. List every test you changed in the task report.

- [ ] **Step 8: Commit**

```bash
git add lib test/widget/adaptive_sheet_test.dart test/unit/core/no_raw_bottom_sheets_test.dart
git commit -m "feat(tablet): adaptive sheets; every bottom sheet goes through them

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```

---

### Task 13: Record the stage 1 adjustments in the spec, verify on simulators

**Files:**
- Modify: `docs/superpowers/specs/2026-10-09-tablet-ui-design.md`

- [ ] **Step 1: Add a section to the spec, after "Phasing"**

```markdown
## Stage 1 adjustments (2026-10-09)

- Training camp and Naturalization are not in the sidebar: they are event
  screens that Continue opens when due.
- Settings, diagnostics and the dev gallery are full-screen routes outside the
  shell (no `careerId`, so no save for the top bar).
- `DetailPaneHost` and the `*View` extractions move to stage 2, where Squad
  first hosts a detail pane; `MasterDetail` ships in stage 1.
- Stage 1 checks route parity (every path registered on tablet, full-screen
  paths outside the shell). Pumping every route on a seeded save moves to
  stage 2.
- iPad uses `UIRequiresFullScreen` (required for landscape-only iPad apps).
```

- [ ] **Step 2: Full verification**

```bash
flutter analyze
flutter test
```

Expected: no analyzer issues; all tests pass. Paste the summary line of `flutter test` into the task report.

- [ ] **Step 3: iPad simulator check**

```bash
xcrun simctl list devices available | grep -i ipad
open -a Simulator
flutter run -d "<an iPad simulator id from the list>"
```

Check by hand, and report each:
1. The app opens in landscape and does not rotate to portrait.
2. Home, new game and saves are full screen (no sidebar).
3. Open a save: sidebar on the left, top bar with nation, date, next fixture and Continue; the hub is drawn at phone width in the middle; no bottom nav.
4. Every sidebar item opens its screen and lights up; Settings opens full screen and its back arrow returns.
5. Continue in the top bar advances the game; the hub's own button shows the spinner at the same time.
6. Play a match: the match screen is full screen; after it, the shell is back.
7. Open a sheet (Tactics, formation picker): it is a centred dialog.

- [ ] **Step 4: Android tablet emulator check**

```bash
flutter emulators   # pick or create a tablet AVD (e.g. Pixel Tablet)
flutter emulators --launch <id>
flutter run -d <emulator id>
```

Repeat checks 1 to 7. Also press the system back button on an in-shell screen and confirm it behaves as on a phone.

- [ ] **Step 5: Phone sanity check**

Run the app on an iPhone simulator. It must look and behave exactly as before: bottom nav present, no sidebar, sheets are bottom sheets, portrait works.

- [ ] **Step 6: Commit**

```bash
git add docs/superpowers/specs/2026-10-09-tablet-ui-design.md
git commit -m "docs: record tablet stage 1 adjustments in the spec

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
```
