import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// App-bar title on the pre-match preview screen.
  ///
  /// In en, this message translates to:
  /// **'MATCH PREVIEW'**
  String get matchPreviewTitle;

  /// Button that starts the live match.
  ///
  /// In en, this message translates to:
  /// **'Kick off'**
  String get matchKickOff;

  /// Button opening the lineup & tactics editor.
  ///
  /// In en, this message translates to:
  /// **'Tactics'**
  String get matchTactics;

  /// Heading above the manager's starting eleven.
  ///
  /// In en, this message translates to:
  /// **'YOUR XI'**
  String get matchYourXi;

  /// Heading on the head-to-head record card.
  ///
  /// In en, this message translates to:
  /// **'HEAD TO HEAD'**
  String get matchHeadToHead;

  /// Error shown when the match preview fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load match.\n{error}'**
  String matchCouldNotLoad(String error);

  /// Shown when the nation has no next fixture.
  ///
  /// In en, this message translates to:
  /// **'No upcoming match.'**
  String get matchNoUpcoming;

  /// Fallback name for a nation that can't be resolved.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get matchUnknownNation;

  /// Head-to-head summary when the sides have never met.
  ///
  /// In en, this message translates to:
  /// **'First-ever meeting'**
  String get matchH2hFirstMeeting;

  /// Head-to-head summary when the manager has more wins.
  ///
  /// In en, this message translates to:
  /// **'You lead the head-to-head'**
  String get matchH2hYouLead;

  /// Head-to-head summary when the opponent has more wins.
  ///
  /// In en, this message translates to:
  /// **'{opponent} have the edge'**
  String matchH2hOppEdge(String opponent);

  /// Head-to-head summary when wins are level.
  ///
  /// In en, this message translates to:
  /// **'Honours even'**
  String get matchH2hEven;

  /// Number of times the two sides have met.
  ///
  /// In en, this message translates to:
  /// **'{count} met'**
  String matchH2hMet(int count);

  /// Head-to-head tally label: matches won.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get matchH2hWon;

  /// Head-to-head tally label: matches drawn.
  ///
  /// In en, this message translates to:
  /// **'Drawn'**
  String get matchH2hDrawn;

  /// Head-to-head tally label: matches lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get matchH2hLost;

  /// Heading on the pre-match opponent dossier card.
  ///
  /// In en, this message translates to:
  /// **'Scouting report'**
  String get matchDossierTitle;

  /// Label before the opponent's recent-form strip.
  ///
  /// In en, this message translates to:
  /// **'FORM'**
  String get matchDossierForm;

  /// Shown when the opponent has no recent results.
  ///
  /// In en, this message translates to:
  /// **'No recent games'**
  String get matchDossierNoGames;

  /// Label above the opponent's danger men.
  ///
  /// In en, this message translates to:
  /// **'KEY MEN'**
  String get matchDossierKeyMen;

  /// Snackbar when advancing past the match fails.
  ///
  /// In en, this message translates to:
  /// **'Could not continue: {error}'**
  String matchCouldNotContinue(String error);

  /// Tooltip on the button that fast-forwards to the final whistle.
  ///
  /// In en, this message translates to:
  /// **'Skip to full time'**
  String get matchSkipToFullTime;

  /// Match stat bar label: shots.
  ///
  /// In en, this message translates to:
  /// **'Shots'**
  String get matchStatShots;

  /// Label on the live momentum bar.
  ///
  /// In en, this message translates to:
  /// **'MOMENTUM'**
  String get matchMomentum;

  /// Abbreviation for the attack swing from a team talk.
  ///
  /// In en, this message translates to:
  /// **'ATK'**
  String get matchSwingAtk;

  /// Abbreviation for the defensive swing from a team talk.
  ///
  /// In en, this message translates to:
  /// **'DEF'**
  String get matchSwingDef;

  /// Opening-ceremony banner heading with the edition year.
  ///
  /// In en, this message translates to:
  /// **'WORLD CUP {year}'**
  String ceremonyWorldCupYear(int year);

  /// Opening-ceremony tagline.
  ///
  /// In en, this message translates to:
  /// **'THE FINALS ARE HERE'**
  String get ceremonyFinalsAreHere;

  /// Opening-ceremony host line.
  ///
  /// In en, this message translates to:
  /// **'HOSTED BY  {hosts}'**
  String ceremonyHostedBy(String hosts);

  /// Shown when the host isn't known yet.
  ///
  /// In en, this message translates to:
  /// **'HOST TO BE CONFIRMED'**
  String get ceremonyHostTbc;

  /// Heading on the half-time interval overlay.
  ///
  /// In en, this message translates to:
  /// **'HALF TIME'**
  String get matchHalfTime;

  /// Button that resumes play from the interval.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get matchContinue;

  /// Tactics button on the interval overlay, with subs used.
  ///
  /// In en, this message translates to:
  /// **'Tactics · {used}/{max} subs'**
  String matchTacticsWithSubs(int used, int max);

  /// Live match control bar tactics pill label when players are out of energy; the substitution count is shown separately so it is never clipped.
  ///
  /// In en, this message translates to:
  /// **'TIRED ×{count}'**
  String matchTiredCount(int count);

  /// Live match control bar tactics pill label when no players are tired.
  ///
  /// In en, this message translates to:
  /// **'TACTICS'**
  String get matchTacticsLabel;

  /// Heading over the chart of a nation's overall rating by year.
  ///
  /// In en, this message translates to:
  /// **'OVERALL OVER TIME'**
  String get teamOverallOverTime;

  /// Label for a team's overall rating (the mean of its best eleven).
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get teamOverall;

  /// Heading above the interval team-talk options.
  ///
  /// In en, this message translates to:
  /// **'TEAM TALK'**
  String get teamTalkHeading;

  /// Prompt shown before a team talk is chosen.
  ///
  /// In en, this message translates to:
  /// **'Set the tone for the second half.'**
  String get teamTalkPrompt;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Calm heads'**
  String get teamTalkCalmLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Steady the side — a small all-round lift.'**
  String get teamTalkCalmBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Encourage'**
  String get teamTalkEncourageLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Push forward and go for the game.'**
  String get teamTalkEncourageBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Demand more'**
  String get teamTalkDemandMoreLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Throw everything at it — attack hard.'**
  String get teamTalkDemandMoreBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Keep it tight'**
  String get teamTalkPraiseLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Stay compact and protect what you have.'**
  String get teamTalkPraiseBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Believe'**
  String get teamTalkBelieveLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Back yourselves — lift both ends of the pitch.'**
  String get teamTalkBelieveBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Stay switched on'**
  String get teamTalkFocusLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Total concentration — lock the game down.'**
  String get teamTalkFocusBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'Sense of urgency'**
  String get teamTalkUrgencyLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Chase it down now — go all-out, leave gaps.'**
  String get teamTalkUrgencyBlurb;

  /// Team-talk tone button label.
  ///
  /// In en, this message translates to:
  /// **'No pressure'**
  String get teamTalkReassureLabel;

  /// Team-talk tone description.
  ///
  /// In en, this message translates to:
  /// **'Settle the nerves and keep your shape.'**
  String get teamTalkReassureBlurb;

  /// Generic retry button on an error placeholder.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Generic error-placeholder heading.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonSomethingWentWrong;

  /// Shown in place of a widget subtree that failed to build.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong here.\nSettings → Diagnostics has the details.'**
  String get commonCrashBox;

  /// Snackbar when a hub action that simulates the world fails.
  ///
  /// In en, this message translates to:
  /// **'Could not advance the world: {error}'**
  String hubCouldNotAdvance(String error);

  /// Settings row opening the on-device error log.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get settingsDiagnosticsTitle;

  /// Explains what the diagnostics log is and that it stays local.
  ///
  /// In en, this message translates to:
  /// **'Errors recorded on this device. Nothing is sent anywhere.'**
  String get settingsDiagnosticsBlurb;

  /// Placeholder when the error log is empty.
  ///
  /// In en, this message translates to:
  /// **'No errors recorded. That\'s the idea.'**
  String get diagnosticsEmpty;

  /// Button copying the whole error log to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get diagnosticsCopy;

  /// Confirmation that the log was copied.
  ///
  /// In en, this message translates to:
  /// **'Log copied to the clipboard.'**
  String get diagnosticsCopied;

  /// Button emptying the error log.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get diagnosticsClear;

  /// Bottom navigation label for the hub tab.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get navHub;

  /// Bottom navigation label for the squad/tactics tab.
  ///
  /// In en, this message translates to:
  /// **'Squad'**
  String get navSquad;

  /// Bottom navigation label for the tournaments/standings tab.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get navStandings;

  /// Bottom navigation label for the careers tab.
  ///
  /// In en, this message translates to:
  /// **'My Career'**
  String get navCareers;

  /// App-bar title on the settings screen.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// Sound-and-haptics toggle label.
  ///
  /// In en, this message translates to:
  /// **'Sound & haptics'**
  String get settingsSoundHapticsTitle;

  /// Sound-and-haptics toggle description.
  ///
  /// In en, this message translates to:
  /// **'Vibration and a short tone on goals, kick-off and full time.'**
  String get settingsSoundHapticsBlurb;

  /// Language selector label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Language selector description.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language, or follow your device.'**
  String get settingsLanguageBlurb;

  /// Language option: follow the device language.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// Language option: English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Language option: Czech (in Czech).
  ///
  /// In en, this message translates to:
  /// **'Čeština'**
  String get settingsLanguageCzech;

  /// App-bar title on the head-to-head meetings list.
  ///
  /// In en, this message translates to:
  /// **'MEETINGS'**
  String get recordsMeetings;

  /// Legends screen title / banner.
  ///
  /// In en, this message translates to:
  /// **'LEGENDS'**
  String get recordsLegends;

  /// Heading over the all-time best eleven.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME XI'**
  String get recordsAllTimeXi;

  /// Heading over the hall-of-fame list.
  ///
  /// In en, this message translates to:
  /// **'HALL OF FAME'**
  String get recordsHallOfFame;

  /// Title of the global all-time records screen / nav card.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME WORLD'**
  String get recordsAllTimeWorld;

  /// Leaderboard heading.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME TOP SCORERS'**
  String get recordsAllTimeTopScorers;

  /// Leaderboard heading (global most caps).
  ///
  /// In en, this message translates to:
  /// **'MOST CAPPED'**
  String get recordsMostCapped;

  /// Leaderboard heading.
  ///
  /// In en, this message translates to:
  /// **'MOST WORLD CUP STARTS'**
  String get recordsMostWcStarts;

  /// Leaderboard heading.
  ///
  /// In en, this message translates to:
  /// **'MOST TOURNAMENTS ATTENDED'**
  String get recordsMostTournaments;

  /// Record book screen title.
  ///
  /// In en, this message translates to:
  /// **'RECORD BOOK'**
  String get recordsRecordBook;

  /// Head-to-head screen title / nav card.
  ///
  /// In en, this message translates to:
  /// **'HEAD TO HEAD'**
  String get recordsHeadToHead;

  /// Heading on the fiercest-rival card.
  ///
  /// In en, this message translates to:
  /// **'FIERCEST RIVAL'**
  String get recordsFiercestRival;

  /// Leaderboard heading (nation most caps).
  ///
  /// In en, this message translates to:
  /// **'MOST CAPS'**
  String get recordsMostCaps;

  /// Leaderboard heading.
  ///
  /// In en, this message translates to:
  /// **'TOP SCORERS'**
  String get recordsTopScorers;

  /// Leaderboard heading.
  ///
  /// In en, this message translates to:
  /// **'MOST ASSISTS'**
  String get recordsMostAssists;

  /// Heading over the manager's head-to-head ledger.
  ///
  /// In en, this message translates to:
  /// **'YOUR RECORD'**
  String get recordsYourRecord;

  /// Label over the home nation slot in head-to-head.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get recordsHome;

  /// Label over the away nation slot in head-to-head.
  ///
  /// In en, this message translates to:
  /// **'AWAY'**
  String get recordsAway;

  /// Badge on a still-active player.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get recordsActive;

  /// Legend text next to the active marker dot.
  ///
  /// In en, this message translates to:
  /// **'Still active'**
  String get recordsStillActive;

  /// Tiny label under a legend's average rating.
  ///
  /// In en, this message translates to:
  /// **'avg'**
  String get recordsAvg;

  /// Placeholder in an empty nation slot.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get recordsSelect;

  /// Separator between the two nation slots.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get recordsVs;

  /// Tally label for drawn meetings.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get recordsDraws;

  /// Stat-row label for goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get recordsGoalsLabel;

  /// Team-record row label.
  ///
  /// In en, this message translates to:
  /// **'Best finish'**
  String get recordsBestFinish;

  /// Team-record row label.
  ///
  /// In en, this message translates to:
  /// **'Longest unbeaten'**
  String get recordsLongestUnbeaten;

  /// Team-record / stat-row label for biggest win.
  ///
  /// In en, this message translates to:
  /// **'Biggest win'**
  String get recordsBiggestWin;

  /// Button opening the full meetings list.
  ///
  /// In en, this message translates to:
  /// **'See all meetings'**
  String get recordsSeeAllMeetings;

  /// Shown when the save can't be loaded.
  ///
  /// In en, this message translates to:
  /// **'Save not found.'**
  String get recordsSaveNotFound;

  /// Shown when a search returns no leaders.
  ///
  /// In en, this message translates to:
  /// **'No matches.'**
  String get recordsNoMatches;

  /// Search box hint on the all-time records screen.
  ///
  /// In en, this message translates to:
  /// **'Search player or nation'**
  String get recordsSearchPlayerOrNation;

  /// Search box hint in the nation picker.
  ///
  /// In en, this message translates to:
  /// **'Search nation'**
  String get recordsSearchNation;

  /// Hint when the same nation is picked twice.
  ///
  /// In en, this message translates to:
  /// **'Pick two different nations.'**
  String get recordsPickTwoDifferent;

  /// Empty state for the head-to-head ledger.
  ///
  /// In en, this message translates to:
  /// **'Play some matches and your record against each opponent will build here.'**
  String get recordsPlayToBuildRecord;

  /// Sub-heading under the head-to-head ledger.
  ///
  /// In en, this message translates to:
  /// **'Tap an opponent for the full breakdown.'**
  String get recordsTapOpponent;

  /// Rivalry edge label when winning the head-to-head.
  ///
  /// In en, this message translates to:
  /// **'You hold the upper hand'**
  String get recordsEdgeUpperHand;

  /// Rivalry edge label when losing the head-to-head.
  ///
  /// In en, this message translates to:
  /// **'They have your number'**
  String get recordsEdgeTheirNumber;

  /// Rivalry edge label when the head-to-head is level.
  ///
  /// In en, this message translates to:
  /// **'Honours even'**
  String get recordsEdgeEven;

  /// Subtitle on the all-time world nav card.
  ///
  /// In en, this message translates to:
  /// **'Global scorers & most-capped, every nation'**
  String get recordsAllTimeWorldSubtitle;

  /// Subtitle on the head-to-head nav card.
  ///
  /// In en, this message translates to:
  /// **'Compare any two nations’ all-time record'**
  String get recordsHeadToHeadSubtitle;

  /// Subtitle on the legends banner.
  ///
  /// In en, this message translates to:
  /// **'All-time XI & hall of fame'**
  String get recordsLegendsSubtitle;

  /// Unit appended to a goal tally on a leaderboard.
  ///
  /// In en, this message translates to:
  /// **'goals'**
  String get recordsUnitGoals;

  /// Unit appended to a caps tally on a leaderboard.
  ///
  /// In en, this message translates to:
  /// **'caps'**
  String get recordsUnitCaps;

  /// Unit appended to a World Cup starts tally.
  ///
  /// In en, this message translates to:
  /// **'starts'**
  String get recordsUnitStarts;

  /// Unit appended to a tournaments-attended tally.
  ///
  /// In en, this message translates to:
  /// **'cups'**
  String get recordsUnitCups;

  /// Unit appended to an assists tally on a leaderboard.
  ///
  /// In en, this message translates to:
  /// **'assists'**
  String get recordsUnitAssists;

  /// Legend tally: number of caps.
  ///
  /// In en, this message translates to:
  /// **'{count} caps'**
  String recordsCapsCount(int count);

  /// Legend tally: number of goals.
  ///
  /// In en, this message translates to:
  /// **'{count} goals'**
  String recordsGoalsCount(int count);

  /// Legend tally: number of assists.
  ///
  /// In en, this message translates to:
  /// **'{count} assists'**
  String recordsAssistsCount(int count);

  /// Legend tally: number of man-of-the-match awards.
  ///
  /// In en, this message translates to:
  /// **'{count} MOTM'**
  String recordsMotmCount(int count);

  /// Value for the longest-unbeaten team record.
  ///
  /// In en, this message translates to:
  /// **'{count} matches'**
  String recordsMatchesCount(int count);

  /// Number of head-to-head meetings.
  ///
  /// In en, this message translates to:
  /// **'{count} meetings'**
  String recordsMeetingsCount(int count);

  /// Tally label: wins for the nation with this three-letter code.
  ///
  /// In en, this message translates to:
  /// **'{code} wins'**
  String recordsCodeWins(String code);

  /// Head-to-head summary line: meetings and win/draw/loss counts.
  ///
  /// In en, this message translates to:
  /// **'{meetings} meetings · {wins}W {draws}D {losses}L'**
  String recordsMeetingsWdl(int meetings, int wins, int draws, int losses);

  /// Win/draw/loss record chunk used inside the rivalry summary.
  ///
  /// In en, this message translates to:
  /// **'{wins}W {draws}D {losses}L'**
  String recordsWdl(int wins, int draws, int losses);

  /// Fiercest-rival summary line combining meetings, W-D-L record and edge phrase.
  ///
  /// In en, this message translates to:
  /// **'{meetings} meetings · {record} · {edge}'**
  String recordsRivalLine(int meetings, String record, String edge);

  /// Shown when two nations have no meetings in the save.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b} have never met in this save.'**
  String recordsNeverMet(String a, String b);

  /// In-match tactics: names the player(s) sent off, who cannot be substituted.
  ///
  /// In en, this message translates to:
  /// **'{names} sent off — no replacement, you play a man down.'**
  String tacticsSentOffNote(String names);

  /// Call-up screen: the squad is the right size but too few of its players are fit to field an XI.
  ///
  /// In en, this message translates to:
  /// **'Need {required} available ({have} fit)'**
  String tacticsNeedFitPlayers(int required, int have);

  /// World ranking action: scroll back to the manager's own nation.
  ///
  /// In en, this message translates to:
  /// **'Centre on my nation'**
  String get rankingCentreOnMe;

  /// Marks a meeting that was decided in extra time.
  ///
  /// In en, this message translates to:
  /// **'a.e.t.'**
  String get recordsAfterExtraTime;

  /// Marks a meeting decided by a penalty shootout, with the shootout score from the viewing nation's point of view.
  ///
  /// In en, this message translates to:
  /// **'{a}–{b} pens'**
  String recordsOnPenalties(int a, int b);

  /// Heading pairing two nation names on the meetings list.
  ///
  /// In en, this message translates to:
  /// **'{a} vs {b}'**
  String recordsVersus(String a, String b);

  /// Ledger row: matches played and aggregate goals for–against.
  ///
  /// In en, this message translates to:
  /// **'{played} played · {gf}–{ga}'**
  String recordsPlayedScore(int played, int gf, int ga);

  /// Biggest-win team record: score and opponent name.
  ///
  /// In en, this message translates to:
  /// **'{gf}–{ga} v {opp}'**
  String recordsBiggestWinValue(int gf, int ga, String opp);

  /// Error state on the meetings list.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String recordsCouldNotLoad(String error);

  /// Error state on the legends screen.
  ///
  /// In en, this message translates to:
  /// **'Could not load legends.\n{error}'**
  String recordsCouldNotLoadLegends(String error);

  /// Error state on the records screens.
  ///
  /// In en, this message translates to:
  /// **'Could not load records.\n{error}'**
  String recordsCouldNotLoadRecords(String error);

  /// Error state when the nations list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load nations.\n{error}'**
  String recordsCouldNotLoadNations(String error);

  /// Error state on the head-to-head ledger.
  ///
  /// In en, this message translates to:
  /// **'Could not load your record.\n{error}'**
  String recordsCouldNotLoadYourRecord(String error);

  /// Error state on a single head-to-head record.
  ///
  /// In en, this message translates to:
  /// **'Could not load record.\n{error}'**
  String recordsCouldNotLoadRecord(String error);

  /// Empty state on the legends screen.
  ///
  /// In en, this message translates to:
  /// **'No legends yet. Play out some campaigns and {nation}’s greats will emerge here.'**
  String recordsNoLegends(String nation);

  /// Sub-heading under the all-time XI.
  ///
  /// In en, this message translates to:
  /// **'The greatest side {nation} could ever field.'**
  String recordsGreatestSide(String nation);

  /// Empty state on the all-time world records screen.
  ///
  /// In en, this message translates to:
  /// **'The world has no history yet. Play out some campaigns and the all-time greats will appear here.'**
  String get recordsNoWorldHistory;

  /// Empty state on the record book.
  ///
  /// In en, this message translates to:
  /// **'Play some matches to start writing {nation}’s history.'**
  String recordsPlayToWriteHistory(String nation);

  /// Short name for the goalkeepers line, on the call-up tabs.
  ///
  /// In en, this message translates to:
  /// **'GK'**
  String get tacticsLineGk;

  /// Short name for the defenders line, on the call-up tabs.
  ///
  /// In en, this message translates to:
  /// **'DEF'**
  String get tacticsLineDef;

  /// Short name for the midfielders line, on the call-up tabs.
  ///
  /// In en, this message translates to:
  /// **'MID'**
  String get tacticsLineMid;

  /// Short name for the forwards line, on the call-up tabs.
  ///
  /// In en, this message translates to:
  /// **'FWD'**
  String get tacticsLineFwd;

  /// Position-group heading on the call-ups list.
  ///
  /// In en, this message translates to:
  /// **'GOALKEEPERS'**
  String get tacticsGoalkeepers;

  /// Position-group heading on the call-ups list.
  ///
  /// In en, this message translates to:
  /// **'DEFENDERS'**
  String get tacticsDefenders;

  /// Position-group heading on the call-ups list.
  ///
  /// In en, this message translates to:
  /// **'MIDFIELDERS'**
  String get tacticsMidfielders;

  /// Position-group heading on the call-ups list.
  ///
  /// In en, this message translates to:
  /// **'FORWARDS'**
  String get tacticsForwards;

  /// App-bar title on the call-ups screen.
  ///
  /// In en, this message translates to:
  /// **'CALL-UPS'**
  String get tacticsCallUpsTitle;

  /// Snackbar when the squad is too small to save.
  ///
  /// In en, this message translates to:
  /// **'Pick at least {min} players.'**
  String tacticsPickAtLeastPlayers(int min);

  /// Error shown when the squad data fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load squad.\n{error}'**
  String tacticsCouldNotLoadSquad(String error);

  /// Shown when there is no squad data.
  ///
  /// In en, this message translates to:
  /// **'No squad.'**
  String get tacticsNoSquad;

  /// Header showing how many players are picked out of the maximum.
  ///
  /// In en, this message translates to:
  /// **'SQUAD · {count}/{max}'**
  String tacticsSquadCount(int count, int max);

  /// Minimum and maximum allowed squad size.
  ///
  /// In en, this message translates to:
  /// **'Min {min} · Max {max}'**
  String tacticsMinMax(int min, int max);

  /// Button that auto-picks the best available squad.
  ///
  /// In en, this message translates to:
  /// **'Best quality'**
  String get tacticsBestQuality;

  /// Button that restores the previously named squad.
  ///
  /// In en, this message translates to:
  /// **'Previous squad'**
  String get tacticsPreviousSquad;

  /// Button shown when the squad is locked; returns to the previous screen.
  ///
  /// In en, this message translates to:
  /// **'Squad locked — back'**
  String get tacticsSquadLockedBack;

  /// Button that confirms and saves the picked squad.
  ///
  /// In en, this message translates to:
  /// **'Confirm squad'**
  String get tacticsConfirmSquad;

  /// Snackbar when trying to add past the squad limit.
  ///
  /// In en, this message translates to:
  /// **'Squad full — max {max}'**
  String tacticsSquadFullMax(int max);

  /// Banner heading when the squad cannot be changed.
  ///
  /// In en, this message translates to:
  /// **'SQUAD LOCKED'**
  String get tacticsSquadLocked;

  /// Banner heading when the nomination window is open.
  ///
  /// In en, this message translates to:
  /// **'NOMINATION OPEN — PICK YOUR SQUAD'**
  String get tacticsNominationOpen;

  /// Explanation shown when the squad is locked.
  ///
  /// In en, this message translates to:
  /// **'This squad is fixed for the matches below. Re-select before the next nomination window.'**
  String get tacticsSquadFixedBlurb;

  /// Explanation shown when the nomination window is open.
  ///
  /// In en, this message translates to:
  /// **'This squad will play the matches below.'**
  String get tacticsSquadWillPlayBlurb;

  /// Fallback name for an unknown opponent nation.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get tacticsUnknown;

  /// A player's age and market value in the call-ups list.
  ///
  /// In en, this message translates to:
  /// **'Age {age} · {value}'**
  String tacticsAgeValue(int age, String value);

  /// Fatigue tag for an exhausted player.
  ///
  /// In en, this message translates to:
  /// **'Exhausted'**
  String get tacticsFatigueExhausted;

  /// Fatigue tag for a tired player.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tacticsFatigueTired;

  /// Fatigue tag for a player carrying match fatigue.
  ///
  /// In en, this message translates to:
  /// **'Match legs'**
  String get tacticsFatigueMatchLegs;

  /// Snackbar when the sub limit is exceeded in the in-match editor.
  ///
  /// In en, this message translates to:
  /// **'Too many substitutions (max {max}).'**
  String tacticsTooManySubs(int max);

  /// App-bar title of the in-match tactics editor, with the current minute.
  ///
  /// In en, this message translates to:
  /// **'TACTICS · {minute}\''**
  String tacticsMinuteTitle(int minute);

  /// Action that applies the in-match tactical changes.
  ///
  /// In en, this message translates to:
  /// **'APPLY'**
  String get tacticsApply;

  /// Tab for the pitch and bench in the in-match editor.
  ///
  /// In en, this message translates to:
  /// **'LINEUP & SUBS'**
  String get tacticsTabLineupSubs;

  /// Tab for formation and instructions in the in-match editor.
  ///
  /// In en, this message translates to:
  /// **'TACTICS'**
  String get tacticsTabTactics;

  /// Depth-chart heading for goalkeepers on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'KEEPERS'**
  String get squadLineKeepers;

  /// Depth-chart heading for defenders on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'DEFENCE'**
  String get squadLineDefenders;

  /// Depth-chart heading for midfielders on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'MIDFIELD'**
  String get squadLineMidfielders;

  /// Depth-chart heading for forwards on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'ATTACK'**
  String get squadLineForwards;

  /// Squad overview tile: mean overall of the starting eleven.
  ///
  /// In en, this message translates to:
  /// **'XI rating'**
  String get squadStatXiRating;

  /// Squad overview tile: mean age of the squad.
  ///
  /// In en, this message translates to:
  /// **'Avg age'**
  String get squadStatAvgAge;

  /// Squad overview tile: number of players available.
  ///
  /// In en, this message translates to:
  /// **'Squad'**
  String get squadStatSize;

  /// Squad overview tile: players injured or suspended.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get squadStatUnavailable;

  /// Heading above the per-line squad depth chips.
  ///
  /// In en, this message translates to:
  /// **'DEPTH BY LINE'**
  String get squadDepthTitle;

  /// Compact age label on a squad row.
  ///
  /// In en, this message translates to:
  /// **'{age}y'**
  String squadAgeShort(int age);

  /// Heading above the substitutes list, with the count.
  ///
  /// In en, this message translates to:
  /// **'SUBSTITUTES · {count}'**
  String tacticsSubstitutesCount(int count);

  /// How many substitutions have been used out of the maximum.
  ///
  /// In en, this message translates to:
  /// **'SUBS · {used}/{max}'**
  String tacticsSubsUsed(int used, int max);

  /// Hint above the bench in the in-match editor.
  ///
  /// In en, this message translates to:
  /// **'Drag a sub onto a player to bring them on.'**
  String get tacticsDragSubOn;

  /// Shown when the bench is empty.
  ///
  /// In en, this message translates to:
  /// **'No substitutes available.'**
  String get tacticsNoSubs;

  /// Heading of the formation picker sheet.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE A SHAPE'**
  String get tacticsChooseShape;

  /// Heading above the formation selector.
  ///
  /// In en, this message translates to:
  /// **'FORMATION'**
  String get tacticsFormation;

  /// Heading above the tactical instruction sliders.
  ///
  /// In en, this message translates to:
  /// **'INSTRUCTIONS'**
  String get tacticsInstructions;

  /// Shown in place of the instruction sliders during a live match, where they cannot be changed.
  ///
  /// In en, this message translates to:
  /// **'Set before kick-off. You can change shape and make substitutions, but not rewrite your approach mid-match.'**
  String get matchInstructionsLocked;

  /// Instruction slider: overall mentality.
  ///
  /// In en, this message translates to:
  /// **'Mentality'**
  String get tacticsInstrMentality;

  /// Low end of the mentality slider.
  ///
  /// In en, this message translates to:
  /// **'Defensive'**
  String get tacticsInstrDefensive;

  /// High end of the mentality slider.
  ///
  /// In en, this message translates to:
  /// **'Attacking'**
  String get tacticsInstrAttacking;

  /// Instruction slider: pressing intensity.
  ///
  /// In en, this message translates to:
  /// **'Pressing'**
  String get tacticsInstrPressing;

  /// Low end of the pressing slider.
  ///
  /// In en, this message translates to:
  /// **'Low block'**
  String get tacticsInstrLowBlock;

  /// High end of the pressing slider.
  ///
  /// In en, this message translates to:
  /// **'High press'**
  String get tacticsInstrHighPress;

  /// Instruction slider: tempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tacticsInstrTempo;

  /// Low end of the tempo slider.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get tacticsInstrPatient;

  /// High end of the tempo slider.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get tacticsInstrFast;

  /// Instruction slider: width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get tacticsInstrWidth;

  /// Low end of the width slider.
  ///
  /// In en, this message translates to:
  /// **'Narrow'**
  String get tacticsInstrNarrow;

  /// High end of the width slider.
  ///
  /// In en, this message translates to:
  /// **'Wide'**
  String get tacticsInstrWide;

  /// Instruction slider: defensive line (abbreviated).
  ///
  /// In en, this message translates to:
  /// **'Def. line'**
  String get tacticsInstrDefLine;

  /// Instruction slider: defensive line (full).
  ///
  /// In en, this message translates to:
  /// **'Defensive line'**
  String get tacticsInstrDefensiveLine;

  /// Low end of the defensive-line slider.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get tacticsInstrDeep;

  /// High end of the defensive-line slider.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get tacticsInstrHigh;

  /// Instruction slider: directness.
  ///
  /// In en, this message translates to:
  /// **'Directness'**
  String get tacticsInstrDirectness;

  /// Low end of the directness slider.
  ///
  /// In en, this message translates to:
  /// **'Possession'**
  String get tacticsInstrPossession;

  /// High end of the directness slider.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get tacticsInstrDirect;

  /// Heading of the player-picker sheet for a given slot's role.
  ///
  /// In en, this message translates to:
  /// **'PICK {role}'**
  String tacticsPickRole(String role);

  /// Subtitle noting a player is playing out of position.
  ///
  /// In en, this message translates to:
  /// **'{role} · out of position'**
  String tacticsRoleOutOfPosition(String role);

  /// A player's age alone, where his position is already shown as a chip beside it.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String tacticsAgeOnly(int age);

  /// A player's natural role and age.
  ///
  /// In en, this message translates to:
  /// **'{role} · Age {age}'**
  String tacticsRoleAge(String role, int age);

  /// Chip marking a player already on the pitch.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get tacticsOn;

  /// Squad screen title and squad tab label.
  ///
  /// In en, this message translates to:
  /// **'SQUAD'**
  String get tacticsSquad;

  /// Tab showing the pitch and formation.
  ///
  /// In en, this message translates to:
  /// **'LINEUP'**
  String get tacticsTabLineup;

  /// Tab for assigning player roles.
  ///
  /// In en, this message translates to:
  /// **'ROLES'**
  String get tacticsTabRoles;

  /// Tab for set-piece takers.
  ///
  /// In en, this message translates to:
  /// **'SET PIECES'**
  String get tacticsTabSetPieces;

  /// Merged tab: player roles and set-piece takers.
  ///
  /// In en, this message translates to:
  /// **'ROLES & SET PIECES'**
  String get tacticsTabRolesSetPieces;

  /// Blurb for the merged roles & set-pieces tab.
  ///
  /// In en, this message translates to:
  /// **'Give each starter a role. Tap the penalty (⚽) or free-kick (▲) badge to set your taker.'**
  String get tacticsRolesSetPiecesBlurb;

  /// Tooltip for the call-ups action.
  ///
  /// In en, this message translates to:
  /// **'Call-ups'**
  String get tacticsTooltipCallUps;

  /// Tooltip for the tactic-presets action.
  ///
  /// In en, this message translates to:
  /// **'Tactic presets'**
  String get tacticsTooltipPresets;

  /// Tooltip for the team-instructions action.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get tacticsTooltipInstructions;

  /// Shown when there is no tactic data.
  ///
  /// In en, this message translates to:
  /// **'No tactic set.'**
  String get tacticsNoTacticSet;

  /// Warning naming how many unavailable starters must be replaced.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{REPLACE {count} STARTER} other{REPLACE {count} STARTERS}}'**
  String tacticsReplaceStarters(int count);

  /// An unavailable player and the reason they are out.
  ///
  /// In en, this message translates to:
  /// **'{name} — {reason}'**
  String tacticsPlayerOut(String name, String reason);

  /// Fallback reason for an unavailable player.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get tacticsOut;

  /// Hint on how to replace an unavailable starter.
  ///
  /// In en, this message translates to:
  /// **'Tap their spot on the pitch to pick a replacement.'**
  String get tacticsTapSpotReplace;

  /// Hint above the pitch on how to edit the XI.
  ///
  /// In en, this message translates to:
  /// **'Tap a player to swap them out, or hold and drag one to move them.'**
  String get tacticsTapOrDrag;

  /// Heading of the roles tab.
  ///
  /// In en, this message translates to:
  /// **'PLAYER ROLES'**
  String get tacticsPlayerRoles;

  /// Explanation of what player roles do.
  ///
  /// In en, this message translates to:
  /// **'Give a player a job: a poacher, a playmaker, a target man. Shapes who scores and who creates.'**
  String get tacticsRolesBlurb;

  /// Heading of the set-pieces tab.
  ///
  /// In en, this message translates to:
  /// **'SET-PIECE TAKERS'**
  String get tacticsSetPieceTakers;

  /// Explanation of the set-piece takers.
  ///
  /// In en, this message translates to:
  /// **'Who takes penalties and dead balls, or leave it to the best-suited player.'**
  String get tacticsSetPieceBlurb;

  /// Set-piece situation: penalties.
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get tacticsPenalties;

  /// Set-piece situation: corners and free-kicks.
  ///
  /// In en, this message translates to:
  /// **'Corners & free-kicks'**
  String get tacticsCornersFreeKicks;

  /// Abbreviated skill label for finishing/shooting.
  ///
  /// In en, this message translates to:
  /// **'FIN'**
  String get tacticsSkillFin;

  /// Abbreviated skill label for passing.
  ///
  /// In en, this message translates to:
  /// **'PAS'**
  String get tacticsSkillPas;

  /// Heading of the role-picker sheet for a player.
  ///
  /// In en, this message translates to:
  /// **'ROLE · {name}'**
  String tacticsRolePlayer(String name);

  /// Heading of the penalty-taker picker.
  ///
  /// In en, this message translates to:
  /// **'PENALTY TAKER'**
  String get tacticsPenaltyTaker;

  /// Heading of the corner/free-kick taker picker.
  ///
  /// In en, this message translates to:
  /// **'CORNER & FREE-KICK TAKER'**
  String get tacticsCornerFreeKickTaker;

  /// Option letting the game pick the best-suited taker.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get tacticsAutomatic;

  /// Subtitle of the Automatic set-piece option.
  ///
  /// In en, this message translates to:
  /// **'Let the best-suited player take it.'**
  String get tacticsLetBestSuited;

  /// Chip marking a player already in the starting XI.
  ///
  /// In en, this message translates to:
  /// **'IN XI'**
  String get tacticsInXi;

  /// Heading of the instructions sheet.
  ///
  /// In en, this message translates to:
  /// **'TEAM INSTRUCTIONS'**
  String get tacticsTeamInstructions;

  /// Intro on the instructions sheet.
  ///
  /// In en, this message translates to:
  /// **'Set how your side plays. Each dial nudges the whole team.'**
  String get tacticsTeamInstructionsBlurb;

  /// Snackbar confirming a preset was saved.
  ///
  /// In en, this message translates to:
  /// **'Saved “{name}”'**
  String tacticsSavedPreset(String name);

  /// Snackbar confirming a preset was applied.
  ///
  /// In en, this message translates to:
  /// **'Applied “{name}”'**
  String tacticsAppliedPreset(String name);

  /// Heading of the presets sheet.
  ///
  /// In en, this message translates to:
  /// **'TACTIC PRESETS'**
  String get tacticsTacticPresets;

  /// Intro on the presets sheet.
  ///
  /// In en, this message translates to:
  /// **'Save this shape as a reusable style, or apply one you saved earlier.'**
  String get tacticsPresetsBlurb;

  /// Button that saves the current shape and instructions as a preset.
  ///
  /// In en, this message translates to:
  /// **'Save current tactic'**
  String get tacticsSaveCurrentTactic;

  /// Error shown when presets fail to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load presets.\n{error}'**
  String tacticsCouldNotLoadPresets(String error);

  /// Empty state on the presets sheet.
  ///
  /// In en, this message translates to:
  /// **'No presets yet. Tap “Save current tactic” to store this setup as a reusable style.'**
  String get tacticsNoPresetsYet;

  /// Title of the dialog naming a new preset.
  ///
  /// In en, this message translates to:
  /// **'Name this tactic'**
  String get tacticsNameThisTactic;

  /// Hint text in the preset-name field.
  ///
  /// In en, this message translates to:
  /// **'e.g. High press 4-3-3'**
  String get tacticsNameHint;

  /// Dismiss the name-preset dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tacticsCancel;

  /// Confirm the name-preset dialog.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get tacticsSave;

  /// Shown when a player has no role assigned.
  ///
  /// In en, this message translates to:
  /// **'Tap to assign'**
  String get tacticsTapToAssign;

  /// Hint above the substitutes list on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'Hold a sub, then drag them onto a player to bring them on.'**
  String get tacticsHoldDragSub;

  /// Heading of the unavailable-players list, with the count.
  ///
  /// In en, this message translates to:
  /// **'UNAVAILABLE · {count}'**
  String tacticsUnavailableCount(int count);

  /// Button to continue to the next screen.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get hubContinue;

  /// Label/tab for the knockout brackets.
  ///
  /// In en, this message translates to:
  /// **'Brackets'**
  String get hubBrackets;

  /// Generic load-error message on the hub.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String hubCouldNotLoad(String error);

  /// Error when federation finances fail to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load finances.\n{error}'**
  String hubCouldNotLoadFinances(String error);

  /// Error when the save fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load save.\n{error}'**
  String hubCouldNotLoadSave(String error);

  /// Shown when the save can't be found.
  ///
  /// In en, this message translates to:
  /// **'Save not found.'**
  String get hubSaveNotFound;

  /// Fallback for an unknown value.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get hubUnknown;

  /// Banner naming the year's world champions.
  ///
  /// In en, this message translates to:
  /// **'{year} WORLD CHAMPIONS'**
  String hubWorldChampionsYear(int year);

  /// Message that the cycle has ended.
  ///
  /// In en, this message translates to:
  /// **'The cycle is complete.'**
  String get hubCycleComplete;

  /// Heading over the manager's current job.
  ///
  /// In en, this message translates to:
  /// **'YOUR JOB'**
  String get hubYourJob;

  /// Option to stay with the current nation.
  ///
  /// In en, this message translates to:
  /// **'Stay and continue your project'**
  String get hubStayProject;

  /// Heading prompting the next job choice.
  ///
  /// In en, this message translates to:
  /// **'CHOOSE YOUR NEXT JOB'**
  String get hubChooseNextJob;

  /// Heading over the list of job offers.
  ///
  /// In en, this message translates to:
  /// **'OFFERS ON THE TABLE'**
  String get hubOffersOnTable;

  /// Job-offer subtitle with tier and world position.
  ///
  /// In en, this message translates to:
  /// **'{tier} · world #{position}'**
  String hubOfferSubtitle(String tier, int position);

  /// Button to continue with a given nation.
  ///
  /// In en, this message translates to:
  /// **'Continue with {nation}'**
  String hubContinueWith(String nation);

  /// Fallback phrase for the manager's nation.
  ///
  /// In en, this message translates to:
  /// **'your nation'**
  String get hubYourNation;

  /// Button to accept a job offer.
  ///
  /// In en, this message translates to:
  /// **'Take the job'**
  String get hubTakeTheJob;

  /// Heading of the federation finances panel.
  ///
  /// In en, this message translates to:
  /// **'FEDERATION FINANCES'**
  String get hubFederationFinances;

  /// Intro explaining the budget-setting task.
  ///
  /// In en, this message translates to:
  /// **'Your first job next cycle is to set the federation budget and split it across the departments.'**
  String get hubBudgetIntro;

  /// Progress label while the next cycle starts.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get hubStarting;

  /// Button to begin the next cycle.
  ///
  /// In en, this message translates to:
  /// **'Begin next cycle'**
  String get hubBeginNextCycle;

  /// Finances row: opening balance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get hubOpeningBalance;

  /// Finances row: central funding.
  ///
  /// In en, this message translates to:
  /// **'Central funding'**
  String get hubCentralFunding;

  /// Finances row: prize money.
  ///
  /// In en, this message translates to:
  /// **'Prize money'**
  String get hubPrizeMoney;

  /// Finances row: commercial return.
  ///
  /// In en, this message translates to:
  /// **'Commercial return'**
  String get hubCommercialReturn;

  /// Finances row: total available to invest.
  ///
  /// In en, this message translates to:
  /// **'Available to invest'**
  String get hubAvailableToInvest;

  /// Reputation label with tier and value.
  ///
  /// In en, this message translates to:
  /// **'Reputation: {label} ({rep})'**
  String hubReputation(String label, int rep);

  /// Reputation tier: national hero.
  ///
  /// In en, this message translates to:
  /// **'National hero'**
  String get hubNationalHero;

  /// Label for the final.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get hubFinal;

  /// Knockout round name: the round of 32.
  ///
  /// In en, this message translates to:
  /// **'Round of 32'**
  String get hubStageRoundOf32;

  /// Knockout round name: the third-place play-off.
  ///
  /// In en, this message translates to:
  /// **'Third-place play-off'**
  String get hubStageThirdPlace;

  /// Hub action: quick-sim to the next event.
  ///
  /// In en, this message translates to:
  /// **'Advance the world'**
  String get hubEventAdvanceWorld;

  /// Hub action: begin the next World Cup cycle.
  ///
  /// In en, this message translates to:
  /// **'Start {year} cycle'**
  String hubEventStartCycle(int year);

  /// Hub subtitle naming the reigning World Cup winner.
  ///
  /// In en, this message translates to:
  /// **'{nation} are World Champions'**
  String hubEventWorldChampions(String nation);

  /// Hub action: allocate the federation budget.
  ///
  /// In en, this message translates to:
  /// **'Set your federation budget'**
  String get hubEventSetBudget;

  /// Hub subtitle for the budget step.
  ///
  /// In en, this message translates to:
  /// **'Allocate this cycle’s war chest before the season begins'**
  String get hubEventSetBudgetSub;

  /// Hub action: decide on a naturalisation.
  ///
  /// In en, this message translates to:
  /// **'Review naturalisation offer'**
  String get hubEventNaturalization;

  /// Hub subtitle for the naturalisation step.
  ///
  /// In en, this message translates to:
  /// **'A foreign player wants to switch allegiance to you'**
  String get hubEventNaturalizationSub;

  /// Hub action: the intercontinental play-off.
  ///
  /// In en, this message translates to:
  /// **'The intercontinental play-off'**
  String get hubEventIntercontinentalPlayoff;

  /// Hub action: watch the World Cup finals draw.
  ///
  /// In en, this message translates to:
  /// **'Watch the World Cup draw'**
  String get hubEventWatchWcDraw;

  /// Hub action: the World Cup opening ceremony.
  ///
  /// In en, this message translates to:
  /// **'The World Cup is here'**
  String get hubEventWorldCupHere;

  /// Hub action: watch the continental finals draw.
  ///
  /// In en, this message translates to:
  /// **'Watch the finals draw'**
  String get hubEventWatchFinalsDraw;

  /// Hub action: the continental opening ceremony.
  ///
  /// In en, this message translates to:
  /// **'The finals are here'**
  String get hubEventFinalsHere;

  /// Hub action: step the World Cup forward one round.
  ///
  /// In en, this message translates to:
  /// **'Play the next World Cup round'**
  String get hubEventPlayWcRound;

  /// Hub action: step a continental cup forward one match.
  ///
  /// In en, this message translates to:
  /// **'Play the next {cup} match'**
  String hubEventPlayCupMatch(String cup);

  /// Hub action: step the Nations Cup forward.
  ///
  /// In en, this message translates to:
  /// **'Play the next Nations Cup match'**
  String get hubEventPlayNationsCupMatch;

  /// Hub action: watch the Nations Cup draw.
  ///
  /// In en, this message translates to:
  /// **'Watch the Nations Cup draw'**
  String get hubEventWatchNationsCupDraw;

  /// Hub action: watch the continental host selection.
  ///
  /// In en, this message translates to:
  /// **'Watch the host selection'**
  String get hubEventWatchHostSelection;

  /// Hub action: watch the continental qualifying draw.
  ///
  /// In en, this message translates to:
  /// **'Watch the qualifying draw'**
  String get hubEventWatchQualifyingDraw;

  /// Hub action: watch the World Cup host selection.
  ///
  /// In en, this message translates to:
  /// **'Watch the World Cup host selection'**
  String get hubEventWatchWcHostSelection;

  /// Hub action: watch the World Cup qualifying draw.
  ///
  /// In en, this message translates to:
  /// **'Watch the World Cup qualifying draw'**
  String get hubEventWatchWcQualifyingDraw;

  /// Hub action: arrange friendlies.
  ///
  /// In en, this message translates to:
  /// **'Arrange friendlies'**
  String get hubEventArrangeFriendlies;

  /// Hub subtitle: unarranged friendly windows.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You haven’t filled your open friendly window yet} other{You haven’t filled your {count} open friendly windows yet}}'**
  String hubEventFriendliesSub(int count);

  /// Hub action: fix the starting XI after a ban/injury.
  ///
  /// In en, this message translates to:
  /// **'Reshape your starting XI'**
  String get hubEventReshapeXi;

  /// Hub subtitle: XI players unavailable.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 of your XI is out (suspended or injured) — pick their replacement} other{{count} of your XI are out (suspended or injured) — pick their replacements}}'**
  String hubEventReshapeOutSub(int count);

  /// Hub subtitle: XI not full.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your starting XI is short — fill the open slot} other{Your starting XI is short — fill the open slots}}'**
  String hubEventReshapeShortSub(int count);

  /// Hub action: play the next match against an opponent.
  ///
  /// In en, this message translates to:
  /// **'Play {opponent}'**
  String hubEventPlayOpponent(String opponent);

  /// Fallback name when a continental cup name is unknown.
  ///
  /// In en, this message translates to:
  /// **'the continental finals'**
  String get hubEventContinentalFinalsFallback;

  /// Call-up label before a friendly window.
  ///
  /// In en, this message translates to:
  /// **'Name your squad for the friendlies'**
  String get hubCallUpFriendlies;

  /// Call-up label at qualifying matchday 6.
  ///
  /// In en, this message translates to:
  /// **'Re-name your qualifying squad'**
  String get hubCallUpRequalify;

  /// Call-up label before the World Cup group stage.
  ///
  /// In en, this message translates to:
  /// **'Name your World Cup squad'**
  String get hubCallUpWorldCup;

  /// Call-up label before a continental finals.
  ///
  /// In en, this message translates to:
  /// **'Name your squad for the finals'**
  String get hubCallUpFinals;

  /// Call-up label before the Nations Cup.
  ///
  /// In en, this message translates to:
  /// **'Name your Nations Cup squad'**
  String get hubCallUpNationsCup;

  /// Call-up label before a qualifying campaign.
  ///
  /// In en, this message translates to:
  /// **'Name your qualifying squad'**
  String get hubCallUpQualifying;

  /// Generic call-up label.
  ///
  /// In en, this message translates to:
  /// **'Name your squad'**
  String get hubCallUpGeneric;

  /// Label marking the host nation.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get hubHost;

  /// Award label: Golden Boot.
  ///
  /// In en, this message translates to:
  /// **'Golden Boot'**
  String get hubGoldenBoot;

  /// Golden Boot holder name and goal count.
  ///
  /// In en, this message translates to:
  /// **'{name} · {goals} goals'**
  String hubGoldenBootValue(String name, int goals);

  /// Suffix marking a result decided on penalties.
  ///
  /// In en, this message translates to:
  /// **'(pens)'**
  String get hubPens;

  /// Title of the national hub screen.
  ///
  /// In en, this message translates to:
  /// **'NATIONAL HUB'**
  String get hubNationalHub;

  /// Label for the messages inbox.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get hubMessages;

  /// Banner label for the world champions.
  ///
  /// In en, this message translates to:
  /// **'WORLD CHAMPIONS'**
  String get hubWorldChampions;

  /// Button opening the tournament bracket.
  ///
  /// In en, this message translates to:
  /// **'View bracket ›'**
  String get hubViewBracket;

  /// Board-confidence level: delighted.
  ///
  /// In en, this message translates to:
  /// **'Delighted'**
  String get hubBoardDelighted;

  /// Board-confidence level: pleased.
  ///
  /// In en, this message translates to:
  /// **'Pleased'**
  String get hubBoardPleased;

  /// Board-confidence level: expecting more.
  ///
  /// In en, this message translates to:
  /// **'Expecting more'**
  String get hubBoardExpectingMore;

  /// Board-confidence level: concerned.
  ///
  /// In en, this message translates to:
  /// **'Concerned'**
  String get hubBoardConcerned;

  /// Board-confidence level: job at risk.
  ///
  /// In en, this message translates to:
  /// **'Job at risk'**
  String get hubBoardJobAtRisk;

  /// Heading of the board panel.
  ///
  /// In en, this message translates to:
  /// **'BOARD'**
  String get hubBoard;

  /// Board objective line with its label.
  ///
  /// In en, this message translates to:
  /// **'Board objective: {label}'**
  String hubBoardObjective(String label);

  /// Objective met, with the result.
  ///
  /// In en, this message translates to:
  /// **'MET · {result}'**
  String hubObjectiveMet(String result);

  /// Objective missed, with the result.
  ///
  /// In en, this message translates to:
  /// **'MISSED · {result}'**
  String hubObjectiveMissed(String result);

  /// Shown when no fixtures remain this cycle.
  ///
  /// In en, this message translates to:
  /// **'No more fixtures this cycle.'**
  String get hubNoMoreFixtures;

  /// Heading above the next match card.
  ///
  /// In en, this message translates to:
  /// **'NEXT MATCH'**
  String get hubNextMatch;

  /// Versus separator between two teams.
  ///
  /// In en, this message translates to:
  /// **'VS'**
  String get hubVs;

  /// Heading of the squad-status panel.
  ///
  /// In en, this message translates to:
  /// **'SQUAD STATUS'**
  String get hubSquadStatus;

  /// Player count.
  ///
  /// In en, this message translates to:
  /// **'{count} players'**
  String hubPlayers(int count);

  /// Label for the squad average rating.
  ///
  /// In en, this message translates to:
  /// **'Avg rating'**
  String get hubAvgRating;

  /// Label for squad morale.
  ///
  /// In en, this message translates to:
  /// **'Morale'**
  String get hubMorale;

  /// Button to open team management.
  ///
  /// In en, this message translates to:
  /// **'Manage Team'**
  String get hubManageTeam;

  /// Shown before the group draw has happened.
  ///
  /// In en, this message translates to:
  /// **'Groups to be drawn — watch the draw to reveal them.'**
  String get hubGroupsToBeDrawn;

  /// Group heading with its letter.
  ///
  /// In en, this message translates to:
  /// **'GROUP {name}'**
  String hubGroupName(String name);

  /// Standings column header: team.
  ///
  /// In en, this message translates to:
  /// **'TEAM'**
  String get hubTblTeam;

  /// Standings column header: played.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get hubTblP;

  /// Standings column header: goal difference.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get hubTblGd;

  /// Standings column header: points.
  ///
  /// In en, this message translates to:
  /// **'PTS'**
  String get hubTblPts;

  /// Button opening settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// Home-screen tagline.
  ///
  /// In en, this message translates to:
  /// **'LEAD THE NATION'**
  String get homeLeadTheNation;

  /// Fallback phrase for the player's nation.
  ///
  /// In en, this message translates to:
  /// **'your nation'**
  String get homeYourNation;

  /// Button starting a new game.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get homeNewGame;

  /// Button opening the saves list.
  ///
  /// In en, this message translates to:
  /// **'All saves'**
  String get homeAllSaves;

  /// Button loading an existing game.
  ///
  /// In en, this message translates to:
  /// **'Load game'**
  String get homeLoadGame;

  /// Heading over the continue card.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get homeContinue;

  /// Continue-card subtitle with date and World Cup year.
  ///
  /// In en, this message translates to:
  /// **'{date} · Road to the {year} World Cup'**
  String homeRoadToWorldCup(String date, int year);

  /// Button to manage saved games.
  ///
  /// In en, this message translates to:
  /// **'Manage saves'**
  String get careerManageSaves;

  /// App-bar title on the new-game screen.
  ///
  /// In en, this message translates to:
  /// **'NEW GAME'**
  String get careerNewGameTitle;

  /// Error when the nation fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load nation.\n{error}'**
  String careerCouldNotLoadNation(String error);

  /// Shown when the nation can't be found.
  ///
  /// In en, this message translates to:
  /// **'Nation not found.'**
  String get careerNationNotFound;

  /// World rank line with the rank number.
  ///
  /// In en, this message translates to:
  /// **'WORLD RANK #{rank}'**
  String careerWorldRankNum(int rank);

  /// Label for the manager-name field.
  ///
  /// In en, this message translates to:
  /// **'Manager name'**
  String get careerManagerName;

  /// Hint text for the manager-name field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alex Ferguson'**
  String get careerManagerNameHint;

  /// Intro describing when the career begins.
  ///
  /// In en, this message translates to:
  /// **'Your career begins in September 2026, on the road to the 2030 World Cup.'**
  String get careerBeginsBlurb;

  /// Button starting the career.
  ///
  /// In en, this message translates to:
  /// **'Start Career'**
  String get careerStartCareer;

  /// App-bar title on the careers screen.
  ///
  /// In en, this message translates to:
  /// **'CAREERS'**
  String get careersTitle;

  /// Nav card: manager career.
  ///
  /// In en, this message translates to:
  /// **'Manager career'**
  String get careerManagerCareer;

  /// Subtitle of the manager-career card.
  ///
  /// In en, this message translates to:
  /// **'Every cycle you\'ve managed and your overall record'**
  String get careerManagerCareerSubtitle;

  /// Nav card: career summary.
  ///
  /// In en, this message translates to:
  /// **'Career summary'**
  String get careerSummaryTitle;

  /// Subtitle of the career-summary card.
  ///
  /// In en, this message translates to:
  /// **'Your trophy cabinet and manager record'**
  String get careerSummarySubtitle;

  /// Nav card: achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get careerAchievements;

  /// Subtitle of the achievements card.
  ///
  /// In en, this message translates to:
  /// **'Milestones, titles and board satisfaction'**
  String get careerAchievementsSubtitle;

  /// Nav card: team records.
  ///
  /// In en, this message translates to:
  /// **'Team records'**
  String get careerTeamRecords;

  /// Subtitle of the team-records card.
  ///
  /// In en, this message translates to:
  /// **'All-time top scorers and appearances'**
  String get careerTeamRecordsSubtitle;

  /// Nav card: my matches.
  ///
  /// In en, this message translates to:
  /// **'My matches'**
  String get careerMyMatches;

  /// Subtitle of the my-matches card.
  ///
  /// In en, this message translates to:
  /// **'Every result and upcoming fixture'**
  String get careerMyMatchesSubtitle;

  /// App-bar title on the career screen.
  ///
  /// In en, this message translates to:
  /// **'CAREER'**
  String get careerTitle;

  /// Error when the career fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load career.\n{error}'**
  String careerCouldNotLoadCareer(String error);

  /// Shown when there is no career data.
  ///
  /// In en, this message translates to:
  /// **'No career.'**
  String get careerNoCareer;

  /// Heading of the trophy cabinet.
  ///
  /// In en, this message translates to:
  /// **'TROPHY CABINET'**
  String get careerTrophyCabinet;

  /// Heading of the tournament history list.
  ///
  /// In en, this message translates to:
  /// **'TOURNAMENT HISTORY'**
  String get careerTournamentHistory;

  /// Empty state for tournament history.
  ///
  /// In en, this message translates to:
  /// **'No tournaments completed yet.'**
  String get careerNoTournamentsYet;

  /// Fallback label for a team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get careerTeamFallback;

  /// World ranking chip.
  ///
  /// In en, this message translates to:
  /// **'WORLD #{rank}'**
  String careerWorldNum(int rank);

  /// Ranking points chip.
  ///
  /// In en, this message translates to:
  /// **'{points} PTS'**
  String careerPointsNum(int points);

  /// Season chip.
  ///
  /// In en, this message translates to:
  /// **'SEASON {season}'**
  String careerSeasonNum(int season);

  /// Abbreviated stat: played.
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get careerStatPlayedShort;

  /// Heading for the career stats grid.
  ///
  /// In en, this message translates to:
  /// **'BY THE NUMBERS'**
  String get careerStatsHeading;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get careerStatsWinRate;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Goals for'**
  String get careerStatsGoalsFor;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Goals against'**
  String get careerStatsGoalsAgainst;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Goal diff.'**
  String get careerStatsGoalDiff;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Clean sheets'**
  String get careerStatsCleanSheets;

  /// Career stat tile label (winning margin).
  ///
  /// In en, this message translates to:
  /// **'Biggest win'**
  String get careerStatsBiggestWin;

  /// Career stat tile label (longest run).
  ///
  /// In en, this message translates to:
  /// **'Win streak'**
  String get careerStatsWinStreak;

  /// Career stat tile label (longest run).
  ///
  /// In en, this message translates to:
  /// **'Unbeaten run'**
  String get careerStatsUnbeaten;

  /// Career stat tile label (won-lost).
  ///
  /// In en, this message translates to:
  /// **'Shootouts'**
  String get careerStatsShootouts;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Hat-tricks'**
  String get careerStatsHatTricks;

  /// Career stat tile label (MOTM awards).
  ///
  /// In en, this message translates to:
  /// **'Man of the match'**
  String get careerStatsMotms;

  /// Career stat tile label.
  ///
  /// In en, this message translates to:
  /// **'Best rating'**
  String get careerStatsBestRating;

  /// Abbreviated stat: won.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get careerStatWonShort;

  /// Abbreviated stat: drawn.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get careerStatDrawnShort;

  /// Abbreviated stat: lost.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get careerStatLostShort;

  /// Abbreviated stat: goals for.
  ///
  /// In en, this message translates to:
  /// **'GF'**
  String get careerStatGoalsForShort;

  /// Abbreviated stat: goals against.
  ///
  /// In en, this message translates to:
  /// **'GA'**
  String get careerStatGoalsAgainstShort;

  /// Abbreviated stat: goal difference.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get careerStatGoalDiffShort;

  /// Empty state for the trophy cabinet.
  ///
  /// In en, this message translates to:
  /// **'No silverware yet — go win one.'**
  String get careerNoSilverware;

  /// Medal label: gold.
  ///
  /// In en, this message translates to:
  /// **'GOLD'**
  String get careerMedalGold;

  /// Medal label: silver.
  ///
  /// In en, this message translates to:
  /// **'SILVER'**
  String get careerMedalSilver;

  /// Medal label: bronze.
  ///
  /// In en, this message translates to:
  /// **'BRONZE'**
  String get careerMedalBronze;

  /// Winners line with the winner name.
  ///
  /// In en, this message translates to:
  /// **'Winners: {name}'**
  String careerWinnersName(String name);

  /// App-bar title on the saves screen.
  ///
  /// In en, this message translates to:
  /// **'SAVES'**
  String get careerSavesTitle;

  /// Error when saves fail to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load saves.\n{error}'**
  String careerCouldNotLoadSaves(String error);

  /// Save-slot usage out of the limit.
  ///
  /// In en, this message translates to:
  /// **'SLOTS  {used}/{limit}'**
  String careerSlotsCount(int used, int limit);

  /// Note that Pro allows up to ten saves.
  ///
  /// In en, this message translates to:
  /// **'Pro: up to 10'**
  String get careerProUpTo5;

  /// Marker for the current save.
  ///
  /// In en, this message translates to:
  /// **'this save'**
  String get careerThisSave;

  /// Shown when all save slots are used.
  ///
  /// In en, this message translates to:
  /// **'Slots full'**
  String get careerSlotsFull;

  /// Shown when slots are full, prompting Pro.
  ///
  /// In en, this message translates to:
  /// **'Slots full — go Pro for 10'**
  String get careerSlotsFullGoPro;

  /// Button starting a new game.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get careerNewGame;

  /// Title of the delete-save dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete save?'**
  String get careerDeleteSaveTitle;

  /// Body of the delete-save dialog.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes your {label} career.'**
  String careerDeleteSaveBody(String label);

  /// Dismiss the delete-save dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get careerCancel;

  /// Confirm the delete-save dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get careerDelete;

  /// Empty state on the saves screen.
  ///
  /// In en, this message translates to:
  /// **'No saves yet.\nStart a new game to lead a nation.'**
  String get careerNoSavesYet;

  /// Fallback for an unknown nation.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get careerUnknownNation;

  /// Total real-world time spent in a save, under an hour.
  ///
  /// In en, this message translates to:
  /// **'Played {minutes}m'**
  String careerPlayedMinutes(int minutes);

  /// Total real-world time spent in a save, an hour or more.
  ///
  /// In en, this message translates to:
  /// **'Played {hours}h {minutes}m'**
  String careerPlayedHours(int hours, int minutes);

  /// Saves list: when this save was last opened.
  ///
  /// In en, this message translates to:
  /// **'Last played {when}'**
  String careerLastPlayed(String when);

  /// Relative time: within the last couple of minutes.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get careerJustNow;

  /// Relative time: one day ago.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get careerYesterday;

  /// Relative time in minutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String careerMinutesAgo(int n);

  /// Relative time in hours.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String careerHoursAgo(int n);

  /// Relative time in days.
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String careerDaysAgo(int n);

  /// Save subtitle: road to the World Cup.
  ///
  /// In en, this message translates to:
  /// **'Road to the {year} World Cup'**
  String careerRoadToWorldCup(int year);

  /// App-bar title on the manager-career screen.
  ///
  /// In en, this message translates to:
  /// **'MANAGER CAREER'**
  String get careerManagerCareerTitle;

  /// Generic load-error on the career screens.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String careerCouldNotLoad(String error);

  /// Heading of the cycle-by-cycle breakdown.
  ///
  /// In en, this message translates to:
  /// **'CYCLE BY CYCLE'**
  String get careerCycleByCycle;

  /// Summary of cycles managed and nations led.
  ///
  /// In en, this message translates to:
  /// **'{cycles, plural, one{1 cycle} other{{cycles} cycles}} · {nations, plural, one{1 nation led} other{{nations} nations led}}'**
  String careerCyclesNationsLed(int cycles, int nations);

  /// Stat label: titles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get careerStatTitles;

  /// Stat label: played.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get careerStatPlayed;

  /// Stat label: won.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get careerStatWon;

  /// Stat label: drawn.
  ///
  /// In en, this message translates to:
  /// **'Drawn'**
  String get careerStatDrawn;

  /// Stat label: lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get careerStatLost;

  /// Goals and win-rate summary line.
  ///
  /// In en, this message translates to:
  /// **'Goals {goalsFor}–{goalsAgainst}  ({gd})  ·  Win rate {winRate}%'**
  String careerGoalsWinRate(
    int goalsFor,
    int goalsAgainst,
    String gd,
    int winRate,
  );

  /// Heading of the record-results panel.
  ///
  /// In en, this message translates to:
  /// **'RECORD RESULTS'**
  String get careerRecordResults;

  /// Label for the best win.
  ///
  /// In en, this message translates to:
  /// **'Best win'**
  String get careerBestWin;

  /// Label for the worst defeat.
  ///
  /// In en, this message translates to:
  /// **'Worst defeat'**
  String get careerWorstDefeat;

  /// Opponent and date line for a record result.
  ///
  /// In en, this message translates to:
  /// **'v {opponent} · {date}'**
  String careerVsOpponentDate(String opponent, String date);

  /// Per-cycle W/D/L and goals record line.
  ///
  /// In en, this message translates to:
  /// **'{won}W {drawn}D {lost}L  ·  GF {goalsFor} GA {goalsAgainst} ({gd})'**
  String careerCycleRecordLine(
    int won,
    int drawn,
    int lost,
    int goalsFor,
    int goalsAgainst,
    String gd,
  );

  /// Tournament label: World Cup.
  ///
  /// In en, this message translates to:
  /// **'World Cup'**
  String get careerWorldCupLabel;

  /// Tournament label: continental.
  ///
  /// In en, this message translates to:
  /// **'Continental'**
  String get careerContinentalLabel;

  /// App-bar title on the messages inbox screen.
  ///
  /// In en, this message translates to:
  /// **'MESSAGES'**
  String get messagesTitle;

  /// Empty state when the inbox has no messages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get messagesNoMessagesYet;

  /// Error state when the inbox fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.\n{error}'**
  String messagesCouldNotLoad(String error);

  /// Button that dismisses the last message in a popup run.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get messagesDone;

  /// Button that advances to the next message in a popup run.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get messagesNext;

  /// App-bar title on the world ranking screen.
  ///
  /// In en, this message translates to:
  /// **'WORLD RANKING'**
  String get rankingWorldRanking;

  /// Error state when the world ranking fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load ranking.\n{error}'**
  String rankingCouldNotLoad(String error);

  /// Empty state when there is no ranking data.
  ///
  /// In en, this message translates to:
  /// **'No ranking.'**
  String get rankingNoRanking;

  /// Confederation filter chip showing every nation.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get rankingAll;

  /// Chip marking the manager's own nation in the ranking list.
  ///
  /// In en, this message translates to:
  /// **'YOUR TEAM'**
  String get rankingYourTeam;

  /// Heading of the manager's ranking history chart.
  ///
  /// In en, this message translates to:
  /// **'YOUR RANKING OVER TIME'**
  String get rankingYourRankingOverTime;

  /// Current world rank label on the history chart.
  ///
  /// In en, this message translates to:
  /// **'now #{rank}'**
  String rankingNowRank(int rank);

  /// Best and worst ranking positions on the history chart.
  ///
  /// In en, this message translates to:
  /// **'best #{best} · worst #{worst}'**
  String rankingBestWorst(int best, int worst);

  /// Friendlies screen app-bar heading.
  ///
  /// In en, this message translates to:
  /// **'FRIENDLIES'**
  String get friendliesTitle;

  /// Error shown when the friendlies plan fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load friendlies.\n{error}'**
  String friendliesLoadError(String error);

  /// Button to continue when there are no friendlies to arrange.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get friendliesContinue;

  /// Intro instructing the manager to arrange warm-ups for the open windows.
  ///
  /// In en, this message translates to:
  /// **'Arrange warm-ups for the {count, plural, one{1 open window} other{{count} open windows}} before your next competitive match. Tap an opponent, or leave it free.'**
  String friendliesArrangeIntro(int count);

  /// Label for a window with no opponent chosen.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get friendliesFree;

  /// Label on the match banner's button that opens the scorer breakdown.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 GOAL} other{{count} GOALS}}'**
  String matchGoalsCount(int count);

  /// Heading of the goal-breakdown sheet.
  ///
  /// In en, this message translates to:
  /// **'GOALS'**
  String get matchGoalsTitle;

  /// Shown for a side that has not scored in the breakdown sheet.
  ///
  /// In en, this message translates to:
  /// **'No goals'**
  String get matchGoalsNone;

  /// Tag on a goal scored from the penalty spot.
  ///
  /// In en, this message translates to:
  /// **'PEN'**
  String get matchGoalPenalty;

  /// Tag on a goal scored from a corner or free kick.
  ///
  /// In en, this message translates to:
  /// **'SET'**
  String get matchGoalSetPiece;

  /// Line naming who set a goal up.
  ///
  /// In en, this message translates to:
  /// **'assist {name}'**
  String matchGoalAssist(String name);

  /// Badge on a friendly window the manager's nation hosts.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get friendliesHome;

  /// Badge on a friendly window played at the opponent's ground.
  ///
  /// In en, this message translates to:
  /// **'AWAY'**
  String get friendliesAway;

  /// Confirm-button label when no friendlies are picked.
  ///
  /// In en, this message translates to:
  /// **'No friendlies this window'**
  String get friendliesNoneThisWindow;

  /// Confirm-button label with the number of friendlies picked.
  ///
  /// In en, this message translates to:
  /// **'Confirm {count, plural, one{1 friendly} other{{count} friendlies}}'**
  String friendliesConfirmCount(int count);

  /// Abbreviated month: January.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get friendliesMonthJan;

  /// Abbreviated month: February.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get friendliesMonthFeb;

  /// Abbreviated month: March.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get friendliesMonthMar;

  /// Abbreviated month: April.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get friendliesMonthApr;

  /// Abbreviated month: May.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get friendliesMonthMay;

  /// Abbreviated month: June.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get friendliesMonthJun;

  /// Abbreviated month: July.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get friendliesMonthJul;

  /// Abbreviated month: August.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get friendliesMonthAug;

  /// Abbreviated month: September.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get friendliesMonthSep;

  /// Abbreviated month: October.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get friendliesMonthOct;

  /// Abbreviated month: November.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get friendliesMonthNov;

  /// Abbreviated month: December.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get friendliesMonthDec;

  /// App-bar title on the player's matches screen.
  ///
  /// In en, this message translates to:
  /// **'MY MATCHES'**
  String get resultsMyMatches;

  /// Error state on the results screens.
  ///
  /// In en, this message translates to:
  /// **'Could not load results.\n{error}'**
  String resultsCouldNotLoad(String error);

  /// Shown when there are no fixtures to list.
  ///
  /// In en, this message translates to:
  /// **'No fixtures.'**
  String get resultsNoFixtures;

  /// Separator between two teams before a match is played.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get resultsVs;

  /// Stage label: a qualifying match.
  ///
  /// In en, this message translates to:
  /// **'QUALIFIER'**
  String get resultsStageQualifier;

  /// Stage label: a friendly match.
  ///
  /// In en, this message translates to:
  /// **'FRIENDLY'**
  String get resultsStageFriendly;

  /// Stage label: the group stage.
  ///
  /// In en, this message translates to:
  /// **'GROUP STAGE'**
  String get resultsStageGroupStage;

  /// Stage label: the semi-final.
  ///
  /// In en, this message translates to:
  /// **'SEMI-FINAL'**
  String get resultsStageSemiFinal;

  /// Stage label: the final.
  ///
  /// In en, this message translates to:
  /// **'FINAL'**
  String get resultsStageFinal;

  /// Stage label: the continental champions clash.
  ///
  /// In en, this message translates to:
  /// **'CONTINENTAL CLASH'**
  String get resultsStageContinentalClash;

  /// Stage label: a group at the finals tournament.
  ///
  /// In en, this message translates to:
  /// **'FINALS GROUP'**
  String get resultsStageFinalsGroup;

  /// Stage label: the round of 32.
  ///
  /// In en, this message translates to:
  /// **'ROUND OF 32'**
  String get resultsStageRoundOf32;

  /// Stage label: the round of 16.
  ///
  /// In en, this message translates to:
  /// **'ROUND OF 16'**
  String get resultsStageRoundOf16;

  /// Stage label: the quarter-final.
  ///
  /// In en, this message translates to:
  /// **'QUARTER-FINAL'**
  String get resultsStageQuarterFinal;

  /// Stage label: the third-place play-off.
  ///
  /// In en, this message translates to:
  /// **'THIRD PLACE'**
  String get resultsStageThirdPlace;

  /// Pre-match warning that no captain has been chosen.
  ///
  /// In en, this message translates to:
  /// **'No captain named — tap to give somebody the armband'**
  String get matchSetupWarnCaptain;

  /// Pre-match warning that no penalty or dead-ball taker has been chosen.
  ///
  /// In en, this message translates to:
  /// **'No set-piece takers named — tap to choose who steps up'**
  String get matchSetupWarnSetPieces;

  /// Pre-match warning that neither the armband nor the set-piece takers have been chosen.
  ///
  /// In en, this message translates to:
  /// **'No captain and no set-piece takers — tap to set them'**
  String get matchSetupWarnBoth;

  /// Matchday number shown for a qualifying fixture, which has rounds but no named stage.
  ///
  /// In en, this message translates to:
  /// **'MD {matchday}'**
  String matchStageMatchday(int matchday);

  /// Label for the squad captain row on the squad tab.
  ///
  /// In en, this message translates to:
  /// **'Captain'**
  String get squadCaptain;

  /// What youth-academy spending buys this cycle.
  ///
  /// In en, this message translates to:
  /// **'Academy prospects arrive about {points} overall better'**
  String deptEffectYouth(int points);

  /// What commercial spending pays back at the end of the cycle.
  ///
  /// In en, this message translates to:
  /// **'{amount} back at the cycle\'s close'**
  String deptEffectCommercial(String amount);

  /// How much medical spending cuts the injury rate.
  ///
  /// In en, this message translates to:
  /// **'{percent}% fewer injuries'**
  String deptEffectMedical(int percent);

  /// The chance naturalisation spending buys this cycle.
  ///
  /// In en, this message translates to:
  /// **'{percent}% chance a foreign player asks to switch'**
  String deptEffectNaturalisation(int percent);

  /// How much board-relations spending raises the sacking threshold.
  ///
  /// In en, this message translates to:
  /// **'+{points} board patience before your job is at risk'**
  String deptEffectBoard(int points);

  /// Shown under a department slider that is set to zero.
  ///
  /// In en, this message translates to:
  /// **'No effect while unfunded'**
  String get deptEffectNone;

  /// Tab label: players ranked by average match rating.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get statsBestRated;

  /// Tab label: the manager's own career record.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get statsMyCareer;

  /// Stats screen label: BEST AVERAGE RATING
  ///
  /// In en, this message translates to:
  /// **'BEST AVERAGE RATING'**
  String get statsBestAverageRating;

  /// Stats screen label: YOUR RECORD
  ///
  /// In en, this message translates to:
  /// **'YOUR RECORD'**
  String get statsMyCareerRecord;

  /// Stats screen label: No match ratings recorded yet.
  ///
  /// In en, this message translates to:
  /// **'No match ratings recorded yet.'**
  String get statsNoRatingsRecorded;

  /// Stats screen label: Record
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get statsGroupRecord;

  /// Stats screen label: Runs
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get statsGroupRuns;

  /// Stats screen label: Extremes
  ///
  /// In en, this message translates to:
  /// **'Extremes'**
  String get statsGroupExtremes;

  /// Stats screen label: Home & away
  ///
  /// In en, this message translates to:
  /// **'Home & away'**
  String get statsGroupSplits;

  /// Stats screen label: Your players
  ///
  /// In en, this message translates to:
  /// **'Your players'**
  String get statsGroupSquad;

  /// Stats screen label: Matches played
  ///
  /// In en, this message translates to:
  /// **'Matches played'**
  String get statsPlayed;

  /// Stats screen label: Won–drawn–lost
  ///
  /// In en, this message translates to:
  /// **'Won–drawn–lost'**
  String get statsWinDrawLoss;

  /// Stats screen label: Win rate
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get statsWinRate;

  /// Stats screen label: Goals for:against
  ///
  /// In en, this message translates to:
  /// **'Goals for:against'**
  String get statsGoals;

  /// Stats screen label: Clean sheets
  ///
  /// In en, this message translates to:
  /// **'Clean sheets'**
  String get statsCleanSheets;

  /// Stats screen label: Failed to score
  ///
  /// In en, this message translates to:
  /// **'Failed to score'**
  String get statsFailedToScore;

  /// Stats screen label: Longest winning run
  ///
  /// In en, this message translates to:
  /// **'Longest winning run'**
  String get statsLongestWinStreak;

  /// Stats screen label: Longest unbeaten run
  ///
  /// In en, this message translates to:
  /// **'Longest unbeaten run'**
  String get statsLongestUnbeaten;

  /// Stats screen label: Longest clean-sheet run
  ///
  /// In en, this message translates to:
  /// **'Longest clean-sheet run'**
  String get statsLongestCleanSheets;

  /// Stats screen label: Longest winless run
  ///
  /// In en, this message translates to:
  /// **'Longest winless run'**
  String get statsLongestWinless;

  /// Stats screen label: Current unbeaten run
  ///
  /// In en, this message translates to:
  /// **'Current unbeaten run'**
  String get statsCurrentRun;

  /// Stats screen label: Biggest win
  ///
  /// In en, this message translates to:
  /// **'Biggest win'**
  String get statsBiggestWin;

  /// Stats screen label: Heaviest defeat
  ///
  /// In en, this message translates to:
  /// **'Heaviest defeat'**
  String get statsHeaviestDefeat;

  /// Stats screen label: Most goals in a match
  ///
  /// In en, this message translates to:
  /// **'Most goals in a match'**
  String get statsMostGoalsInAGame;

  /// Stats screen label: Shootouts won–lost
  ///
  /// In en, this message translates to:
  /// **'Shootouts won–lost'**
  String get statsShootouts;

  /// Stats screen label: Wins from behind
  ///
  /// In en, this message translates to:
  /// **'Wins from behind'**
  String get statsComebackWins;

  /// Stats screen label: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get statsHome;

  /// Stats screen label: Away
  ///
  /// In en, this message translates to:
  /// **'Away'**
  String get statsAway;

  /// Stats screen label: Neutral
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get statsNeutral;

  /// Stats screen label: Competitive
  ///
  /// In en, this message translates to:
  /// **'Competitive'**
  String get statsCompetitive;

  /// Stats screen label: Friendlies
  ///
  /// In en, this message translates to:
  /// **'Friendlies'**
  String get statsFriendlies;

  /// Stats screen label: Hat-tricks
  ///
  /// In en, this message translates to:
  /// **'Hat-tricks'**
  String get statsHatTricks;

  /// Stats screen label: Braces
  ///
  /// In en, this message translates to:
  /// **'Braces'**
  String get statsBraces;

  /// Stats screen label: Man-of-the-match awards
  ///
  /// In en, this message translates to:
  /// **'Man-of-the-match awards'**
  String get statsMotms;

  /// Stats screen label: Assists
  ///
  /// In en, this message translates to:
  /// **'Assists'**
  String get statsAssists;

  /// Stats screen label: Cards
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get statsCards;

  /// Stats screen label: Best individual rating
  ///
  /// In en, this message translates to:
  /// **'Best individual rating'**
  String get statsBestRating;

  /// Appearance count under a player on the ratings leaderboard.
  ///
  /// In en, this message translates to:
  /// **'{apps} apps'**
  String statsAppsShort(int apps);

  /// Man-of-the-match count under a player on the ratings leaderboard.
  ///
  /// In en, this message translates to:
  /// **'{motms} MOTM'**
  String statsMotmShort(int motms);

  /// The captain's armband badge on a squad row. A single letter.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get captainArmband;

  /// Tooltip on the armband of the player who is currently captain.
  ///
  /// In en, this message translates to:
  /// **'Captain — tap to remove the armband'**
  String get captainCurrent;

  /// How well a player suits the captaincy: the best fit.
  ///
  /// In en, this message translates to:
  /// **'A born leader'**
  String get captainFitBorn;

  /// How well a player suits the captaincy: a good fit.
  ///
  /// In en, this message translates to:
  /// **'A natural captain'**
  String get captainFitNatural;

  /// How well a player suits the captaincy: an adequate fit.
  ///
  /// In en, this message translates to:
  /// **'Could wear it'**
  String get captainFitCapable;

  /// How well a player suits the captaincy: a poor fit.
  ///
  /// In en, this message translates to:
  /// **'Not a leader yet'**
  String get captainFitUnproven;

  /// Shown where a captain would be, when none has been chosen.
  ///
  /// In en, this message translates to:
  /// **'No captain named'**
  String get captainNone;

  /// How much morale the current captain is worth.
  ///
  /// In en, this message translates to:
  /// **'+{morale} squad morale'**
  String captainMoraleBoost(int morale);

  /// Competition group heading: World Cup qualifying.
  ///
  /// In en, this message translates to:
  /// **'World Cup Qualifying'**
  String get resultsCategoryWorldCupQualifying;

  /// Competition group heading: friendlies.
  ///
  /// In en, this message translates to:
  /// **'Friendlies'**
  String get resultsCategoryFriendlies;

  /// Competition group heading: continental clash.
  ///
  /// In en, this message translates to:
  /// **'Continental Clash'**
  String get resultsCategoryContinentalClash;

  /// Competition group heading: Nations Cup.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup'**
  String get resultsCategoryNationsCup;

  /// Competition group heading: continental cup.
  ///
  /// In en, this message translates to:
  /// **'Continental Cup'**
  String get resultsCategoryContinentalCup;

  /// Competition group heading: World Cup finals.
  ///
  /// In en, this message translates to:
  /// **'World Cup Finals'**
  String get resultsCategoryWorldCupFinals;

  /// App-bar title on the round-results screen.
  ///
  /// In en, this message translates to:
  /// **'ROUND RESULTS'**
  String get resultsRoundResults;

  /// Heading over other nations' friendly internationals.
  ///
  /// In en, this message translates to:
  /// **'FRIENDLY INTERNATIONALS'**
  String get resultsFriendlyInternationals;

  /// Fallback stage heading for a knockout round.
  ///
  /// In en, this message translates to:
  /// **'Knockout'**
  String get resultsKnockout;

  /// Heading naming the current group-stage matchday.
  ///
  /// In en, this message translates to:
  /// **'MATCHDAY {matchday}'**
  String resultsMatchday(int matchday);

  /// Button that carries on to the hub.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get resultsContinue;

  /// Group heading with its letter.
  ///
  /// In en, this message translates to:
  /// **'GROUP {name}'**
  String resultsGroup(String name);

  /// App-bar title on the achievements screen.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENTS'**
  String get achievementsScreenTitle;

  /// Tooltip on the button that opens the challenges screen.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get achievementsChallengesTooltip;

  /// Heading/title for the challenges section and screen.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGES'**
  String get achievementsChallengesHeading;

  /// Subtitle on the challenges entry card.
  ///
  /// In en, this message translates to:
  /// **'Brutal career-long tests'**
  String get achievementsBrutalTests;

  /// Error state when the achievements or challenges list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String achievementsCouldNotLoad(String error);

  /// Count of unlocked achievements out of the total.
  ///
  /// In en, this message translates to:
  /// **'{earned} / {total} unlocked'**
  String achievementsUnlockedCount(int earned, int total);

  /// Count of completed challenges out of the total.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} conquered'**
  String achievementsConqueredCount(int done, int total);

  /// Heading on the board-satisfaction gauge card.
  ///
  /// In en, this message translates to:
  /// **'BOARD SATISFACTION'**
  String get achievementsBoardSatisfaction;

  /// Celebratory banner heading when achievements are unlocked after a match.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{ACHIEVEMENT UNLOCKED} other{{count} ACHIEVEMENTS UNLOCKED}}'**
  String achievementsUnlockedBanner(int count);

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get achCatWins;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get achCatMatches;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get achCatQualifications;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get achCatTitles;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Misc'**
  String get achCatMisc;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Mega'**
  String get achCatMega;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get achCatGoals;

  /// Achievement category heading.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get achCatStreaks;

  /// Achievement rarity tier.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get achTierBronze;

  /// Achievement rarity tier.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get achTierSilver;

  /// Achievement rarity tier.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get achTierGold;

  /// Achievement rarity tier.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get achTierPlatinum;

  /// Goal-milestone achievement title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} Goals}}'**
  String achGoals(int count);

  /// Goal-milestone achievement description.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Score 1 goal.} other{Score {count} goals.}}'**
  String achGoalsDesc(int count);

  /// Clean-sheet milestone title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} Clean Sheets}}'**
  String achCleanSheets(int count);

  /// Clean-sheet milestone description.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Keep 1 clean sheet.} other{Keep {count} clean sheets.}}'**
  String achCleanSheetsDesc(int count);

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Winning Habit'**
  String get achStreakWin5;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win five matches in a row.'**
  String get achStreakWin5Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'On a Roll'**
  String get achStreakWin10;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win ten matches in a row.'**
  String get achStreakWin10Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Juggernaut'**
  String get achStreakWin20;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win twenty matches in a row.'**
  String get achStreakWin20Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Hard to Beat'**
  String get achUnbeaten15;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Go fifteen matches unbeaten.'**
  String get achUnbeaten15Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Untouchable'**
  String get achUnbeaten30;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Go thirty matches unbeaten.'**
  String get achUnbeaten30Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Hat-trick Hero'**
  String get achHattrick;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Have a player score a hat-trick.'**
  String get achHattrickDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Standout'**
  String get achMotm10;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Collect 10 man-of-the-match awards.'**
  String get achMotm10Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Talisman'**
  String get achMotm50;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Collect 50 man-of-the-match awards.'**
  String get achMotm50Desc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Perfect Ten'**
  String get achPerfect;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Have a player earn a 9.5+ match rating.'**
  String get achPerfectDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Ice in the Veins'**
  String get achShootout;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win five penalty shootouts.'**
  String get achShootoutDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Massacre'**
  String get achMassacre;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win a match by 7 goals or more.'**
  String get achMassacreDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Annihilation'**
  String get achAnnihilation;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win a match by 10 goals or more.'**
  String get achAnnihilationDesc;

  /// No description provided for @chTierBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get chTierBronze;

  /// No description provided for @chTierSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get chTierSilver;

  /// No description provided for @chTierGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get chTierGold;

  /// No description provided for @chTierLegendary.
  ///
  /// In en, this message translates to:
  /// **'Legendary'**
  String get chTierLegendary;

  /// No description provided for @chFirstSteps.
  ///
  /// In en, this message translates to:
  /// **'In the Dugout'**
  String get chFirstSteps;

  /// No description provided for @chFirstStepsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage for 5 years.'**
  String get chFirstStepsDesc;

  /// No description provided for @chUnbeaten10.
  ///
  /// In en, this message translates to:
  /// **'On a Roll'**
  String get chUnbeaten10;

  /// No description provided for @chUnbeaten10Desc.
  ///
  /// In en, this message translates to:
  /// **'Go 10 competitive matches unbeaten.'**
  String get chUnbeaten10Desc;

  /// No description provided for @chTwoNations.
  ///
  /// In en, this message translates to:
  /// **'Fresh Challenge'**
  String get chTwoNations;

  /// No description provided for @chTwoNationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage 2 different nations.'**
  String get chTwoNationsDesc;

  /// No description provided for @chCont1.
  ///
  /// In en, this message translates to:
  /// **'Continental Champion'**
  String get chCont1;

  /// No description provided for @chCont1Desc.
  ///
  /// In en, this message translates to:
  /// **'Win a continental championship.'**
  String get chCont1Desc;

  /// No description provided for @chNc1.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup Winner'**
  String get chNc1;

  /// No description provided for @chNc1Desc.
  ///
  /// In en, this message translates to:
  /// **'Win the Nations Cup.'**
  String get chNc1Desc;

  /// No description provided for @chWc1.
  ///
  /// In en, this message translates to:
  /// **'World Champion'**
  String get chWc1;

  /// No description provided for @chWc1Desc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup.'**
  String get chWc1Desc;

  /// No description provided for @chYears25.
  ///
  /// In en, this message translates to:
  /// **'Establishment'**
  String get chYears25;

  /// No description provided for @chYears25Desc.
  ///
  /// In en, this message translates to:
  /// **'Manage for 25 years.'**
  String get chYears25Desc;

  /// No description provided for @chWc3.
  ///
  /// In en, this message translates to:
  /// **'Serial Winner'**
  String get chWc3;

  /// No description provided for @chWc3Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 3 World Cups.'**
  String get chWc3Desc;

  /// No description provided for @chWc5.
  ///
  /// In en, this message translates to:
  /// **'Dynasty'**
  String get chWc5;

  /// No description provided for @chWc5Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 5 World Cups.'**
  String get chWc5Desc;

  /// No description provided for @chWc10.
  ///
  /// In en, this message translates to:
  /// **'Immortal'**
  String get chWc10;

  /// No description provided for @chWc10Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 10 World Cups.'**
  String get chWc10Desc;

  /// No description provided for @chWc2Teams.
  ///
  /// In en, this message translates to:
  /// **'Have Boots, Will Travel'**
  String get chWc2Teams;

  /// No description provided for @chWc2TeamsDesc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup with 2 different nations.'**
  String get chWc2TeamsDesc;

  /// No description provided for @chWc3Teams.
  ///
  /// In en, this message translates to:
  /// **'Globetrotter'**
  String get chWc3Teams;

  /// No description provided for @chWc3TeamsDesc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup with 3 different nations.'**
  String get chWc3TeamsDesc;

  /// No description provided for @chWcStreak3.
  ///
  /// In en, this message translates to:
  /// **'Three-Peat'**
  String get chWcStreak3;

  /// No description provided for @chWcStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 3 World Cups in a row.'**
  String get chWcStreak3Desc;

  /// No description provided for @chWcAllconf.
  ///
  /// In en, this message translates to:
  /// **'World Conqueror'**
  String get chWcAllconf;

  /// No description provided for @chWcAllconfDesc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup with a nation from every confederation (6).'**
  String get chWcAllconfDesc;

  /// No description provided for @chCont5.
  ///
  /// In en, this message translates to:
  /// **'Continental King'**
  String get chCont5;

  /// No description provided for @chCont5Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 5 continental championships.'**
  String get chCont5Desc;

  /// No description provided for @chContAll.
  ///
  /// In en, this message translates to:
  /// **'Six-Continent Slam'**
  String get chContAll;

  /// No description provided for @chContAllDesc.
  ///
  /// In en, this message translates to:
  /// **'Win every confederation’s continental championship (6).'**
  String get chContAllDesc;

  /// No description provided for @chTreble.
  ///
  /// In en, this message translates to:
  /// **'Clean Sweep'**
  String get chTreble;

  /// No description provided for @chTrebleDesc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup, a continental title and the Nations Cup in one career.'**
  String get chTrebleDesc;

  /// No description provided for @chNations10.
  ///
  /// In en, this message translates to:
  /// **'Nomad'**
  String get chNations10;

  /// No description provided for @chNations10Desc.
  ///
  /// In en, this message translates to:
  /// **'Manage 10 different nations.'**
  String get chNations10Desc;

  /// No description provided for @chYears100.
  ///
  /// In en, this message translates to:
  /// **'Century'**
  String get chYears100;

  /// No description provided for @chYears100Desc.
  ///
  /// In en, this message translates to:
  /// **'Manage for 100 years.'**
  String get chYears100Desc;

  /// No description provided for @chYears500.
  ///
  /// In en, this message translates to:
  /// **'Half a Millennium'**
  String get chYears500;

  /// No description provided for @chYears500Desc.
  ///
  /// In en, this message translates to:
  /// **'Manage for 500 years.'**
  String get chYears500Desc;

  /// No description provided for @chYears1000.
  ///
  /// In en, this message translates to:
  /// **'Eternal'**
  String get chYears1000;

  /// No description provided for @chYears1000Desc.
  ///
  /// In en, this message translates to:
  /// **'Manage for 1000 years.'**
  String get chYears1000Desc;

  /// No description provided for @chGrandmaster.
  ///
  /// In en, this message translates to:
  /// **'Grandmaster'**
  String get chGrandmaster;

  /// No description provided for @chGrandmasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Win 3 World Cups AND 5 continental championships.'**
  String get chGrandmasterDesc;

  /// No description provided for @chUndefeated.
  ///
  /// In en, this message translates to:
  /// **'Untouchable'**
  String get chUndefeated;

  /// No description provided for @chUndefeatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Win a World Cup without losing a single match.'**
  String get chUndefeatedDesc;

  /// No description provided for @chPerfectQual.
  ///
  /// In en, this message translates to:
  /// **'Flawless Passage'**
  String get chPerfectQual;

  /// No description provided for @chPerfectQualDesc.
  ///
  /// In en, this message translates to:
  /// **'Win every match of a World Cup qualifying campaign.'**
  String get chPerfectQualDesc;

  /// No description provided for @chMinnow.
  ///
  /// In en, this message translates to:
  /// **'Minnow Miracle'**
  String get chMinnow;

  /// No description provided for @chMinnowDesc.
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup with a nation ranked outside the world top 32.'**
  String get chMinnowDesc;

  /// No description provided for @chGrandTour.
  ///
  /// In en, this message translates to:
  /// **'Home & Away'**
  String get chGrandTour;

  /// No description provided for @chGrandTourDesc.
  ///
  /// In en, this message translates to:
  /// **'Win a World Cup as hosts and win one away from home.'**
  String get chGrandTourDesc;

  /// No description provided for @chUnbeaten25.
  ///
  /// In en, this message translates to:
  /// **'The Wall'**
  String get chUnbeaten25;

  /// No description provided for @chUnbeaten25Desc.
  ///
  /// In en, this message translates to:
  /// **'Go 25 competitive matches unbeaten.'**
  String get chUnbeaten25Desc;

  /// No description provided for @chGoals10k.
  ///
  /// In en, this message translates to:
  /// **'Goal Machine'**
  String get chGoals10k;

  /// No description provided for @chGoals10kDesc.
  ///
  /// In en, this message translates to:
  /// **'Score 10,000 career goals.'**
  String get chGoals10kDesc;

  /// No description provided for @chCleanSheets500.
  ///
  /// In en, this message translates to:
  /// **'Fortress'**
  String get chCleanSheets500;

  /// No description provided for @chCleanSheets500Desc.
  ///
  /// In en, this message translates to:
  /// **'Keep 500 career clean sheets.'**
  String get chCleanSheets500Desc;

  /// No description provided for @chHatTricks25.
  ///
  /// In en, this message translates to:
  /// **'Hat-trick Habit'**
  String get chHatTricks25;

  /// No description provided for @chHatTricks25Desc.
  ///
  /// In en, this message translates to:
  /// **'Have your players score 25 hat-tricks.'**
  String get chHatTricks25Desc;

  /// No description provided for @chWinStreak25.
  ///
  /// In en, this message translates to:
  /// **'Relentless'**
  String get chWinStreak25;

  /// No description provided for @chWinStreak25Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 25 matches in a row.'**
  String get chWinStreak25Desc;

  /// No description provided for @chCont10.
  ///
  /// In en, this message translates to:
  /// **'Continental Dynasty'**
  String get chCont10;

  /// No description provided for @chCont10Desc.
  ///
  /// In en, this message translates to:
  /// **'Win 10 continental championships.'**
  String get chCont10Desc;

  /// No description provided for @chPcWc.
  ///
  /// In en, this message translates to:
  /// **'Serial Champion'**
  String get chPcWc;

  /// No description provided for @chPcWcDesc.
  ///
  /// In en, this message translates to:
  /// **'Win {count} World Cups this save.'**
  String chPcWcDesc(int count);

  /// No description provided for @chPcMajors.
  ///
  /// In en, this message translates to:
  /// **'Silverware Collector'**
  String get chPcMajors;

  /// No description provided for @chPcMajorsDesc.
  ///
  /// In en, this message translates to:
  /// **'Win {count} major trophies (World Cup, continental or Nations Cup).'**
  String chPcMajorsDesc(int count);

  /// No description provided for @chPcUnbeaten.
  ///
  /// In en, this message translates to:
  /// **'Iron Wall'**
  String get chPcUnbeaten;

  /// No description provided for @chPcUnbeatenDesc.
  ///
  /// In en, this message translates to:
  /// **'Go {count} competitive matches unbeaten.'**
  String chPcUnbeatenDesc(int count);

  /// No description provided for @chPcNations.
  ///
  /// In en, this message translates to:
  /// **'Journeyman'**
  String get chPcNations;

  /// No description provided for @chPcNationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage {count} different nations.'**
  String chPcNationsDesc(int count);

  /// No description provided for @chPcYears.
  ///
  /// In en, this message translates to:
  /// **'The Long Haul'**
  String get chPcYears;

  /// No description provided for @chPcYearsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage for {count} years.'**
  String chPcYearsDesc(int count);

  /// Win-milestone achievement title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Win} other{{count} Wins}}'**
  String achWins(int count);

  /// Win-milestone achievement description.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Win 1 match.} other{Win {count} matches.}}'**
  String achWinsDesc(int count);

  /// Matches-milestone achievement title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} Matches}}'**
  String achMatches(int count);

  /// Matches-milestone achievement description.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Play 1 match.} other{Play {count} matches.}}'**
  String achMatchesDesc(int count);

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'World Championship Qualifier'**
  String get achQualWc;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Reach the World Championship finals.'**
  String get achQualWcDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Continental Qualifier'**
  String get achQualCont;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Reach your continental championship finals.'**
  String get achQualContDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'World Champions'**
  String get achTitleWc;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the World Championship.'**
  String get achTitleWcDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'European Champions'**
  String get achTitleEuro;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the European Championship.'**
  String get achTitleEuroDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'South America Champions'**
  String get achTitleCopa;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the South America Cup.'**
  String get achTitleCopaDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'African Champions'**
  String get achTitleAfcon;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the African Championship.'**
  String get achTitleAfconDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Asian Champions'**
  String get achTitleAsia;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the Asian Championship.'**
  String get achTitleAsiaDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'North America Champions'**
  String get achTitleConcacaf;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the North America Cup.'**
  String get achTitleConcacafDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Oceania Champions'**
  String get achTitleOfc;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the Oceania Cup.'**
  String get achTitleOfcDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup Winners'**
  String get achTitleNations;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the Nations Cup.'**
  String get achTitleNationsDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Continental Clash Winners'**
  String get achTitleClash;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win the Continental Clash.'**
  String get achTitleClashDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'World Championship Marksman'**
  String get achMarksman;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Have a squad player score 6+ World Championship finals goals.'**
  String get achMarksmanDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Clean Sweep'**
  String get achSweep;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Hold the World Championship and your continental title in one career.'**
  String get achSweepDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Tournament All-Star'**
  String get achAllstar;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Have a player named in a World Championship Team of the Tournament.'**
  String get achAllstarDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Golden Boot'**
  String get achGoldenboot;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Have your nation finish as a championship top scorer.'**
  String get achGoldenbootDesc;

  /// Achievement title.
  ///
  /// In en, this message translates to:
  /// **'Demolition'**
  String get achDemolition;

  /// Achievement description.
  ///
  /// In en, this message translates to:
  /// **'Win a match by 5 goals or more.'**
  String get achDemolitionDesc;

  /// Dismiss button on the achievement-unlocked dialog.
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get achievementsNice;

  /// Intro blurb on the challenges screen.
  ///
  /// In en, this message translates to:
  /// **'The hardest tests of a manager, across a whole career and many nations.'**
  String get achievementsHardestTests;

  /// Section heading for this save's procedural challenges.
  ///
  /// In en, this message translates to:
  /// **'THIS SAVE'**
  String get achievementsThisSave;

  /// Badge marking an especially hard challenge.
  ///
  /// In en, this message translates to:
  /// **'BRUTAL'**
  String get achievementsBrutalBadge;

  /// Paywall heading inviting the player to upgrade to Pro.
  ///
  /// In en, this message translates to:
  /// **'GO PRO'**
  String get paywallGoPro;

  /// Paywall subtitle clarifying it is a one-off purchase.
  ///
  /// In en, this message translates to:
  /// **'One-time unlock. No subscription.'**
  String get paywallOneTimeUnlock;

  /// Paywall benefit line.
  ///
  /// In en, this message translates to:
  /// **'Manage every nation in the world'**
  String get paywallBenefitEveryNation;

  /// Paywall benefit line.
  ///
  /// In en, this message translates to:
  /// **'10 save slots instead of 3'**
  String get paywallBenefitSaveSlots;

  /// Paywall benefit line.
  ///
  /// In en, this message translates to:
  /// **'Unlimited careers, forever'**
  String get paywallBenefitEndless;

  /// Shown on the paywall once premium is already unlocked.
  ///
  /// In en, this message translates to:
  /// **'Premium is unlocked — enjoy!'**
  String get paywallUnlocked;

  /// Buy-button label while the purchase flow is in progress.
  ///
  /// In en, this message translates to:
  /// **'Contacting the store…'**
  String get paywallContactingStore;

  /// Buy-button label before the store price has loaded.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro'**
  String get paywallUnlockPro;

  /// Buy-button label with the store's localised price.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro · {price}'**
  String paywallUnlockProPriced(String price);

  /// Button that restores a previous purchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get paywallRestorePurchases;

  /// App-bar title on the naturalisation decision screen.
  ///
  /// In en, this message translates to:
  /// **'NATURALISATION'**
  String get federationNaturalisation;

  /// Inbox message title when a player completes naturalisation.
  ///
  /// In en, this message translates to:
  /// **'{name} naturalised'**
  String federationNaturalisedTitle(String name);

  /// Inbox message body when a player completes naturalisation.
  ///
  /// In en, this message translates to:
  /// **'{name} has completed the switch and is now eligible for {nation}. Call them up from your squad selection.'**
  String federationNaturalisedBody(String name, String nation);

  /// Error shown when the naturalisation offer fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load offer.\n{error}'**
  String federationCouldNotLoadOffer(String error);

  /// Button to continue when there is no pending offer.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get federationContinue;

  /// Heading on the naturalisation offer card.
  ///
  /// In en, this message translates to:
  /// **'AN OFFER TO SWITCH ALLEGIANCE'**
  String get federationOfferToSwitchAllegiance;

  /// Player subtitle: position, age and current nation.
  ///
  /// In en, this message translates to:
  /// **'{position} · age {age} · from {nation}'**
  String federationPlayerMeta(String position, int age, String nation);

  /// Explanatory paragraph on the naturalisation offer.
  ///
  /// In en, this message translates to:
  /// **'{name} has ties to {playerNation} and is willing to be naturalised. Accept and they can be selected; decline and they stay with {sourceNation}.'**
  String federationNaturalisationBlurb(
    String name,
    String playerNation,
    String sourceNation,
  );

  /// Button declining the naturalisation offer.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get federationDecline;

  /// Button accepting the naturalisation offer.
  ///
  /// In en, this message translates to:
  /// **'Naturalise'**
  String get federationNaturalise;

  /// Leaves the budget screen without allocating; the hub will ask again.
  ///
  /// In en, this message translates to:
  /// **'Decide later'**
  String get federationBudgetLater;

  /// App-bar title on the forced budget-setup screen.
  ///
  /// In en, this message translates to:
  /// **'SET YOUR BUDGET'**
  String get federationSetYourBudget;

  /// Error shown when the finances/budget data fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load finances.\n{error}'**
  String federationCouldNotLoadFinances(String error);

  /// Shown when the career save can't be found.
  ///
  /// In en, this message translates to:
  /// **'Save not found.'**
  String get federationSaveNotFound;

  /// Banner heading on the budget-setup screen.
  ///
  /// In en, this message translates to:
  /// **'FEDERATION BUDGET'**
  String get federationBudgetHeading;

  /// Budget-setup banner instruction with the amount to allocate.
  ///
  /// In en, this message translates to:
  /// **'Distribute {amount} across the departments to open the cycle. Spend it wisely.'**
  String federationDistributeBudget(String amount);

  /// Shown when departments plus staff wages exceed the budget.
  ///
  /// In en, this message translates to:
  /// **'{amount} more than the federation has — take some back'**
  String federationOverBudget(String amount);

  /// Hint shown until the whole budget is allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocate the full budget to begin the cycle.'**
  String get federationAllocateFullBudget;

  /// Budget confirm button label while saving.
  ///
  /// In en, this message translates to:
  /// **'Confirming…'**
  String get federationConfirming;

  /// Button confirming the budget allocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm budget'**
  String get federationConfirmBudget;

  /// App-bar title on the finances screen.
  ///
  /// In en, this message translates to:
  /// **'FINANCES'**
  String get federationFinances;

  /// Snackbar after saving the investment plan.
  ///
  /// In en, this message translates to:
  /// **'Investment updated.'**
  String get federationInvestmentUpdated;

  /// Section heading above the federation buildings.
  ///
  /// In en, this message translates to:
  /// **'FEDERATION DEVELOPMENT'**
  String get federationDevelopment;

  /// Section heading above projected income.
  ///
  /// In en, this message translates to:
  /// **'PROJECTED AT SEASON END'**
  String get federationProjectedAtSeasonEnd;

  /// Income line: central grant.
  ///
  /// In en, this message translates to:
  /// **'Central funding'**
  String get federationCentralFunding;

  /// Income line: prize money earned so far.
  ///
  /// In en, this message translates to:
  /// **'Prize money so far'**
  String get federationPrizeMoneySoFar;

  /// Income/impact line: commercial return.
  ///
  /// In en, this message translates to:
  /// **'Commercial return'**
  String get federationCommercialReturn;

  /// Section heading above this season's locked investment.
  ///
  /// In en, this message translates to:
  /// **'THIS SEASON (LOCKED)'**
  String get federationThisSeasonLocked;

  /// Section heading above the investment editor.
  ///
  /// In en, this message translates to:
  /// **'INVEST FOR NEXT SEASON'**
  String get federationInvestForNextSeason;

  /// Section heading above the impact preview.
  ///
  /// In en, this message translates to:
  /// **'NEXT SEASON IMPACT'**
  String get federationNextSeasonImpact;

  /// Investment confirm button label while saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get federationSaving;

  /// Button confirming the investment plan.
  ///
  /// In en, this message translates to:
  /// **'Confirm investment'**
  String get federationConfirmInvestment;

  /// Label above the cash balance figure.
  ///
  /// In en, this message translates to:
  /// **'FEDERATION BALANCE'**
  String get federationBalance;

  /// Hint under the locked-investment card.
  ///
  /// In en, this message translates to:
  /// **'Invest for next season at the end-of-cycle ceremony.'**
  String get federationInvestAtCeremony;

  /// Compact building-level badge, e.g. L3.
  ///
  /// In en, this message translates to:
  /// **'L{level}'**
  String federationLevelBadge(int level);

  /// Impact row: youth academy prospects.
  ///
  /// In en, this message translates to:
  /// **'Academy prospects'**
  String get federationAcademyProspects;

  /// Impact value: bonus to a player's overall rating.
  ///
  /// In en, this message translates to:
  /// **'+{value} overall'**
  String federationPlusOverall(int value);

  /// Impact row: injury risk.
  ///
  /// In en, this message translates to:
  /// **'Injury risk'**
  String get federationInjuryRisk;

  /// Impact row: chance of a naturalisation offer.
  ///
  /// In en, this message translates to:
  /// **'Naturalisation chance'**
  String get federationNaturalisationChance;

  /// Impact row: board patience/tolerance.
  ///
  /// In en, this message translates to:
  /// **'Board patience'**
  String get federationBoardPatience;

  /// Label for the remaining unallocated budget in the editor.
  ///
  /// In en, this message translates to:
  /// **'UNALLOCATED'**
  String get federationUnallocated;

  /// App-bar title on the national vitrine screen.
  ///
  /// In en, this message translates to:
  /// **'NATIONAL VITRINE'**
  String get nationsVitrineTitle;

  /// Error state when the nation fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load nation.\n{error}'**
  String nationsCouldNotLoad(String error);

  /// Shown when there is no nation data.
  ///
  /// In en, this message translates to:
  /// **'No nation.'**
  String get nationsNoNation;

  /// Heading over the nation's honours.
  ///
  /// In en, this message translates to:
  /// **'HONOURS'**
  String get nationsHonours;

  /// Heading of the nation's world ranking history chart.
  ///
  /// In en, this message translates to:
  /// **'WORLD RANKING HISTORY'**
  String get nationsRankingHistory;

  /// Heading over the nation's all-time top scorers.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME TOP SCORERS'**
  String get nationsTopScorers;

  /// Heading over the nation's titles tally.
  ///
  /// In en, this message translates to:
  /// **'TITLES'**
  String get nationsTitles;

  /// Column header marking the manager's own nation.
  ///
  /// In en, this message translates to:
  /// **'YOUR TEAM'**
  String get nationsYourTeam;

  /// Column header for the world/global column.
  ///
  /// In en, this message translates to:
  /// **'WORLD'**
  String get nationsWorld;

  /// Honours label: World Cup.
  ///
  /// In en, this message translates to:
  /// **'World Cup'**
  String get nationsWorldCup;

  /// Honours label: continental title.
  ///
  /// In en, this message translates to:
  /// **'Continental'**
  String get nationsContinental;

  /// Number of tournament appearances.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 appearance} other{{count} appearances}}'**
  String nationsAppearances(int count);

  /// Empty state when there isn't enough ranking history yet.
  ///
  /// In en, this message translates to:
  /// **'Not enough history yet — check back after a cycle or two.'**
  String get nationsNotEnoughHistory;

  /// Best world ranking reached.
  ///
  /// In en, this message translates to:
  /// **'Best: #{rank}'**
  String nationsBestRank(int rank);

  /// Current world ranking.
  ///
  /// In en, this message translates to:
  /// **'Now: #{rank}'**
  String nationsNowRank(int rank);

  /// Empty state for the top-scorers list.
  ///
  /// In en, this message translates to:
  /// **'No goals recorded yet.'**
  String get nationsNoGoals;

  /// Abbreviated unit for goals.
  ///
  /// In en, this message translates to:
  /// **'gls'**
  String get nationsGoalsAbbrev;

  /// Badge marking a tournament the nation hosted.
  ///
  /// In en, this message translates to:
  /// **'HOSTS'**
  String get nationsHosts;

  /// App-bar title on the nation picker screen.
  ///
  /// In en, this message translates to:
  /// **'SELECT NATIONAL TEAM'**
  String get nationsSelectTitle;

  /// Error state when the nations list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load nations.\n{error}'**
  String nationsCouldNotLoadNations(String error);

  /// Shown when a search returns no nations.
  ///
  /// In en, this message translates to:
  /// **'No nations match.'**
  String get nationsNoMatch;

  /// Heading over a nation's strength level.
  ///
  /// In en, this message translates to:
  /// **'NATIONAL LEVEL'**
  String get nationsNationalLevel;

  /// Heading on the nation picker.
  ///
  /// In en, this message translates to:
  /// **'Select National Team'**
  String get nationsSelectHeading;

  /// Search box hint in the nation picker.
  ///
  /// In en, this message translates to:
  /// **'Search country…'**
  String get nationsSearchHint;

  /// Label prefix before a nation's rank number.
  ///
  /// In en, this message translates to:
  /// **'RANK '**
  String get nationsRank;

  /// Badge marking a premium-only nation.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get nationsPremium;

  /// Button that selects the nation.
  ///
  /// In en, this message translates to:
  /// **'SELECT'**
  String get nationsSelect;

  /// Bottom-nav label: career.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get nationsNavCareer;

  /// Bottom-nav label: tactics.
  ///
  /// In en, this message translates to:
  /// **'Tactics'**
  String get nationsNavTactics;

  /// Bottom-nav label: nations.
  ///
  /// In en, this message translates to:
  /// **'Nations'**
  String get nationsNavNations;

  /// Bottom-nav label: settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nationsNavSettings;

  /// App-bar title on the team records screen.
  ///
  /// In en, this message translates to:
  /// **'TEAM RECORDS'**
  String get statsTeamRecords;

  /// Nav card: record book.
  ///
  /// In en, this message translates to:
  /// **'Record book'**
  String get statsRecordBook;

  /// Error state when the stats fail to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load stats.\n{error}'**
  String statsCouldNotLoadStats(String error);

  /// Shown when there is no stats data.
  ///
  /// In en, this message translates to:
  /// **'No data.'**
  String get statsNoData;

  /// Heading of the top-scorers list.
  ///
  /// In en, this message translates to:
  /// **'TOP SCORERS'**
  String get statsTopScorers;

  /// Heading of the most-appearances list.
  ///
  /// In en, this message translates to:
  /// **'MOST GAMES PLAYED'**
  String get statsMostGamesPlayed;

  /// Tab label: team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get statsTeam;

  /// Tab label: top scorers.
  ///
  /// In en, this message translates to:
  /// **'Scorers'**
  String get statsTopScorersShort;

  /// Tab label: most games.
  ///
  /// In en, this message translates to:
  /// **'Most games'**
  String get statsMostGames;

  /// Empty state for the top-scorers list.
  ///
  /// In en, this message translates to:
  /// **'No goals recorded yet.'**
  String get statsNoGoalsRecorded;

  /// Fallback for an unknown player.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statsUnknown;

  /// App-bar title on the player profile screen.
  ///
  /// In en, this message translates to:
  /// **'PLAYER'**
  String get playerTitle;

  /// Error state when the player fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load player.\n{error}'**
  String playerLoadError(String error);

  /// Shown when the player can't be found.
  ///
  /// In en, this message translates to:
  /// **'Player not found.'**
  String get playerNotFound;

  /// Heading over the player's club.
  ///
  /// In en, this message translates to:
  /// **'CLUB'**
  String get playerClub;

  /// Label: player position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get playerPosition;

  /// Label for a young player's scouted development-ceiling star rating.
  ///
  /// In en, this message translates to:
  /// **'Potential'**
  String get playerPotential;

  /// Label: player age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get playerAge;

  /// Label: player market value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get playerValue;

  /// Club standing: first choice.
  ///
  /// In en, this message translates to:
  /// **'Plays every week'**
  String get clubFirstChoice;

  /// Club standing: rotation player.
  ///
  /// In en, this message translates to:
  /// **'In and out'**
  String get clubRotation;

  /// Club standing: fringe player.
  ///
  /// In en, this message translates to:
  /// **'Barely playing'**
  String get clubFringe;

  /// Club standing: frozen out.
  ///
  /// In en, this message translates to:
  /// **'Not playing'**
  String get clubFrozenOut;

  /// Y post: winUpset, variant 0.
  ///
  /// In en, this message translates to:
  /// **'I have watched football for thirty years and I did not see that coming. {opponent} beaten {score}.'**
  String yWinUpset0(String opponent, String score);

  /// Y post: winUpset, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Nobody gave them a prayer against {opponent}. {score}. Absolutely nobody.'**
  String yWinUpset1(String opponent, String score);

  /// Y post: winUpset, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{score} against {opponent}. Go and wake the neighbours.'**
  String yWinUpset2(String opponent, String score);

  /// Y post: winUpset, variant 3.
  ///
  /// In en, this message translates to:
  /// **'That is the kind of night people describe to their grandchildren. {opponent} {score}.'**
  String yWinUpset3(String opponent, String score);

  /// Y post: winRoutine, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{score} against {opponent}. Job done, nothing learned.'**
  String yWinRoutine0(String opponent, String score);

  /// Y post: winRoutine, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Beat {opponent} {score}. We were supposed to, and we did.'**
  String yWinRoutine1(String opponent, String score);

  /// Y post: winRoutine, variant 2.
  ///
  /// In en, this message translates to:
  /// **'A professional {score} over {opponent}. Next.'**
  String yWinRoutine2(String opponent, String score);

  /// Y post: winRoutine, variant 3.
  ///
  /// In en, this message translates to:
  /// **'{opponent} dispatched {score}. File it and move on.'**
  String yWinRoutine3(String opponent, String score);

  /// Y post: winTight, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{score} against {opponent} and every minute of it earned.'**
  String yWinTight0(String opponent, String score);

  /// Y post: winTight, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Nervy, ugly, and a win. {opponent} {score}.'**
  String yWinTight1(String opponent, String score);

  /// Y post: winTight, variant 2.
  ///
  /// In en, this message translates to:
  /// **'Beat {opponent} {score}. Take the three points and never watch it again.'**
  String yWinTight2(String opponent, String score);

  /// Y post: winTight, variant 3.
  ///
  /// In en, this message translates to:
  /// **'{score}. {opponent} made us work for every inch of that.'**
  String yWinTight3(String opponent, String score);

  /// Y post: drew, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{score} with {opponent}. Two points dropped or one gained — pick your mood.'**
  String yDrew0(String opponent, String score);

  /// Y post: drew, variant 1.
  ///
  /// In en, this message translates to:
  /// **'A draw against {opponent}, {score}. Nobody is happy, nobody is furious.'**
  String yDrew1(String opponent, String score);

  /// Y post: drew, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent} {score}. The most forgettable ninety minutes of the year.'**
  String yDrew2(String opponent, String score);

  /// Y post: drew, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Shared the spoils with {opponent}, {score}. On we go.'**
  String yDrew3(String opponent, String score);

  /// Y post: lost, variant 0.
  ///
  /// In en, this message translates to:
  /// **'Beaten {score} by {opponent}. It happens.'**
  String yLost0(String opponent, String score);

  /// Y post: lost, variant 1.
  ///
  /// In en, this message translates to:
  /// **'{opponent} {score}. We were second best and there is no argument.'**
  String yLost1(String opponent, String score);

  /// Y post: lost, variant 2.
  ///
  /// In en, this message translates to:
  /// **'Lost {score} to {opponent}. Regroup.'**
  String yLost2(String opponent, String score);

  /// Y post: lost, variant 3.
  ///
  /// In en, this message translates to:
  /// **'{score} to {opponent}. Not a disgrace, not good enough.'**
  String yLost3(String opponent, String score);

  /// Y post: lostBadly, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{score}. To {opponent}. I have no words and I am paid to have words.'**
  String yLostBadly0(String opponent, String score);

  /// Y post: lostBadly, variant 1.
  ///
  /// In en, this message translates to:
  /// **'That was not a defeat to {opponent}, it was a surrender. {score}.'**
  String yLostBadly1(String opponent, String score);

  /// Y post: lostBadly, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent} {score}. Somebody has to answer for that.'**
  String yLostBadly2(String opponent, String score);

  /// Y post: lostBadly, variant 3.
  ///
  /// In en, this message translates to:
  /// **'I want the {score} against {opponent} struck from the record and from memory.'**
  String yLostBadly3(String opponent, String score);

  /// Y post: trophy, variant 0.
  ///
  /// In en, this message translates to:
  /// **'CHAMPIONS. {opponent}. Say it out loud.'**
  String yTrophy0(String opponent);

  /// Y post: trophy, variant 1.
  ///
  /// In en, this message translates to:
  /// **'We won it. {opponent}. I am not okay.'**
  String yTrophy1(String opponent);

  /// Y post: trophy, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent} — and the trophy is coming home.'**
  String yTrophy2(String opponent);

  /// Y post: trophy, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Every single one of them a legend. {opponent}.'**
  String yTrophy3(String opponent);

  /// Y post: runnerUp, variant 0.
  ///
  /// In en, this message translates to:
  /// **'So close. {opponent} and a medal nobody wants.'**
  String yRunnerUp0(String opponent);

  /// Y post: runnerUp, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Runners-up at {opponent}. It will sting for years.'**
  String yRunnerUp1(String opponent);

  /// Y post: runnerUp, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent}: one match from everything.'**
  String yRunnerUp2(String opponent);

  /// Y post: runnerUp, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Second. At {opponent}. Somebody pass the bottle.'**
  String yRunnerUp3(String opponent);

  /// Y post: eliminated, variant 0.
  ///
  /// In en, this message translates to:
  /// **'Out at {opponent}. Same script, different year.'**
  String yEliminated0(String opponent);

  /// Y post: eliminated, variant 1.
  ///
  /// In en, this message translates to:
  /// **'{opponent} is where it ends. Again.'**
  String yEliminated1(String opponent);

  /// Y post: eliminated, variant 2.
  ///
  /// In en, this message translates to:
  /// **'Eliminated at {opponent}. Now the inquest.'**
  String yEliminated2(String opponent);

  /// Y post: eliminated, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Knocked out at {opponent}. Somebody explain that to me.'**
  String yEliminated3(String opponent);

  /// Y post: qualified, variant 0.
  ///
  /// In en, this message translates to:
  /// **'WE ARE GOING TO {opponent}.'**
  String yQualified0(String opponent);

  /// Y post: qualified, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Qualified for {opponent}. Book the time off work.'**
  String yQualified1(String opponent);

  /// Y post: qualified, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent}, here we come. Never in doubt (it was entirely in doubt).'**
  String yQualified2(String opponent);

  /// Y post: qualified, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Through to {opponent}. That is the hard part done.'**
  String yQualified3(String opponent);

  /// Y post: groupDrawn, variant 0.
  ///
  /// In en, this message translates to:
  /// **'Group drawn for {opponent}. Could be worse. Could be a lot worse.'**
  String yGroupDrawn0(String opponent);

  /// Y post: groupDrawn, variant 1.
  ///
  /// In en, this message translates to:
  /// **'So that is the {opponent} draw. Interesting.'**
  String yGroupDrawn1(String opponent);

  /// Y post: groupDrawn, variant 2.
  ///
  /// In en, this message translates to:
  /// **'The {opponent} groups are out and I already do not like ours.'**
  String yGroupDrawn2(String opponent);

  /// Y post: groupDrawn, variant 3.
  ///
  /// In en, this message translates to:
  /// **'{opponent} draw made. Let the overreaction begin.'**
  String yGroupDrawn3(String opponent);

  /// Y post: hostNamed, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{opponent} will host it. Start saving.'**
  String yHostNamed0(String opponent);

  /// Y post: hostNamed, variant 1.
  ///
  /// In en, this message translates to:
  /// **'It is going to {opponent}. Predictable, but fine.'**
  String yHostNamed1(String opponent);

  /// Y post: hostNamed, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent} gets the tournament. Congratulations to them, I suppose.'**
  String yHostNamed2(String opponent);

  /// Y post: hostNamed, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Hosts confirmed: {opponent}.'**
  String yHostNamed3(String opponent);

  /// Y post: tournamentSoon, variant 0.
  ///
  /// In en, this message translates to:
  /// **'{opponent} starts soon and I cannot sit still.'**
  String yTournamentSoon0(String opponent);

  /// Y post: tournamentSoon, variant 1.
  ///
  /// In en, this message translates to:
  /// **'Not long now until {opponent}.'**
  String yTournamentSoon1(String opponent);

  /// Y post: tournamentSoon, variant 2.
  ///
  /// In en, this message translates to:
  /// **'{opponent} is nearly here. Squad announcement, please.'**
  String yTournamentSoon2(String opponent);

  /// Y post: tournamentSoon, variant 3.
  ///
  /// In en, this message translates to:
  /// **'Countdown to {opponent} is officially unbearable.'**
  String yTournamentSoon3(String opponent);

  /// Bottom navigation label for the Y feed.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get navY;

  /// Title of the Y feed screen.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get yTitle;

  /// Empty state on the Y feed.
  ///
  /// In en, this message translates to:
  /// **'Nothing to say yet. Play a match.'**
  String get yEmpty;

  /// Player agency: hubEventGrievance.
  ///
  /// In en, this message translates to:
  /// **'{player} wants a word'**
  String hubEventGrievance(String player);

  /// Player agency: hubEventGrievanceSub.
  ///
  /// In en, this message translates to:
  /// **'He wants to know where he stands'**
  String get hubEventGrievanceSub;

  /// Player agency: grievanceTitle.
  ///
  /// In en, this message translates to:
  /// **'A word in your office'**
  String get grievanceTitle;

  /// Player agency: grievanceGameTime.
  ///
  /// In en, this message translates to:
  /// **'{player} has been in the squad and has not kicked a ball. He wants to know why.'**
  String grievanceGameTime(String player);

  /// Player agency: grievanceSquadPlace.
  ///
  /// In en, this message translates to:
  /// **'{player} is not in the squad and cannot understand it. He wants telling, one way or the other.'**
  String grievanceSquadPlace(String player);

  /// Player agency: grievanceRole.
  ///
  /// In en, this message translates to:
  /// **'{player} keeps being played out of position and has had enough of it.'**
  String grievanceRole(String player);

  /// Player agency: grievanceReassure.
  ///
  /// In en, this message translates to:
  /// **'You are in my plans'**
  String get grievanceReassure;

  /// Player agency: grievanceHonest.
  ///
  /// In en, this message translates to:
  /// **'You are behind others, and here is why'**
  String get grievanceHonest;

  /// Player agency: grievanceDismiss.
  ///
  /// In en, this message translates to:
  /// **'I pick the team'**
  String get grievanceDismiss;

  /// Y post naming the match scorer and how many he got. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'{name} got {goals} of them. Nobody else is close.'**
  String yScorerStar0(String name, String goals);

  /// Y post naming the match scorer and how many he got. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'{goals} for {name}. He is carrying this side.'**
  String yScorerStar1(String name, String goals);

  /// Y post naming the match scorer and how many he got. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'{name}: {goals} on the day. Some player.'**
  String yScorerStar2(String name, String goals);

  /// Y post naming the match scorer and how many he got. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'Put {goals} past them, did {name}. Take a bow.'**
  String yScorerStar3(String name, String goals);

  /// Y post remarking on a run of wins. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'{count} on the bounce. Whatever is being said in that dressing room, it is landing.'**
  String yWinStreak0(String count);

  /// Y post remarking on a run of wins. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'That is {count} straight. Sides do not stumble into runs like this.'**
  String yWinStreak1(String count);

  /// Y post remarking on a run of wins. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'{count} in a row and counting. The confidence is visible from the stands.'**
  String yWinStreak2(String count);

  /// Y post remarking on a run of wins. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'No defeats in {count}. Ask anyone who has managed — that is the hard part.'**
  String yWinStreak3(String count);

  /// Y post remarking on a run without a win. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'{count} without a win now. At some point the excuses run out.'**
  String yLossStreak0(String count);

  /// Y post remarking on a run without a win. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'That is {count} in a row gone. This is not a blip any more.'**
  String yLossStreak1(String count);

  /// Y post remarking on a run without a win. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'{count} straight defeats. Somebody has to answer for it.'**
  String yLossStreak2(String count);

  /// Y post remarking on a run without a win. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'No wins in {count}. You can see it in how they play.'**
  String yLossStreak3(String count);

  /// Y post about a result against a rival nation. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'{opponent} {score}. Say what you like about the football — this one counts double.'**
  String yRivalry0(String opponent, String score);

  /// Y post about a result against a rival nation. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'Against {opponent}, of all of them. {score}. Nobody here will forget it.'**
  String yRivalry1(String opponent, String score);

  /// Y post about a result against a rival nation. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'{score} against {opponent}. That is the one they will talk about in the pubs.'**
  String yRivalry2(String opponent, String score);

  /// Y post about a result against a rival nation. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'Neighbours, {score}. Bragging rights settled for a while.'**
  String yRivalry3(String opponent, String score);

  /// Y post about a player picking up an injury. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'{name} off injured. That is the last thing this side needed.'**
  String yInjuryBlow0(String name);

  /// Y post about a player picking up an injury. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'Losing {name} changes the shape of everything.'**
  String yInjuryBlow1(String name);

  /// Y post about a player picking up an injury. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'{name} limping. Hold your breath.'**
  String yInjuryBlow2(String name);

  /// Y post about a player picking up an injury. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'No {name} for a while, then. Somebody has to step up.'**
  String yInjuryBlow3(String name);

  /// Y post about the board losing patience. Variant 0.
  ///
  /// In en, this message translates to:
  /// **'The board have gone very quiet. That is never a good sign.'**
  String get yBoardPressure0;

  /// Y post about the board losing patience. Variant 1.
  ///
  /// In en, this message translates to:
  /// **'Word is the boardroom has started asking questions.'**
  String get yBoardPressure1;

  /// Y post about the board losing patience. Variant 2.
  ///
  /// In en, this message translates to:
  /// **'You can feel the ground shifting upstairs.'**
  String get yBoardPressure2;

  /// Y post about the board losing patience. Variant 3.
  ///
  /// In en, this message translates to:
  /// **'Nobody at the federation is saying anything supportive. Draw your own conclusions.'**
  String get yBoardPressure3;

  /// Heading over the other posts about the same event, on a Y post's detail.
  ///
  /// In en, this message translates to:
  /// **'ALSO ABOUT THIS MATCH'**
  String get yReplies;

  /// Player agency: yPlayerGrievance0.
  ///
  /// In en, this message translates to:
  /// **'Asked where I stand. Still waiting on an answer.'**
  String get yPlayerGrievance0;

  /// Player agency: yPlayerGrievance1.
  ///
  /// In en, this message translates to:
  /// **'Training hard. Not much else I can do.'**
  String get yPlayerGrievance1;

  /// Player agency: yPlayerGrievance2.
  ///
  /// In en, this message translates to:
  /// **'Some questions you only get to ask once.'**
  String get yPlayerGrievance2;

  /// Player agency: yPlayerGrievance3.
  ///
  /// In en, this message translates to:
  /// **'I did not come this far to carry the bibs.'**
  String get yPlayerGrievance3;

  /// Award: playerHonoursTitle.
  ///
  /// In en, this message translates to:
  /// **'HONOURS'**
  String get playerHonoursTitle;

  /// Award: awardGoldenBall.
  ///
  /// In en, this message translates to:
  /// **'Golden Ball'**
  String get awardGoldenBall;

  /// Award: awardGoldenBoot.
  ///
  /// In en, this message translates to:
  /// **'Golden Boot'**
  String get awardGoldenBoot;

  /// Award: awardGoldenGlove.
  ///
  /// In en, this message translates to:
  /// **'Golden Glove'**
  String get awardGoldenGlove;

  /// Award: awardTeamOfTournament.
  ///
  /// In en, this message translates to:
  /// **'Team of the Tournament'**
  String get awardTeamOfTournament;

  /// Award: awardPlayerOfYear.
  ///
  /// In en, this message translates to:
  /// **'World Player of the Year'**
  String get awardPlayerOfYear;

  /// Award: awardYoungPlayerOfYear.
  ///
  /// In en, this message translates to:
  /// **'Young Player of the Year'**
  String get awardYoungPlayerOfYear;

  /// Heading above a player's list of club spells on the detail card.
  ///
  /// In en, this message translates to:
  /// **'CLUB HISTORY'**
  String get playerClubHistory;

  /// Heading over the player's career record.
  ///
  /// In en, this message translates to:
  /// **'CAREER RECORD'**
  String get playerCareerRecord;

  /// Label: international goals.
  ///
  /// In en, this message translates to:
  /// **'International goals'**
  String get playerInternationalGoals;

  /// Heading over the player's recent form.
  ///
  /// In en, this message translates to:
  /// **'RECENT FORM'**
  String get playerRecentForm;

  /// Heading over the player's match history.
  ///
  /// In en, this message translates to:
  /// **'MATCH HISTORY'**
  String get playerMatchHistory;

  /// Heading over the player's attributes.
  ///
  /// In en, this message translates to:
  /// **'ATTRIBUTES'**
  String get playerAttributes;

  /// Fallback for an unknown player value.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get playerUnknown;

  /// Attribute label: pace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get playerAttrPace;

  /// Attribute label: physical ability.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get playerAttrPhysical;

  /// Attribute label: technical ability.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get playerAttrTechnical;

  /// Attribute label: shooting.
  ///
  /// In en, this message translates to:
  /// **'Shooting'**
  String get playerAttrShooting;

  /// Attribute label: passing.
  ///
  /// In en, this message translates to:
  /// **'Passing'**
  String get playerAttrPassing;

  /// Attribute label: dribbling.
  ///
  /// In en, this message translates to:
  /// **'Dribbling'**
  String get playerAttrDribbling;

  /// Attribute label: tackling.
  ///
  /// In en, this message translates to:
  /// **'Tackling'**
  String get playerAttrTackling;

  /// Attribute label: positioning.
  ///
  /// In en, this message translates to:
  /// **'Positioning'**
  String get playerAttrPositioning;

  /// Attribute label: composure.
  ///
  /// In en, this message translates to:
  /// **'Composure'**
  String get playerAttrComposure;

  /// Attribute label: decisions.
  ///
  /// In en, this message translates to:
  /// **'Decisions'**
  String get playerAttrDecisions;

  /// Attribute label: stamina.
  ///
  /// In en, this message translates to:
  /// **'Stamina'**
  String get playerAttrStamina;

  /// Attribute label: strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get playerAttrStrength;

  /// Stat label: caps.
  ///
  /// In en, this message translates to:
  /// **'Caps'**
  String get playerStatCaps;

  /// Stat label: goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get playerStatGoals;

  /// Stat label: assists.
  ///
  /// In en, this message translates to:
  /// **'Assists'**
  String get playerStatAssists;

  /// Stat label: average rating.
  ///
  /// In en, this message translates to:
  /// **'Avg rating'**
  String get playerStatAvgRating;

  /// Stat label: form.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get playerStatForm;

  /// Stat label: player-of-the-match awards.
  ///
  /// In en, this message translates to:
  /// **'Player of Match'**
  String get playerStatMotm;

  /// Stat label: clean sheets.
  ///
  /// In en, this message translates to:
  /// **'Clean sheets'**
  String get playerStatCleanSheets;

  /// Stat label: best game rating.
  ///
  /// In en, this message translates to:
  /// **'Best game'**
  String get playerStatBestGame;

  /// Stat label: cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get playerStatCards;

  /// Card tally: yellow and red cards.
  ///
  /// In en, this message translates to:
  /// **'{yellows}Y {reds}R'**
  String playerCardsValue(int yellows, int reds);

  /// Heading over the manager's run summary above a knockout bracket.
  ///
  /// In en, this message translates to:
  /// **'YOUR RUN'**
  String get tourSharedYourRun;

  /// Bracket view toggle: list view.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tourSharedList;

  /// Bracket view toggle: visual bracket view.
  ///
  /// In en, this message translates to:
  /// **'Bracket'**
  String get tourSharedBracket;

  /// Separator between two teams in an undecided knockout tie.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get tourSharedVs;

  /// A finalist's group-stage seed, e.g. "Group A2".
  ///
  /// In en, this message translates to:
  /// **'Group {seed}'**
  String tourSharedGroupSeed(String seed);

  /// Scorer chart toggle: this edition's scorers.
  ///
  /// In en, this message translates to:
  /// **'This edition'**
  String get tourSharedThisEdition;

  /// Scorer chart toggle: all-time scorers.
  ///
  /// In en, this message translates to:
  /// **'All-time'**
  String get tourSharedAllTime;

  /// Fallback name for an unknown player.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get tourSharedUnknown;

  /// Chip marking a still-active player in the all-time scorer chart.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get tourSharedActive;

  /// Heading over a competition's all-time medal table.
  ///
  /// In en, this message translates to:
  /// **'MEDAL TABLE'**
  String get tourSharedMedalTable;

  /// Heading over a competition's list of past editions.
  ///
  /// In en, this message translates to:
  /// **'PAST WINNERS'**
  String get tourSharedPastWinners;

  /// Host nation of a past edition.
  ///
  /// In en, this message translates to:
  /// **'Host: {host}'**
  String tourSharedHost(String host);

  /// Shown between champion and runner-up when the final's scoreline is unknown.
  ///
  /// In en, this message translates to:
  /// **'beat'**
  String get tourSharedBeat;

  /// Suffix on a final's scoreline decided on penalties (leading space intentional).
  ///
  /// In en, this message translates to:
  /// **' (pens)'**
  String get tourSharedPens;

  /// Empty state on the awards tab before the tournament is finished.
  ///
  /// In en, this message translates to:
  /// **'The awards are decided once the tournament is played out.'**
  String get tourSharedAwardsEmpty;

  /// Award label: best player of the tournament.
  ///
  /// In en, this message translates to:
  /// **'GOLDEN BALL'**
  String get tourSharedGoldenBall;

  /// Subtitle of the Golden Ball award.
  ///
  /// In en, this message translates to:
  /// **'Player of the Tournament'**
  String get tourSharedPlayerOfTournament;

  /// Award label: top scorer of the tournament.
  ///
  /// In en, this message translates to:
  /// **'GOLDEN BOOT'**
  String get tourSharedGoldenBoot;

  /// A tally of goals.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 goal} other{{count} goals}}'**
  String tourSharedGoalsCount(int count);

  /// Award label: best goalkeeper of the tournament.
  ///
  /// In en, this message translates to:
  /// **'GOLDEN GLOVE'**
  String get tourSharedGoldenGlove;

  /// Heading over the best XI of the tournament.
  ///
  /// In en, this message translates to:
  /// **'TEAM OF THE TOURNAMENT'**
  String get tourSharedTeamOfTournament;

  /// Empty state on the stats tab before the competition has history.
  ///
  /// In en, this message translates to:
  /// **'Records appear once the competition has some history.'**
  String get tourSharedStatsEmpty;

  /// Record label: the competition's all-time top scorer.
  ///
  /// In en, this message translates to:
  /// **'RECORD SCORER'**
  String get tourSharedRecordScorer;

  /// Note that a record-holding player is still playing.
  ///
  /// In en, this message translates to:
  /// **'still active'**
  String get tourSharedStillActive;

  /// Record label: nation with the most titles.
  ///
  /// In en, this message translates to:
  /// **'MOST TITLES'**
  String get tourSharedMostTitles;

  /// A tally of titles won.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 title} other{{count} titles}}'**
  String tourSharedTitlesCount(int count);

  /// Record label: nation that reached the most finals.
  ///
  /// In en, this message translates to:
  /// **'MOST FINALS'**
  String get tourSharedMostFinals;

  /// A tally of finals a nation contested.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 final contested} other{{count} finals contested}}'**
  String tourSharedFinalsContested(int count);

  /// Record label: player with the most matches in this cup.
  ///
  /// In en, this message translates to:
  /// **'MOST GAMES PLAYED'**
  String get tourSharedMostGamesPlayed;

  /// A tally of matches played.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 match} other{{count} matches}}'**
  String tourSharedMatchesCount(int count);

  /// Record label: player who attended the most finals tournaments.
  ///
  /// In en, this message translates to:
  /// **'MOST FINALS PLAYED'**
  String get tourSharedMostFinalsPlayed;

  /// A tally of finals tournaments attended.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 finals tournament} other{{count} finals tournaments}}'**
  String tourSharedFinalsTournamentsCount(int count);

  /// Record label: the biggest winning margin in a final.
  ///
  /// In en, this message translates to:
  /// **'BIGGEST FINAL WIN'**
  String get tourSharedBiggestFinalWin;

  /// A tally of goals scored.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 goal} other{{count} goals}}'**
  String tourStatsGoals(int count);

  /// Suffix noting a record holder is still playing.
  ///
  /// In en, this message translates to:
  /// **'still active'**
  String get tourStatsStillActive;

  /// A tally of titles won.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 title} other{{count} titles}}'**
  String tourStatsTitles(int count);

  /// A tally of finals a nation has contested.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 final contested} other{{count} finals contested}}'**
  String tourStatsFinalsContested(int count);

  /// A tally of matches played.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 match} other{{count} matches}}'**
  String tourStatsMatches(int count);

  /// A tally of tournaments in which a player reached the final.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 finals tournament} other{{count} finals tournaments}}'**
  String tourStatsFinalsTournaments(int count);

  /// Heading above the all-time leaderboard tables.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME LEADERS'**
  String get tourStatsLeaders;

  /// Leaderboard tab: most matches played.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get tourStatsTabGames;

  /// Leaderboard tab: most cup editions played.
  ///
  /// In en, this message translates to:
  /// **'Cups'**
  String get tourStatsTabCups;

  /// Leaderboard tab: top goalscorers.
  ///
  /// In en, this message translates to:
  /// **'Scorers'**
  String get tourStatsTabScorers;

  /// Detail line under the biggest-final-win record: opponent and year.
  ///
  /// In en, this message translates to:
  /// **'v {opponent} · {year}'**
  String tourSharedFinalWinDetail(String opponent, int year);

  /// Heading over the all-time scorer chart on the stats tab.
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME SCORERS'**
  String get tourSharedAllTimeScorers;

  /// Empty state on the summary tab before the edition is drawn.
  ///
  /// In en, this message translates to:
  /// **'The host and its stadiums appear once this edition is drawn.'**
  String get tourSharedSummaryEmpty;

  /// Heading over a single host nation.
  ///
  /// In en, this message translates to:
  /// **'HOST'**
  String get tourSharedHostHeading;

  /// Heading over multiple host nations.
  ///
  /// In en, this message translates to:
  /// **'HOSTS'**
  String get tourSharedHostsHeading;

  /// Heading over jointly hosting nations.
  ///
  /// In en, this message translates to:
  /// **'CO-HOSTS'**
  String get tourSharedCoHostsHeading;

  /// Heading over the list of tournament stadiums.
  ///
  /// In en, this message translates to:
  /// **'VENUES'**
  String get tourSharedVenues;

  /// Label for the edition's official mascot.
  ///
  /// In en, this message translates to:
  /// **'MASCOT'**
  String get tourSharedMascot;

  /// Label for the edition's official match ball.
  ///
  /// In en, this message translates to:
  /// **'MATCH BALL'**
  String get tourSharedMatchBall;

  /// A stadium's city and seat count.
  ///
  /// In en, this message translates to:
  /// **'{city} · {capacity} seats'**
  String tourSharedVenueSeats(String city, String capacity);

  /// Generic error when the kickoff ceremony fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load.'**
  String get tourSharedCouldNotLoad;

  /// Kickoff ceremony host line before the host is known.
  ///
  /// In en, this message translates to:
  /// **'HOST TO BE CONFIRMED'**
  String get tourSharedHostTbc;

  /// Kickoff ceremony tagline.
  ///
  /// In en, this message translates to:
  /// **'THE FINALS ARE HERE'**
  String get tourSharedFinalsAreHere;

  /// Kickoff ceremony host line (double space intentional).
  ///
  /// In en, this message translates to:
  /// **'HOSTED BY  {hosts}'**
  String tourSharedHostedBy(String hosts);

  /// Button that closes the kickoff ceremony and starts the finals.
  ///
  /// In en, this message translates to:
  /// **'Let the finals begin'**
  String get tourSharedLetFinalsBegin;

  /// App-bar title on the tournaments overview.
  ///
  /// In en, this message translates to:
  /// **'COMPETITIONS'**
  String get tourSharedCompetitions;

  /// Tooltip on the world-ranking button.
  ///
  /// In en, this message translates to:
  /// **'World ranking'**
  String get tourSharedWorldRanking;

  /// Error when the tournaments overview fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load tournaments.'**
  String get tourSharedCouldNotLoadTournaments;

  /// Eyebrow heading above the tournaments overview title.
  ///
  /// In en, this message translates to:
  /// **'PRESTIGE STAGE'**
  String get tourSharedPrestigeStage;

  /// Title of the tournaments overview screen.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tourSharedOverview;

  /// Title of the world-ranking card on the tournaments overview.
  ///
  /// In en, this message translates to:
  /// **'World Ranking'**
  String get tourSharedWorldRankingTitle;

  /// Section heading for the player's own competitions.
  ///
  /// In en, this message translates to:
  /// **'YOUR COMPETITIONS'**
  String get tourSharedYourCompetitions;

  /// Section heading for other continents' competitions.
  ///
  /// In en, this message translates to:
  /// **'OTHER CONTINENTS'**
  String get tourSharedOtherContinents;

  /// Snackbar shown when tapping a not-yet-available competition tile.
  ///
  /// In en, this message translates to:
  /// **'Tournament coming soon'**
  String get tourSharedComingSoon;

  /// Fallback status badge for a competition tile not yet available.
  ///
  /// In en, this message translates to:
  /// **'SOON'**
  String get tourSharedSoon;

  /// Shown when there is no qualifying draw to display.
  ///
  /// In en, this message translates to:
  /// **'No qualifying draw.'**
  String get tourSharedNoQualifyingDraw;

  /// Button that reveals the drawn World Cup host.
  ///
  /// In en, this message translates to:
  /// **'Open the envelope'**
  String get tourSharedOpenEnvelope;

  /// A draw group's heading, e.g. "GROUP A".
  ///
  /// In en, this message translates to:
  /// **'GROUP {name}'**
  String tourSharedGroupName(String name);

  /// Draw grain toggle: reveal one team (ball) at a time.
  ///
  /// In en, this message translates to:
  /// **'Ball'**
  String get tourSharedBall;

  /// Draw grain toggle: reveal a whole pot at a time.
  ///
  /// In en, this message translates to:
  /// **'Pot'**
  String get tourSharedPot;

  /// Draw grain toggle: reveal the whole draw at once.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tourSharedAll;

  /// Hint under the draw when revealing one team at a time.
  ///
  /// In en, this message translates to:
  /// **'Tap to draw the next team'**
  String get tourSharedTapDrawTeam;

  /// Hint under the draw when revealing a whole pot at a time.
  ///
  /// In en, this message translates to:
  /// **'Tap to draw the next pot'**
  String get tourSharedTapDrawPot;

  /// Hint under the draw when revealing everything at once.
  ///
  /// In en, this message translates to:
  /// **'Tap to reveal the whole draw'**
  String get tourSharedTapDrawAll;

  /// Button that closes the draw ceremony once it's complete.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tourSharedContinue;

  /// Button that pauses the auto-playing draw.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get tourSharedPause;

  /// Button that resumes the auto-playing draw.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get tourSharedPlay;

  /// Button that reveals the entire draw at once.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSharedSkip;

  /// A numbered draw pot, e.g. "POT 1".
  ///
  /// In en, this message translates to:
  /// **'POT {number}'**
  String tourSharedPotNumber(int number);

  /// Centre-stage label shown when the draw is finished.
  ///
  /// In en, this message translates to:
  /// **'DRAW COMPLETE'**
  String get tourSharedDrawComplete;

  /// Centre-stage label shown between draws.
  ///
  /// In en, this message translates to:
  /// **'DRAWING…'**
  String get tourSharedDrawing;

  /// Continental championship screen title.
  ///
  /// In en, this message translates to:
  /// **'CHAMPIONSHIP'**
  String get tourContChampionship;

  /// Tab label: summary.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get tourContTabSummary;

  /// Tab label: qualifying.
  ///
  /// In en, this message translates to:
  /// **'QUALIFYING'**
  String get tourContTabQualifying;

  /// Tab label: finals tournament.
  ///
  /// In en, this message translates to:
  /// **'FINALS'**
  String get tourContTabFinals;

  /// Tab label: knockout bracket.
  ///
  /// In en, this message translates to:
  /// **'BRACKET'**
  String get tourContTabBracket;

  /// Tab label: awards.
  ///
  /// In en, this message translates to:
  /// **'AWARDS'**
  String get tourContTabAwards;

  /// Tab label: scorers.
  ///
  /// In en, this message translates to:
  /// **'SCORERS'**
  String get tourContTabScorers;

  /// Tab label: history.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get tourContTabHistory;

  /// Tab label: records.
  ///
  /// In en, this message translates to:
  /// **'RECORDS'**
  String get tourContTabRecords;

  /// Error state when the cup fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load cup.\n{error}'**
  String tourContCouldNotLoadCup(String error);

  /// Shown when there is no cup data.
  ///
  /// In en, this message translates to:
  /// **'No cup data.'**
  String get tourContNoCupData;

  /// Fallback for an unknown value.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get tourContUnknown;

  /// Shown before the qualifying groups are drawn.
  ///
  /// In en, this message translates to:
  /// **'The qualifying groups are drawn at the ceremony. Watch from the hub to see who you face.'**
  String get tourContGroupsToBeDrawnQual;

  /// Shown when the nation is seeded straight into the finals.
  ///
  /// In en, this message translates to:
  /// **'Your nation is seeded straight into the finals. No qualifying this cycle.'**
  String get tourContQualSeeded;

  /// Explains a region is simulated in the background.
  ///
  /// In en, this message translates to:
  /// **'{name} is simulated in the background. Results appear here as each round is played.'**
  String tourContBackgroundRegion(String name);

  /// Shown before the finals groups are drawn.
  ///
  /// In en, this message translates to:
  /// **'The finals groups are drawn at the ceremony. Watch from the hub to see your group.'**
  String get tourContGroupsToBeDrawnFinals;

  /// Shown when the finals draw awaits qualifying completion.
  ///
  /// In en, this message translates to:
  /// **'The finals draw takes place once qualifying is complete.'**
  String get tourContFinalsDrawAfterQual;

  /// Explains the knockout rounds precede the World Cup.
  ///
  /// In en, this message translates to:
  /// **'The knockout rounds are played out before the World Cup.'**
  String get tourContContestedBeforeWc;

  /// Heading naming a tournament's champions.
  ///
  /// In en, this message translates to:
  /// **'{name} CHAMPIONS'**
  String tourContChampionsHeading(String name);

  /// Winners list title for a tournament.
  ///
  /// In en, this message translates to:
  /// **'{name} winners'**
  String tourContWinnersTitle(String name);

  /// Empty state for scorers.
  ///
  /// In en, this message translates to:
  /// **'No goals scored yet.'**
  String get tourContNoGoalsYet;

  /// Group heading with its letter.
  ///
  /// In en, this message translates to:
  /// **'GROUP {name}'**
  String tourContGroupHeading(String name);

  /// Heading for the best runners-up table.
  ///
  /// In en, this message translates to:
  /// **'BEST RUNNERS-UP'**
  String get tourContBestRunnersUp;

  /// Group option in a dropdown.
  ///
  /// In en, this message translates to:
  /// **'Group {name}'**
  String tourContGroupDropdown(String name);

  /// Heading above a matches list.
  ///
  /// In en, this message translates to:
  /// **'MATCHES'**
  String get tourContMatches;

  /// Empty state when no groups are drawn.
  ///
  /// In en, this message translates to:
  /// **'No groups drawn yet.'**
  String get tourContNoGroupsDrawn;

  /// Qualifying draw screen title.
  ///
  /// In en, this message translates to:
  /// **'QUALIFYING DRAW'**
  String get tourContQualifyingDraw;

  /// Group draw screen title.
  ///
  /// In en, this message translates to:
  /// **'GROUP DRAW'**
  String get tourContGroupDraw;

  /// Error state when the draw fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load draw.\n{error}'**
  String tourContCouldNotLoadDraw(String error);

  /// Shown when the draw is not ready.
  ///
  /// In en, this message translates to:
  /// **'The draw is not ready yet.'**
  String get tourContDrawNotReady;

  /// Continental Clash screen title.
  ///
  /// In en, this message translates to:
  /// **'CONTINENTAL CLASH'**
  String get tourContContinentalClash;

  /// Tab label: this cycle.
  ///
  /// In en, this message translates to:
  /// **'THIS CYCLE'**
  String get tourContTabThisCycle;

  /// Error state when the clash fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String tourContCouldNotLoadClash(String error);

  /// Shown when the save can't be found.
  ///
  /// In en, this message translates to:
  /// **'Save not found.'**
  String get tourContNoSaveFound;

  /// Explains when the Continental Clash is played.
  ///
  /// In en, this message translates to:
  /// **'The Continental Clash is played once both continental champions are known.'**
  String get tourContClashSoon;

  /// Continental Clash tagline.
  ///
  /// In en, this message translates to:
  /// **'TWO CONTINENTS, ONE MATCH'**
  String get tourContTwoContinentsOneMatch;

  /// Short versus separator.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get tourContVersusShort;

  /// Line naming the Continental Clash winner.
  ///
  /// In en, this message translates to:
  /// **'{name} win the Clash'**
  String tourContWinTheClash(String name);

  /// Empty state when no clash has been played.
  ///
  /// In en, this message translates to:
  /// **'No Continental Clash played yet.'**
  String get tourContNoClashYet;

  /// Nations Cup screen title.
  ///
  /// In en, this message translates to:
  /// **'NATIONS CUP'**
  String get tourContNationsCup;

  /// Tab label: leagues.
  ///
  /// In en, this message translates to:
  /// **'LEAGUES'**
  String get tourContTabLeagues;

  /// Tab label: finals four.
  ///
  /// In en, this message translates to:
  /// **'FINALS FOUR'**
  String get tourContTabFinalsFour;

  /// Generic load-error message.
  ///
  /// In en, this message translates to:
  /// **'Could not load.\n{error}'**
  String tourContCouldNotLoad(String error);

  /// Empty state for Nations Cup scorers.
  ///
  /// In en, this message translates to:
  /// **'No Nations Cup goals recorded yet.'**
  String get tourContNoNationsCupGoals;

  /// Empty state for Nations Cup champions.
  ///
  /// In en, this message translates to:
  /// **'No Nations Cup champions crowned yet.'**
  String get tourContNoNationsCupChampions;

  /// Shown when the Nations Cup is off-season.
  ///
  /// In en, this message translates to:
  /// **'This cycle’s Nations Cup begins after the continental finals. Past winners are under History.'**
  String get tourContNationsCupOffSeason;

  /// Shown before the Nations Cup groups are drawn.
  ///
  /// In en, this message translates to:
  /// **'This cycle’s Nations Cup groups are drawn at the ceremony. Watch from the hub to see who you face.'**
  String get tourContNationsCupGroupsSoon;

  /// League heading with its letter.
  ///
  /// In en, this message translates to:
  /// **'LEAGUE {letter}'**
  String tourContLeagueHeading(String letter);

  /// League heading marking the manager's league.
  ///
  /// In en, this message translates to:
  /// **'LEAGUE {letter} · YOUR LEAGUE'**
  String tourContLeagueHeadingYours(String letter);

  /// Explains when the Finals Four is contested.
  ///
  /// In en, this message translates to:
  /// **'The Finals Four is contested by League A’s group winners once the group stage is done.'**
  String get tourContFinalsFourSoon;

  /// League chip with its letter.
  ///
  /// In en, this message translates to:
  /// **'League {letter}'**
  String tourContLeagueChip(String letter);

  /// League chip marking the manager's league with a star.
  ///
  /// In en, this message translates to:
  /// **'League {letter} ★'**
  String tourContLeagueChipStar(String letter);

  /// Heading: semi-finals.
  ///
  /// In en, this message translates to:
  /// **'SEMI-FINALS'**
  String get tourContSemiFinals;

  /// Heading: final.
  ///
  /// In en, this message translates to:
  /// **'FINAL'**
  String get tourContFinal;

  /// Nations Cup draw screen title.
  ///
  /// In en, this message translates to:
  /// **'NATIONS CUP DRAW'**
  String get tourContNationsCupDraw;

  /// Intercontinental play-off screen title.
  ///
  /// In en, this message translates to:
  /// **'INTERCONTINENTAL PLAY-OFF'**
  String get tourContIntercontinentalPlayoff;

  /// Shown when there is no play-off this cycle.
  ///
  /// In en, this message translates to:
  /// **'No play-off this cycle.'**
  String get tourContNoPlayoffThisCycle;

  /// Intro explaining the intercontinental play-off.
  ///
  /// In en, this message translates to:
  /// **'Two World Cup places decided across a knockout of the best qualifying also-rans.'**
  String get tourContPlayoffIntro;

  /// Shown when the manager wins the play-off.
  ///
  /// In en, this message translates to:
  /// **'You came through the play-off — you\'re at the World Cup!'**
  String get tourContPlayoffThrough;

  /// Shown when the manager loses the play-off.
  ///
  /// In en, this message translates to:
  /// **'You fell short in the play-off — no World Cup this time.'**
  String get tourContPlayoffOut;

  /// Button to continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get tourContContinue;

  /// Heading: play-off finals.
  ///
  /// In en, this message translates to:
  /// **'PLAY-OFF FINALS'**
  String get tourContPlayoffFinals;

  /// Tag on the two top-ranked play-off teams that skip the semi-finals and enter a path final directly.
  ///
  /// In en, this message translates to:
  /// **'Seeded — bye'**
  String get tourContPlayoffSeeded;

  /// World Cup detail: tourCupTabSummary
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get tourCupTabSummary;

  /// World Cup detail: tourCupTabQualifying
  ///
  /// In en, this message translates to:
  /// **'QUALIFYING'**
  String get tourCupTabQualifying;

  /// World Cup detail tab: the intercontinental play-off.
  ///
  /// In en, this message translates to:
  /// **'PLAY-OFF'**
  String get tourCupTabPlayoff;

  /// Shown on the play-off tab before qualifying finishes.
  ///
  /// In en, this message translates to:
  /// **'The intercontinental play-off is decided once every confederation\'s qualifying is complete.'**
  String get tourCupPlayoffSoon;

  /// World Cup detail: tourCupTabFinals
  ///
  /// In en, this message translates to:
  /// **'FINALS'**
  String get tourCupTabFinals;

  /// World Cup detail: tourCupTabBracket
  ///
  /// In en, this message translates to:
  /// **'BRACKET'**
  String get tourCupTabBracket;

  /// World Cup detail: tourCupTabAwards
  ///
  /// In en, this message translates to:
  /// **'AWARDS'**
  String get tourCupTabAwards;

  /// World Cup detail: tourCupTabScorers
  ///
  /// In en, this message translates to:
  /// **'SCORERS'**
  String get tourCupTabScorers;

  /// World Cup detail: tourCupTabHistory
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get tourCupTabHistory;

  /// World Cup detail: tourCupTabRecords
  ///
  /// In en, this message translates to:
  /// **'RECORDS'**
  String get tourCupTabRecords;

  /// World Cup detail: tourCupTitle
  ///
  /// In en, this message translates to:
  /// **'WORLD CHAMPIONSHIP'**
  String get tourCupTitle;

  /// World Cup detail: tourCupNoData
  ///
  /// In en, this message translates to:
  /// **'No cup data.'**
  String get tourCupNoData;

  /// World Cup detail: tourCupLoadError
  ///
  /// In en, this message translates to:
  /// **'Could not load cup.\n{error}'**
  String tourCupLoadError(String error);

  /// World Cup detail: tourCupUnknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get tourCupUnknown;

  /// World Cup detail: tourCupWorldChampions
  ///
  /// In en, this message translates to:
  /// **'WORLD CHAMPIONS'**
  String get tourCupWorldChampions;

  /// World Cup detail: tourCupWorldChampionsTitle
  ///
  /// In en, this message translates to:
  /// **'World Champions'**
  String get tourCupWorldChampionsTitle;

  /// World Cup detail: tourCupActive
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get tourCupActive;

  /// World Cup detail: tourCupStillActive
  ///
  /// In en, this message translates to:
  /// **'Still active'**
  String get tourCupStillActive;

  /// World Cup detail: tourCupAllTimeScorers
  ///
  /// In en, this message translates to:
  /// **'ALL-TIME SCORERS'**
  String get tourCupAllTimeScorers;

  /// World Cup detail: tourCupAllConfederations
  ///
  /// In en, this message translates to:
  /// **'All confederations'**
  String get tourCupAllConfederations;

  /// World Cup detail: tourCupBestRunnersUp
  ///
  /// In en, this message translates to:
  /// **'Best runners-up'**
  String get tourCupBestRunnersUp;

  /// World Cup detail: tourCupCompWorld
  ///
  /// In en, this message translates to:
  /// **'World Cup'**
  String get tourCupCompWorld;

  /// World Cup detail: tourCupCompEurope
  ///
  /// In en, this message translates to:
  /// **'European Championship'**
  String get tourCupCompEurope;

  /// World Cup detail: tourCupCompSAmerica
  ///
  /// In en, this message translates to:
  /// **'South America Cup'**
  String get tourCupCompSAmerica;

  /// World Cup detail: tourCupDestFinals
  ///
  /// In en, this message translates to:
  /// **'the finals'**
  String get tourCupDestFinals;

  /// World Cup detail: tourCupDestFinalsPlayoff
  ///
  /// In en, this message translates to:
  /// **'the finals play-off'**
  String get tourCupDestFinalsPlayoff;

  /// World Cup detail: tourCupDestIntercontPlayoff
  ///
  /// In en, this message translates to:
  /// **'the intercontinental play-off'**
  String get tourCupDestIntercontPlayoff;

  /// World Cup detail: tourCupFinalsDrawnAfterQual
  ///
  /// In en, this message translates to:
  /// **'The finals are drawn once qualifying ends.'**
  String get tourCupFinalsDrawnAfterQual;

  /// World Cup detail: tourCupFinalsDrawSoon
  ///
  /// In en, this message translates to:
  /// **'Groups to be drawn — watch the World Cup draw from the hub to reveal them.'**
  String get tourCupFinalsDrawSoon;

  /// World Cup detail: tourCupGroupName
  ///
  /// In en, this message translates to:
  /// **'Group {name}'**
  String tourCupGroupName(String name);

  /// World Cup detail: tourCupGroupNameShort
  ///
  /// In en, this message translates to:
  /// **'Group {name}'**
  String tourCupGroupNameShort(String name);

  /// World Cup detail: tourCupHostLabel
  ///
  /// In en, this message translates to:
  /// **'Hosted by {host}'**
  String tourCupHostLabel(String host);

  /// World Cup detail: tourCupIntercontPlayoff
  ///
  /// In en, this message translates to:
  /// **'Intercontinental play-off'**
  String get tourCupIntercontPlayoff;

  /// World Cup detail: tourCupKnockoutSoon
  ///
  /// In en, this message translates to:
  /// **'The bracket begins once the group stage ends.'**
  String get tourCupKnockoutSoon;

  /// World Cup detail: tourCupMatches
  ///
  /// In en, this message translates to:
  /// **'MATCHES'**
  String get tourCupMatches;

  /// World Cup detail: tourCupMedalTable
  ///
  /// In en, this message translates to:
  /// **'MEDAL TABLE'**
  String get tourCupMedalTable;

  /// World Cup detail: tourCupMostTitles
  ///
  /// In en, this message translates to:
  /// **'MOST TITLES'**
  String get tourCupMostTitles;

  /// World Cup detail: tourCupMostTitlesValue
  ///
  /// In en, this message translates to:
  /// **'{nation} — {titles} titles from {editions} editions'**
  String tourCupMostTitlesValue(String nation, int titles, int editions);

  /// World Cup detail: tourCupNoGoals
  ///
  /// In en, this message translates to:
  /// **'No goals yet.'**
  String get tourCupNoGoals;

  /// World Cup detail: tourCupNoGroups
  ///
  /// In en, this message translates to:
  /// **'No groups drawn.'**
  String get tourCupNoGroups;

  /// World Cup detail: tourCupNoHistory
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get tourCupNoHistory;

  /// World Cup detail: tourCupPastWinners
  ///
  /// In en, this message translates to:
  /// **'PAST WINNERS'**
  String get tourCupPastWinners;

  /// World Cup detail: tourCupPlayoffIntro
  ///
  /// In en, this message translates to:
  /// **'Two World Cup places decided across a knockout of the best qualifying also-rans.'**
  String get tourCupPlayoffIntro;

  /// World Cup detail: tourCupQualDrawSoon
  ///
  /// In en, this message translates to:
  /// **'Groups to be drawn — watch the qualifying draw from the hub to reveal them.'**
  String get tourCupQualDrawSoon;

  /// World Cup detail: tourCupRegionYours
  ///
  /// In en, this message translates to:
  /// **'{region} · yours'**
  String tourCupRegionYours(String region);

  /// World Cup detail: tourCupScorePens
  ///
  /// In en, this message translates to:
  /// **'{home}–{away} (pens)'**
  String tourCupScorePens(int home, int away);

  /// World Cup detail: tourCupSegAllTime
  ///
  /// In en, this message translates to:
  /// **'All-time'**
  String get tourCupSegAllTime;

  /// World Cup detail: tourCupSegFinals
  ///
  /// In en, this message translates to:
  /// **'Finals'**
  String get tourCupSegFinals;

  /// World Cup detail: tourCupSegQualifying
  ///
  /// In en, this message translates to:
  /// **'Qualifying'**
  String get tourCupSegQualifying;

  /// What this player is known for — the traits card heading.
  ///
  /// In en, this message translates to:
  /// **'KNOWN FOR'**
  String get playerTraitsTitle;

  /// Trait name: rises for knockout ties.
  ///
  /// In en, this message translates to:
  /// **'Big-game player'**
  String get traitBigGame;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Raises his game in knockout ties.'**
  String get traitBigGameBlurb;

  /// Trait name: dead-ball delivery.
  ///
  /// In en, this message translates to:
  /// **'Set-piece specialist'**
  String get traitSetPiece;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Better delivery — more goals from dead balls.'**
  String get traitSetPieceBlurb;

  /// Trait name: card-prone.
  ///
  /// In en, this message translates to:
  /// **'Hothead'**
  String get traitHothead;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Picks up far more cards than his team-mates.'**
  String get traitHotheadBlurb;

  /// Trait name: durable.
  ///
  /// In en, this message translates to:
  /// **'Iron man'**
  String get traitIronMan;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Rarely gets hurt and tires more slowly.'**
  String get traitIronManBlurb;

  /// Trait name: young and improving.
  ///
  /// In en, this message translates to:
  /// **'Wonderkid'**
  String get traitWonderkid;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Young, already good, and still improving fast.'**
  String get traitWonderkidBlurb;

  /// Trait name: captain material.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get traitLeader;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Lifts every team-mate on the pitch.'**
  String get traitLeaderBlurb;

  /// Trait name: quick.
  ///
  /// In en, this message translates to:
  /// **'Pacey'**
  String get traitPacey;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Blistering pace — a threat in behind.'**
  String get traitPaceyBlurb;

  /// Trait name: veteran.
  ///
  /// In en, this message translates to:
  /// **'Old head'**
  String get traitOldHead;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'A veteran whose reading of the game outlasts his legs.'**
  String get traitOldHeadBlurb;

  /// Trait name: poor finisher.
  ///
  /// In en, this message translates to:
  /// **'Wasteful'**
  String get traitWasteful;

  /// Trait effect.
  ///
  /// In en, this message translates to:
  /// **'Puts too many good chances wide.'**
  String get traitWastefulBlurb;

  /// The World Cup, named as a competition in a board objective.
  ///
  /// In en, this message translates to:
  /// **'World Cup'**
  String get objectiveWorldCup;

  /// Board objective for the strongest sides: win the tournament. Generic, because the board now sets one for the continental cup as well as the World Cup.
  ///
  /// In en, this message translates to:
  /// **'Win it'**
  String get objectiveWinTournament;

  /// Board objective at its lowest bar: just reach the tournament.
  ///
  /// In en, this message translates to:
  /// **'Qualify'**
  String get objectiveQualifyGeneric;

  /// Board objective line naming the competition it applies to.
  ///
  /// In en, this message translates to:
  /// **'{competition}: {label}'**
  String hubBoardObjectiveFor(String competition, String label);

  /// Shared label: objectiveWinWorldCup
  ///
  /// In en, this message translates to:
  /// **'Win the World Cup'**
  String get objectiveWinWorldCup;

  /// Board objective: reach the final. Generic — the board sets one for the continental cup as well as the World Cup, so it must not name a competition.
  ///
  /// In en, this message translates to:
  /// **'Reach the final'**
  String get objectiveReachFinal;

  /// Shared label: objectiveReachSemis
  ///
  /// In en, this message translates to:
  /// **'Reach the semi-finals'**
  String get objectiveReachSemis;

  /// Shared label: objectiveReachQuarters
  ///
  /// In en, this message translates to:
  /// **'Reach the quarter-finals'**
  String get objectiveReachQuarters;

  /// Shared label: objectiveReachKnockouts
  ///
  /// In en, this message translates to:
  /// **'Reach the knockout rounds'**
  String get objectiveReachKnockouts;

  /// Shared label: objectiveQualify
  ///
  /// In en, this message translates to:
  /// **'Qualify for the World Cup'**
  String get objectiveQualify;

  /// Shared label: finishChampions
  ///
  /// In en, this message translates to:
  /// **'Champions'**
  String get finishChampions;

  /// Shared label: finishRunnersUp
  ///
  /// In en, this message translates to:
  /// **'Runners-up'**
  String get finishRunnersUp;

  /// Shared label: finishSemiFinals
  ///
  /// In en, this message translates to:
  /// **'Semi-finals'**
  String get finishSemiFinals;

  /// Shared label: finishQuarterFinals
  ///
  /// In en, this message translates to:
  /// **'Quarter-finals'**
  String get finishQuarterFinals;

  /// Shared label: finishRoundOf16
  ///
  /// In en, this message translates to:
  /// **'Round of 16'**
  String get finishRoundOf16;

  /// Shared label: finishGroupStage
  ///
  /// In en, this message translates to:
  /// **'Group stage'**
  String get finishGroupStage;

  /// Shared label: finishDidNotQualify
  ///
  /// In en, this message translates to:
  /// **'Did not qualify'**
  String get finishDidNotQualify;

  /// The board's lowest bar, for a nation with no realistic route to the finals: come out of the qualifying group off the bottom.
  ///
  /// In en, this message translates to:
  /// **'Avoid finishing bottom in qualifying'**
  String get objectiveAvoidBottom;

  /// Objective result: the nation finished last in its qualifying group.
  ///
  /// In en, this message translates to:
  /// **'Bottom of the qualifying group'**
  String get finishBottomOfQualifyingGroup;

  /// Nations Cup board objective: lift the trophy.
  ///
  /// In en, this message translates to:
  /// **'Win the Nations Cup'**
  String get objectiveNcWinIt;

  /// Nations Cup board objective: reach the final.
  ///
  /// In en, this message translates to:
  /// **'Reach the Nations Cup final'**
  String get objectiveNcReachFinal;

  /// Nations Cup board objective: win your League A group and reach the Finals Four.
  ///
  /// In en, this message translates to:
  /// **'Reach the Finals Four'**
  String get objectiveNcFinalsFour;

  /// Nations Cup board objective: win the league group and earn promotion.
  ///
  /// In en, this message translates to:
  /// **'Win your group and go up'**
  String get objectiveNcWinGroup;

  /// Nations Cup board objective: a mid-table league finish.
  ///
  /// In en, this message translates to:
  /// **'Finish in the top half of your group'**
  String get objectiveNcTopHalf;

  /// Nations Cup board objective: stay in this league.
  ///
  /// In en, this message translates to:
  /// **'Avoid relegation'**
  String get objectiveNcSurvive;

  /// Nations Cup objective result: won the competition.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup winners'**
  String get finishNcChampions;

  /// Nations Cup objective result: reached the Finals Four.
  ///
  /// In en, this message translates to:
  /// **'Finals Four'**
  String get finishNcFinalsFour;

  /// Nations Cup objective result: topped the league group.
  ///
  /// In en, this message translates to:
  /// **'Group winners'**
  String get finishNcGroupWinners;

  /// Nations Cup objective result: a mid-table league finish.
  ///
  /// In en, this message translates to:
  /// **'Top half of the group'**
  String get finishNcTopHalf;

  /// Nations Cup objective result: clear of the relegation place.
  ///
  /// In en, this message translates to:
  /// **'Stayed up'**
  String get finishNcStayedUp;

  /// Nations Cup objective result: finished last in the league group.
  ///
  /// In en, this message translates to:
  /// **'Bottom of the group'**
  String get finishNcBottom;

  /// Career-history label for the Nations Cup finish.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup'**
  String get careerNationsCupLabel;

  /// Squad-report table header: the player's name.
  ///
  /// In en, this message translates to:
  /// **'PLAYER'**
  String get squadDevPlayer;

  /// Squad-report table header: the player's age.
  ///
  /// In en, this message translates to:
  /// **'AGE'**
  String get squadDevAge;

  /// Squad-report table header: the player's position.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get squadDevPosition;

  /// Squad-report table header: rating and its change over the year.
  ///
  /// In en, this message translates to:
  /// **'RATING'**
  String get squadDevChange;

  /// Tag on a player in the pool for the first time.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get squadDevNew;

  /// Tag on a player who has left the international pool.
  ///
  /// In en, this message translates to:
  /// **'RETIRED'**
  String get squadDevRetired;

  /// Shown when the yearly squad report has no rows.
  ///
  /// In en, this message translates to:
  /// **'A settled year. No changes across the squad.'**
  String get squadDevEmpty;

  /// Title of the board-objectives screen, and the hub button opening it.
  ///
  /// In en, this message translates to:
  /// **'Board objectives'**
  String get boardObjectivesTitle;

  /// Label above the board-confidence verdict.
  ///
  /// In en, this message translates to:
  /// **'Board confidence'**
  String get boardObjectivesConfidence;

  /// A settled objective the nation beat, and by how many rounds.
  ///
  /// In en, this message translates to:
  /// **'{result} — {rounds, plural, =1{a round better than asked} other{{rounds} rounds better than asked}}'**
  String boardObjectiveBeatenBy(String result, int rounds);

  /// A settled objective the nation missed, and by how many rounds.
  ///
  /// In en, this message translates to:
  /// **'{result} — {rounds, plural, =1{a round short} other{{rounds} rounds short}}'**
  String boardObjectiveShortBy(String result, int rounds);

  /// Status of an objective whose tournament has not finished.
  ///
  /// In en, this message translates to:
  /// **'STILL TO BE DECIDED'**
  String get boardObjectivesPending;

  /// How far the nation has got in a tournament that is still being played, shown against a board objective that cannot be graded yet.
  ///
  /// In en, this message translates to:
  /// **'SO FAR · {result}'**
  String boardObjectiveSoFar(String result);

  /// Shown when there are no objectives.
  ///
  /// In en, this message translates to:
  /// **'The board has not set an objective for this cycle.'**
  String get boardObjectivesEmpty;

  /// Ladder card heading when the contested place is first — fewer berths than groups.
  ///
  /// In en, this message translates to:
  /// **'BEST GROUP WINNERS'**
  String get tourContBestWinners;

  /// Ladder card heading for the best third-placed sides.
  ///
  /// In en, this message translates to:
  /// **'BEST THIRD-PLACED'**
  String get tourContBestThirds;

  /// Ladder card heading for a contested position deeper than third.
  ///
  /// In en, this message translates to:
  /// **'BEST {position}TH-PLACED'**
  String tourContBestPlaced(String position);

  /// Pager line under the squad-report table.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages} · {total} players'**
  String squadDevPageOf(String page, String pages, String total);

  /// Tag on the ground card when the stadium is full.
  ///
  /// In en, this message translates to:
  /// **'SOLD OUT'**
  String get matchSoldOut;

  /// Crowd figure against stadium capacity.
  ///
  /// In en, this message translates to:
  /// **'{attendance} of {capacity} seats filled'**
  String matchAttendanceOf(String attendance, String capacity);

  /// Heading over the match venue on the pre-match screen.
  ///
  /// In en, this message translates to:
  /// **'VENUE'**
  String get matchGroundTitle;

  /// Absence badge: the player has a knock.
  ///
  /// In en, this message translates to:
  /// **'Injured'**
  String get absenceInjured;

  /// Absence badge: the player is serving a ban.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get absenceSuspended;

  /// How long a player is out for, in weeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week} other{{count} weeks}}'**
  String absenceWeeks(num count);

  /// How long a player is out for, in matches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 game} other{{count} games}}'**
  String absenceGames(num count);

  /// The first match the player is available again for.
  ///
  /// In en, this message translates to:
  /// **'Back for {opponent}'**
  String absenceBackFor(String opponent);

  /// Title of the sheet naming shootout takers.
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get penaltyOrderTitle;

  /// Explains the shootout order sheet.
  ///
  /// In en, this message translates to:
  /// **'Name your five takers, in order. Tap a slot to change it.'**
  String get penaltyOrderBlurb;

  /// Header when choosing who takes a given kick.
  ///
  /// In en, this message translates to:
  /// **'Kick {number}'**
  String penaltyOrderPick(int number);

  /// Explains the taker picker.
  ///
  /// In en, this message translates to:
  /// **'Pick who steps up. The bar is their composure from the spot.'**
  String get penaltyOrderPickBlurb;

  /// Confirms the shootout order and starts the kicks.
  ///
  /// In en, this message translates to:
  /// **'Take them'**
  String get penaltyOrderConfirm;

  /// Returns from the taker picker to the order.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get penaltyOrderCancel;

  /// Title of the youth pyramid screen.
  ///
  /// In en, this message translates to:
  /// **'Youth'**
  String get youthTitle;

  /// Shown when a youth level has no players and nobody left it.
  ///
  /// In en, this message translates to:
  /// **'Nobody at this level yet.'**
  String get youthEmptyLevel;

  /// Heading above the boys let go from a level this year.
  ///
  /// In en, this message translates to:
  /// **'Released this year'**
  String get youthReleased;

  /// Title of the youth watchlist screen.
  ///
  /// In en, this message translates to:
  /// **'Under-21s'**
  String get u21Title;

  /// Explains the watchlist and its star ratings.
  ///
  /// In en, this message translates to:
  /// **'The next generation, best prospect first. Hollow stars are a scout\'s estimate — cap a player to find out what he really has.'**
  String get u21Blurb;

  /// Shown when there are no under-21s.
  ///
  /// In en, this message translates to:
  /// **'Nobody under 21 in the pool right now. The next intake arrives with the new cycle.'**
  String get u21Empty;

  /// Tag on a young player who has improved sharply.
  ///
  /// In en, this message translates to:
  /// **'+{gain} THIS YEAR'**
  String u21Breakout(int gain);

  /// Age and international caps of a prospect.
  ///
  /// In en, this message translates to:
  /// **'Age {age} · {caps} caps'**
  String u21AgeCaps(int age, int caps);

  /// Age of a prospect who has never played.
  ///
  /// In en, this message translates to:
  /// **'Age {age} · uncapped'**
  String u21AgeUncapped(int age);

  /// Button from the watchlist to the squad-selection screen.
  ///
  /// In en, this message translates to:
  /// **'Go to call-ups'**
  String get u21CallUps;

  /// Tooltip on the squad screen's youth-watchlist action.
  ///
  /// In en, this message translates to:
  /// **'Under-21s'**
  String get tacticsYouth;

  /// Title of the press-question sheet.
  ///
  /// In en, this message translates to:
  /// **'Press conference'**
  String get pressTitle;

  /// Hub card inviting the manager to answer a press question.
  ///
  /// In en, this message translates to:
  /// **'The press are waiting'**
  String get pressCardTitle;

  /// Hub card subtitle.
  ///
  /// In en, this message translates to:
  /// **'One question. What you say moves the dressing room and the board.'**
  String get pressCardSub;

  /// Fallback when the opponent is unknown.
  ///
  /// In en, this message translates to:
  /// **'the opposition'**
  String get pressTheOpposition;

  /// Label on the dressing-room swing of a press answer.
  ///
  /// In en, this message translates to:
  /// **'Squad'**
  String get pressSquad;

  /// Label on the board swing of a press answer.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get pressBoard;

  /// Shown on an answer that moves nothing.
  ///
  /// In en, this message translates to:
  /// **'Nobody reads much into it'**
  String get pressNoEffect;

  /// Press question after a heavy defeat.
  ///
  /// In en, this message translates to:
  /// **'That was a chastening night against {opponent}. What went wrong?'**
  String pressAskHeavyDefeat(String opponent);

  /// Press question after a knockout exit.
  ///
  /// In en, this message translates to:
  /// **'Beaten by {opponent}, and the tournament is over. How do you explain it?'**
  String pressAskElimination(String opponent);

  /// Press question during a bad run.
  ///
  /// In en, this message translates to:
  /// **'Three games without a win, and the board are watching. Are you still the right man?'**
  String get pressAskUnderPressure;

  /// Press question before a finals.
  ///
  /// In en, this message translates to:
  /// **'The tournament starts here. How far does this squad go?'**
  String get pressAskPreview;

  /// Press question after winning a trophy.
  ///
  /// In en, this message translates to:
  /// **'Champions. Where does this rank, and what comes next?'**
  String get pressAskTriumph;

  /// Press answer: back the squad.
  ///
  /// In en, this message translates to:
  /// **'These players gave me everything. I would not swap a single one of them.'**
  String get pressAnswerBackPlayers;

  /// Press answer: take the blame.
  ///
  /// In en, this message translates to:
  /// **'That one is on me. I picked the side and I set them up.'**
  String get pressAnswerTakeBlame;

  /// Press answer: demand more.
  ///
  /// In en, this message translates to:
  /// **'Not good enough. Some of them have to look at themselves.'**
  String get pressAnswerDemandMore;

  /// Press answer: raise the target.
  ///
  /// In en, this message translates to:
  /// **'We are here to win it. Anything less is a failure.'**
  String get pressAnswerRaiseBar;

  /// Press answer: say nothing.
  ///
  /// In en, this message translates to:
  /// **'We take it one game at a time. Nothing more to add.'**
  String get pressAnswerPlayDown;

  /// Tag on the ground card when a tie is played on neutral territory.
  ///
  /// In en, this message translates to:
  /// **'NEUTRAL'**
  String get matchNeutralGround;

  /// Heading of the interval before extra time begins.
  ///
  /// In en, this message translates to:
  /// **'EXTRA TIME'**
  String get matchExtraTimeAhead;

  /// Heading of the interval midway through extra time.
  ///
  /// In en, this message translates to:
  /// **'EXTRA TIME · HALF TIME'**
  String get matchExtraTimeHalf;

  /// Timeline action: the opening press conference of a tournament.
  ///
  /// In en, this message translates to:
  /// **'Face the press'**
  String get hubEventPressConference;

  /// Subtitle of the opening press conference action.
  ///
  /// In en, this message translates to:
  /// **'The world’s media want a word before your first match'**
  String get hubEventPressConferenceSub;

  /// Press question at a tournament's opening conference.
  ///
  /// In en, this message translates to:
  /// **'The tournament is open and you start against {opponent}. What are you telling the country?'**
  String pressAskOpening(String opponent);

  /// Tag on a newly emerged player the scouts rate very highly.
  ///
  /// In en, this message translates to:
  /// **'WONDERKID'**
  String get squadDevWonderkid;

  /// Heading for the general playing style selector.
  ///
  /// In en, this message translates to:
  /// **'Playing style'**
  String get tacticsPlaystyle;

  /// Blurb under the playing style selector.
  ///
  /// In en, this message translates to:
  /// **'Pick how the side plays; the dials below fine-tune it.'**
  String get tacticsPlaystyleBlurb;

  /// Shown when the instructions match no named style.
  ///
  /// In en, this message translates to:
  /// **'Your own settings — no named style matches these dials.'**
  String get tacticsPlaystyleCustom;

  /// Playing style: hand-set dials.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get playstyleCustom;

  /// Playing style: nothing overdone.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get playstyleBalanced;

  /// Playing style: keep the ball.
  ///
  /// In en, this message translates to:
  /// **'Possession'**
  String get playstylePossession;

  /// Playing style: press high and hard.
  ///
  /// In en, this message translates to:
  /// **'Gegenpress'**
  String get playstyleGegenpress;

  /// Playing style: sit off and break.
  ///
  /// In en, this message translates to:
  /// **'Counter-attack'**
  String get playstyleCounter;

  /// Playing style: get it forward early.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get playstyleDirect;

  /// Playing style: deep and compact.
  ///
  /// In en, this message translates to:
  /// **'Low block'**
  String get playstyleLowBlock;

  /// Playing style: stretch it and cross.
  ///
  /// In en, this message translates to:
  /// **'Wing play'**
  String get playstyleWingPlay;

  /// Playing style blurb: balanced.
  ///
  /// In en, this message translates to:
  /// **'Solid in both halves, with nothing overdone.'**
  String get playstyleBalancedBlurb;

  /// Playing style blurb: possession.
  ///
  /// In en, this message translates to:
  /// **'Keep the ball, move it patiently, squeeze the pitch.'**
  String get playstylePossessionBlurb;

  /// Playing style blurb: gegenpress.
  ///
  /// In en, this message translates to:
  /// **'Win it back the second it is lost, high up the pitch.'**
  String get playstyleGegenpressBlurb;

  /// Playing style blurb: counter.
  ///
  /// In en, this message translates to:
  /// **'Sit off, stay compact, then break at speed.'**
  String get playstyleCounterBlurb;

  /// Playing style blurb: direct.
  ///
  /// In en, this message translates to:
  /// **'Forward early and play for the second ball.'**
  String get playstyleDirectBlurb;

  /// Playing style blurb: low block.
  ///
  /// In en, this message translates to:
  /// **'Deep, narrow and very hard to break down.'**
  String get playstyleLowBlockBlurb;

  /// Playing style blurb: wing play.
  ///
  /// In en, this message translates to:
  /// **'Stretch the pitch, get round the outside and cross.'**
  String get playstyleWingPlayBlurb;

  /// Nation-select action: let the game pick which country you manage.
  ///
  /// In en, this message translates to:
  /// **'Random team'**
  String get nationsRandomTeam;

  /// Nation-select action: start unemployed and take an offer from one of the world's weakest sides.
  ///
  /// In en, this message translates to:
  /// **'From the bottom'**
  String get nationsFromTheBottom;

  /// Title of the unemployed-start screen.
  ///
  /// In en, this message translates to:
  /// **'Out of work'**
  String get bottomStartTitle;

  /// Heading on the unemployed-start screen.
  ///
  /// In en, this message translates to:
  /// **'Three federations want to talk'**
  String get bottomStartHeading;

  /// Blurb explaining the from-the-bottom start.
  ///
  /// In en, this message translates to:
  /// **'You have no job and no reputation. These are the only sides willing to take a chance on you — take one and build something from nothing.'**
  String get bottomStartBlurb;

  /// Button on an offer card: accept this job.
  ///
  /// In en, this message translates to:
  /// **'Take it'**
  String get bottomStartAccept;

  /// Button that leaves the offers without taking a job.
  ///
  /// In en, this message translates to:
  /// **'Back to menu'**
  String get bottomStartBack;

  /// Where an offering nation sits in the world ranking.
  ///
  /// In en, this message translates to:
  /// **'{rank} of {total} in the world'**
  String bottomStartRankOf(int rank, int total);

  /// Title of the training camp selection screen.
  ///
  /// In en, this message translates to:
  /// **'Base camp'**
  String get campTitle;

  /// Heading naming the host country the camp is in.
  ///
  /// In en, this message translates to:
  /// **'Based in {host}'**
  String campBasedIn(String host);

  /// Blurb on the base camp screen.
  ///
  /// In en, this message translates to:
  /// **'Where the squad lives for the whole tournament. It cannot be changed once play starts, and it works on three things every match: how fresh they arrive, how fast a knock heals, and how sharp they are.'**
  String get campBlurb;

  /// Camp effect chip: travel wear on the squad.
  ///
  /// In en, this message translates to:
  /// **'Arrive fresh'**
  String get campEffectTravel;

  /// Camp effect chip: how fast injuries clear.
  ///
  /// In en, this message translates to:
  /// **'Injuries heal'**
  String get campEffectRecovery;

  /// Camp effect chip: flat condition lift.
  ///
  /// In en, this message translates to:
  /// **'Match sharpness'**
  String get campEffectSharpness;

  /// Camp terrain: in the host's biggest city.
  ///
  /// In en, this message translates to:
  /// **'City centre'**
  String get campTerrainCity;

  /// Camp terrain: by the sea.
  ///
  /// In en, this message translates to:
  /// **'Coastal resort'**
  String get campTerrainCoastal;

  /// Camp terrain: up in the hills.
  ///
  /// In en, this message translates to:
  /// **'Mountain retreat'**
  String get campTerrainMountain;

  /// Camp terrain: high above sea level.
  ///
  /// In en, this message translates to:
  /// **'Altitude camp'**
  String get campTerrainAltitude;

  /// Camp terrain: a purpose-built training centre.
  ///
  /// In en, this message translates to:
  /// **'National centre'**
  String get campTerrainNationalCentre;

  /// Camp terrain blurb: city centre.
  ///
  /// In en, this message translates to:
  /// **'Everything on the doorstep and nothing to travel to — but no peace, and no escape from the noise.'**
  String get campTerrainCityBlurb;

  /// Camp terrain blurb: coastal.
  ///
  /// In en, this message translates to:
  /// **'Calm, comfortable and good for the mood; a long coach ride to every ground.'**
  String get campTerrainCoastalBlurb;

  /// Camp terrain blurb: mountain.
  ///
  /// In en, this message translates to:
  /// **'Cool air and a first-rate medical set-up that turns knocks round quickly, a long way from the tournament.'**
  String get campTerrainMountainBlurb;

  /// Camp terrain blurb: altitude.
  ///
  /// In en, this message translates to:
  /// **'Hard work to train in, and legs that last deep into the tournament.'**
  String get campTerrainAltitudeBlurb;

  /// Camp terrain blurb: national centre.
  ///
  /// In en, this message translates to:
  /// **'The federation\'s own facilities: nothing spectacular, nothing to go wrong.'**
  String get campTerrainNationalCentreBlurb;

  /// Timeline action: pick the squad's tournament base.
  ///
  /// In en, this message translates to:
  /// **'Choose the base camp'**
  String get hubEventChooseCamp;

  /// Subtitle of the base camp action.
  ///
  /// In en, this message translates to:
  /// **'Where the squad will be based in {host}'**
  String hubEventChooseCampSub(String host);

  /// Tab: the named squad outside the starting XI.
  ///
  /// In en, this message translates to:
  /// **'Bench'**
  String get tacticsTabBench;

  /// Placeholder in the squad pool search field.
  ///
  /// In en, this message translates to:
  /// **'Search by name or club'**
  String get squadSearchHint;

  /// Squad filter: the whole pool.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get squadFilterAll;

  /// Squad filter: only called-up players.
  ///
  /// In en, this message translates to:
  /// **'In the squad'**
  String get squadFilterInSquad;

  /// Squad filter: players yet to win a cap.
  ///
  /// In en, this message translates to:
  /// **'Uncapped'**
  String get squadFilterUncapped;

  /// Squad filter: injured or suspended players.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get squadFilterUnavailable;

  /// Position filter: no line selected.
  ///
  /// In en, this message translates to:
  /// **'All lines'**
  String get squadLineAll;

  /// Label before the squad sort options.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get squadSortBy;

  /// Squad sort: by overall rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get squadSortRating;

  /// Squad sort: by international appearances.
  ///
  /// In en, this message translates to:
  /// **'Caps'**
  String get squadSortCaps;

  /// Squad sort: by international goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get squadSortGoals;

  /// Squad sort: youngest first.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get squadSortAge;

  /// Squad sort: alphabetical.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get squadSortName;

  /// Count of the filtered squad list.
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total} players'**
  String squadShowingOf(int shown, int total);

  /// Empty state for the filtered squad list.
  ///
  /// In en, this message translates to:
  /// **'Nobody in the pool matches those filters.'**
  String get squadNobodyMatches;

  /// Squad stat: how many players are eligible.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get squadStatPool;

  /// Squad stat: how many are in the current squad.
  ///
  /// In en, this message translates to:
  /// **'Called up'**
  String get squadStatInSquad;

  /// Label for the pool's most-capped player.
  ///
  /// In en, this message translates to:
  /// **'Most capped'**
  String get squadMostCapped;

  /// Label for the pool's leading scorer.
  ///
  /// In en, this message translates to:
  /// **'Top scorer'**
  String get squadTopScorer;

  /// Most-capped player and their tally.
  ///
  /// In en, this message translates to:
  /// **'{name} · {caps} caps'**
  String squadCapsValue(String name, int caps);

  /// Leading scorer and their tally.
  ///
  /// In en, this message translates to:
  /// **'{name} · {goals} goals'**
  String squadGoalsValue(String name, int goals);

  /// A squad row's age and club line.
  ///
  /// In en, this message translates to:
  /// **'{age} · {club}'**
  String squadAgeClub(int age, String club);

  /// Column heading: international appearances.
  ///
  /// In en, this message translates to:
  /// **'Caps'**
  String get squadCapsShort;

  /// Column heading: international goals.
  ///
  /// In en, this message translates to:
  /// **'Gls'**
  String get squadGoalsShort;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Four goals conceded against {opponent}. Where does a night like that leave you?'**
  String pressAskHeavyDefeat2(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} took you apart. Is this squad good enough?'**
  String pressAskHeavyDefeat3(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} end it. Four years of work, gone in ninety minutes — talk us through it.'**
  String pressAskElimination2(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Out to {opponent}. Was that as far as this team was ever going?'**
  String pressAskElimination3(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The results have dried up and your name is in every column. Worried?'**
  String get pressAskUnderPressure2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'No wins, no goals, no answers. What do you say to the supporters?'**
  String get pressAskUnderPressure3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Everyone wants a prediction. Give us yours.'**
  String get pressAskPreview2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Realistically — group stage, quarters, or more than that?'**
  String get pressAskPreview3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The whole country is watching and {opponent} are first up. Your message?'**
  String pressAskOpening2(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'It starts against {opponent}. How do you want this side to be remembered?'**
  String pressAskOpening3(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You\'ve won it. Does it feel like the end of something, or the start?'**
  String get pressAskTriumph2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Champions at last. Who does this one belong to?'**
  String get pressAskTriumph3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Three clear against {opponent}. Is this side finally clicking?'**
  String pressAskBigWin(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You took {opponent} apart. How good was that?'**
  String pressAskBigWin2(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A statement result against {opponent}. Should the rest of them be worried?'**
  String pressAskBigWin3(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You\'re through. What does qualifying mean to this group?'**
  String get pressAskQualified;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The place is booked. Job done, or is the job just starting?'**
  String get pressAskQualified2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Qualification secured — now what is this squad actually capable of?'**
  String get pressAskQualified3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'No tournament this time. How did it come to this?'**
  String get pressAskMissedOut;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Watching it on television. What do you say to a country that expected better?'**
  String get pressAskMissedOut3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The campaign is over and you\'re not in it. Who is accountable?'**
  String get pressAskMissedOut2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Unbeaten for months now. How long can this go on?'**
  String get pressAskUnbeaten;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Nobody has laid a glove on you all season. What\'s behind the run?'**
  String get pressAskUnbeaten2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The run keeps going. Is this the best side you\'ve had?'**
  String get pressAskUnbeaten3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Day one. What are you promising this country?'**
  String get pressAskNewJob;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'New job, new squad. What changes first?'**
  String get pressAskNewJob2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You\'ve taken the job. Why this one, and why now?'**
  String get pressAskNewJob3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A record world ranking. Does the table flatter this team?'**
  String get pressAskRankingPeak;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Never been ranked this high. Is this side genuinely among the best?'**
  String get pressAskRankingPeak2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Top of the pile on paper. Does that put a target on your back?'**
  String get pressAskRankingPeak3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Nobody works harder than this group. I\'ll defend them all day.'**
  String get pressAnswerBackPlayers2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You won\'t hear a word against my players from this seat.'**
  String get pressAnswerBackPlayers3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Judge me, not them. It\'s my team and my responsibility.'**
  String get pressAnswerTakeBlame2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'If you want somebody to blame, I\'m sitting right here.'**
  String get pressAnswerTakeBlame3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Standards slipped. Some of them know exactly what I mean.'**
  String get pressAnswerDemandMore2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Effort isn\'t enough at this level. I want more, and I\'ve told them so.'**
  String get pressAnswerDemandMore3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'No hiding from it — we expect to lift the trophy.'**
  String get pressAnswerRaiseBar2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Second place is not what this country sent us here for.'**
  String get pressAnswerRaiseBar3;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I\'m not going to make headlines for you today.'**
  String get pressAnswerPlayDown2;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Next game. That\'s all I\'m thinking about.'**
  String get pressAnswerPlayDown3;

  /// Records/legacy label.
  ///
  /// In en, this message translates to:
  /// **'Caps, goals and the team\'s headline records'**
  String get recordsRecordBookSubtitle;

  /// Records/legacy label.
  ///
  /// In en, this message translates to:
  /// **'LEGACY'**
  String get statsLegacy;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'That was hard to watch. Did {opponent} simply want it more?'**
  String pressAskHeavyDefeat4(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You were second to everything against {opponent}. Fitness or attitude?'**
  String pressAskHeavyDefeat5(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} scored at will. Who is responsible for that defence?'**
  String pressAskHeavyDefeat6(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A result like that against {opponent} follows a manager around. How do you come back from it?'**
  String pressAskHeavyDefeat7(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You were booed off after {opponent}. Do you blame them?'**
  String pressAskHeavyDefeat8(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} knocked you out. When did you know it had gone?'**
  String pressAskElimination4(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Another tournament, another early flight home, and {opponent} did it. Why?'**
  String pressAskElimination5(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Out to {opponent}. Is this squad short of quality or short of nerve?'**
  String pressAskElimination6(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} are through and you are not. What do you say in that dressing room?'**
  String pressAskElimination7(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Beaten by {opponent} when it mattered. Does that define your time here?'**
  String pressAskElimination8(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The bookmakers have you favourite to go. Does that reach you?'**
  String get pressAskUnderPressure4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Your predecessor was sacked on a run like this. What makes you different?'**
  String get pressAskUnderPressure5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The board have said nothing publicly. Is silence support?'**
  String get pressAskUnderPressure6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Every phone-in wants a new manager. Have you lost the country?'**
  String get pressAskUnderPressure7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'How many more games do you think you have?'**
  String get pressAskUnderPressure8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Who is the team to beat, and are you in that conversation?'**
  String get pressAskPreview4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Nobody outside this room fancies you. Does that suit you?'**
  String get pressAskPreview5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'What would make this a successful tournament — honestly?'**
  String get pressAskPreview6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Your group looks kind. Is anything less than qualification unacceptable?'**
  String get pressAskPreview7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'This is the youngest squad you have taken to a finals. Gamble or plan?'**
  String get pressAskPreview8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'First game, {opponent}, and everyone is nervous. How do you settle a side?'**
  String pressAskOpening4(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You have waited two years for this. Does the plan change now {opponent} are in front of you?'**
  String pressAskOpening5(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} to open. Win it and the whole tournament looks different — do you tell them that?'**
  String pressAskOpening6(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The country has stopped for this. Is {opponent} a good draw or a bad one?'**
  String pressAskOpening7(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Opening night against {opponent}. What is the one thing you cannot allow?'**
  String pressAskOpening8(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You have made history. Has it landed yet?'**
  String get pressAskTriumph4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The trophy is in the room. Who did you think of first?'**
  String get pressAskTriumph5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A generation will remember this side. What should they remember about it?'**
  String get pressAskTriumph6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You were written off in this very room. Enjoying the moment?'**
  String get pressAskTriumph7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Is this the peak, or can this team win more?'**
  String get pressAskTriumph8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} had no answer to that. The plan or the players?'**
  String pressAskBigWin4(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The best performance of your reign — and against {opponent}?'**
  String pressAskBigWin5(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You could have had more against {opponent}. Do you ask for ruthlessness or take the win?'**
  String pressAskBigWin6(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A scoreline like that against {opponent} raises expectations. Comfortable with that?'**
  String pressAskBigWin7(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'{opponent} never laid a glove on you. Is this side finally what you wanted?'**
  String pressAskBigWin8(String opponent);

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Job done. Was it ever in doubt?'**
  String get pressAskQualified4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You are through. Does the campaign tell you how far you can go?'**
  String get pressAskQualified5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A place at the finals — relief or satisfaction?'**
  String get pressAskQualified6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You qualified with games to spare. What are the rest of them for?'**
  String get pressAskQualified7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Now the hard part. Is this squad ready for a tournament?'**
  String get pressAskQualified8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'No tournament this time. A squad problem or a coaching one?'**
  String get pressAskMissedOut4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Two years of work and nothing to show. Do you still believe in this group?'**
  String get pressAskMissedOut5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The country will not see its team at a finals. What do you owe them?'**
  String get pressAskMissedOut6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Was there one night that cost you?'**
  String get pressAskMissedOut7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Do you expect to still be in this job next season?'**
  String get pressAskMissedOut8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Nobody has beaten you in a year. Are you thinking about records?'**
  String get pressAskUnbeaten4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The run is the story now. Is it a burden yet?'**
  String get pressAskUnbeaten5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Sides set up not to lose to you. Does that make it harder?'**
  String get pressAskUnbeaten6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'When it ends — and it will — how do you want it to end?'**
  String get pressAskUnbeaten7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Unbeaten, but how many of those were convincing?'**
  String get pressAskUnbeaten8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You inherit a squad in transition. Where do you start?'**
  String get pressAskNewJob4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'What does this team look like in two years?'**
  String get pressAskNewJob5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You turned down other offers for this one. Why?'**
  String get pressAskNewJob6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Some of these players were not picked by you. Does anyone start with a clean slate?'**
  String get pressAskNewJob7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'What has this country been getting wrong?'**
  String get pressAskNewJob8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Top of the pile on paper. Does a ranking mean anything to you?'**
  String get pressAskRankingPeak4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The highest this nation has ever been. Whose achievement is that?'**
  String get pressAskRankingPeak5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You are ranked above sides with far more history. Fair?'**
  String get pressAskRankingPeak6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'The numbers say you are among the best. Do the trophies?'**
  String get pressAskRankingPeak7;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'A record ranking and no trophy yet. Does that sit uneasily?'**
  String get pressAskRankingPeak8;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I\'ll take the questions. They\'ll take the credit — that\'s how it works here.'**
  String get pressAnswerBackPlayers4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'This group has never let me down. Not once.'**
  String get pressAnswerBackPlayers5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'They\'re hurting more than anyone. I\'m not adding to it.'**
  String get pressAnswerBackPlayers6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'That\'s on the staff and it\'s on me. Nobody else.'**
  String get pressAnswerTakeBlame4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I picked it, I set it up, I got it wrong.'**
  String get pressAnswerTakeBlame5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Point it at me. That\'s what I\'m paid for.'**
  String get pressAnswerTakeBlame6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Some of them are a long way short of what this shirt asks.'**
  String get pressAnswerDemandMore4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I\'ve told them privately and I\'ll say it here: it isn\'t good enough.'**
  String get pressAnswerDemandMore5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Places are open. Everyone in that dressing room knows it.'**
  String get pressAnswerDemandMore6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'We came here to win it. I\'m not going to pretend otherwise.'**
  String get pressAnswerRaiseBar4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Anything but the trophy and we\'ll have wasted this.'**
  String get pressAnswerRaiseBar5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I\'d rather be judged on winning than praised for trying.'**
  String get pressAnswerRaiseBar6;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'I\'ll keep my thoughts in the dressing room.'**
  String get pressAnswerPlayDown4;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'You\'ve seen the game. Your read is as good as mine.'**
  String get pressAnswerPlayDown5;

  /// Press conference line.
  ///
  /// In en, this message translates to:
  /// **'Nothing I say tonight changes the result.'**
  String get pressAnswerPlayDown6;

  /// Snackbar when the manager tries to re-use a substituted player.
  ///
  /// In en, this message translates to:
  /// **'{name} has already been taken off — he cannot come back on.'**
  String tacticsSubAlreadyOff(String name);

  /// Snackbar when the manager tries to bring on a sent-off player.
  ///
  /// In en, this message translates to:
  /// **'{name} has been sent off and takes no further part.'**
  String tacticsSubSentOff(String name);

  /// Pitch-node flag under an injured player's disc. Kept to one word so it fits inside the node's width.
  ///
  /// In en, this message translates to:
  /// **'INJURED'**
  String get tacticsInjuredShort;

  /// Pitch-node flag under a suspended player's disc.
  ///
  /// In en, this message translates to:
  /// **'SUSPENDED'**
  String get tacticsSuspendedShort;

  /// Continent name.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get confEurope;

  /// Continent name.
  ///
  /// In en, this message translates to:
  /// **'South America'**
  String get confSouthAmerica;

  /// Continent name (North & Central America and the Caribbean).
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get confNorthAmerica;

  /// Continent name.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get confAfrica;

  /// Continent name.
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get confAsia;

  /// Continent name.
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get confOceania;

  /// Competition name shown to the manager. The stored name stays English.
  ///
  /// In en, this message translates to:
  /// **'World Cup'**
  String get compWorldCup;

  /// Competition name: the World Cup finals tournament.
  ///
  /// In en, this message translates to:
  /// **'World Cup Finals'**
  String get compWorldCupFinals;

  /// Competition name: World Cup qualifying, region unspecified.
  ///
  /// In en, this message translates to:
  /// **'World Cup Qualifying'**
  String get compWorldCupQualifying;

  /// Competition name: one continent's World Cup qualifying campaign.
  ///
  /// In en, this message translates to:
  /// **'{region} Qualifiers'**
  String compQualifiers(String region);

  /// Competition name for the friendly-match container.
  ///
  /// In en, this message translates to:
  /// **'Friendlies'**
  String get compFriendlies;

  /// Competition name.
  ///
  /// In en, this message translates to:
  /// **'Nations Cup'**
  String get compNationsCup;

  /// Competition name: the champions-of-champions one-off.
  ///
  /// In en, this message translates to:
  /// **'Continental Clash'**
  String get compContinentalClash;

  /// Competition name.
  ///
  /// In en, this message translates to:
  /// **'Intercontinental Play-off'**
  String get compIntercontinentalPlayoff;

  /// Generic name for a continental cup when the confederation is not known.
  ///
  /// In en, this message translates to:
  /// **'Continental Championship'**
  String get compContinentalChampionship;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'European Championship'**
  String get compEuropeanChampionship;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'South America Cup'**
  String get compSouthAmericaCup;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'African Championship'**
  String get compAfricanChampionship;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'Asian Championship'**
  String get compAsianChampionship;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'North America Cup'**
  String get compNorthAmericaCup;

  /// Continental cup name.
  ///
  /// In en, this message translates to:
  /// **'Oceania Cup'**
  String get compOceaniaCup;

  /// Inbox fallback when a nation cannot be named.
  ///
  /// In en, this message translates to:
  /// **'A nation'**
  String get msgANation;

  /// Inbox fallback when a player cannot be named.
  ///
  /// In en, this message translates to:
  /// **'A player'**
  String get msgAPlayer;

  /// Inbox fallback when the host of a continental cup is not known yet.
  ///
  /// In en, this message translates to:
  /// **'a host nation'**
  String get msgAHostNation;

  /// Inbox: cycle-start headline, one of four.
  ///
  /// In en, this message translates to:
  /// **'A new cycle begins'**
  String get msgCycleTitle1;

  /// Inbox: cycle-start headline, one of four.
  ///
  /// In en, this message translates to:
  /// **'The road to {year} opens'**
  String msgCycleTitle2(int year);

  /// Inbox: cycle-start headline, one of four.
  ///
  /// In en, this message translates to:
  /// **'A fresh campaign dawns'**
  String get msgCycleTitle3;

  /// Inbox: cycle-start headline, one of four.
  ///
  /// In en, this message translates to:
  /// **'Back to work'**
  String get msgCycleTitle4;

  /// Inbox: cycle-start body, one of four.
  ///
  /// In en, this message translates to:
  /// **'The road to the {year} World Cup starts here.'**
  String msgCycleBody1(int year);

  /// Inbox: cycle-start body, one of four.
  ///
  /// In en, this message translates to:
  /// **'A new cycle. The {year} World Cup is the target.'**
  String msgCycleBody2(int year);

  /// Inbox: cycle-start body, one of four.
  ///
  /// In en, this message translates to:
  /// **'Four years to the {year} World Cup. Work starts now.'**
  String msgCycleBody3(int year);

  /// Inbox: cycle-start body, one of four.
  ///
  /// In en, this message translates to:
  /// **'The {year} campaign begins today.'**
  String msgCycleBody4(int year);

  /// Inbox: continental cup host chosen.
  ///
  /// In en, this message translates to:
  /// **'{cup} host: {host}'**
  String msgContHostTitle(String cup, String host);

  /// Inbox: continental cup host chosen, body.
  ///
  /// In en, this message translates to:
  /// **'{host} will host the next {cup}.'**
  String msgContHostBody(String host, String cup);

  /// Inbox: continental qualifying draw made.
  ///
  /// In en, this message translates to:
  /// **'{cup} qualifying draw'**
  String msgContQualDrawTitle(String cup);

  /// Inbox: continental qualifying draw made, body.
  ///
  /// In en, this message translates to:
  /// **'The {cup} qualifying groups have been drawn.'**
  String msgContQualDrawBody(String cup);

  /// Inbox: World Cup host chosen.
  ///
  /// In en, this message translates to:
  /// **'{year} World Cup host: {host}'**
  String msgWcHostTitle(String host, int year);

  /// Inbox: World Cup host chosen, body.
  ///
  /// In en, this message translates to:
  /// **'{host} will host the {year} World Cup.'**
  String msgWcHostBody(String host, int year);

  /// Inbox: World Cup qualifying draw made.
  ///
  /// In en, this message translates to:
  /// **'World Cup qualifying draw'**
  String get msgWcQualDrawTitle;

  /// Inbox: World Cup qualifying draw made, body.
  ///
  /// In en, this message translates to:
  /// **'The World Cup qualifying groups have been drawn.'**
  String get msgWcQualDrawBody;

  /// Inbox: continental finals draw made.
  ///
  /// In en, this message translates to:
  /// **'{cup} finals draw'**
  String msgContFinalsDrawTitle(String cup);

  /// Inbox: continental finals draw made, body.
  ///
  /// In en, this message translates to:
  /// **'The {cup} finals groups have been drawn.'**
  String msgContFinalsDrawBody(String cup);

  /// Inbox: World Cup finals draw made.
  ///
  /// In en, this message translates to:
  /// **'World Cup finals draw'**
  String get msgWcFinalsDrawTitle;

  /// Inbox: World Cup finals draw made, body.
  ///
  /// In en, this message translates to:
  /// **'The {year} World Cup finals draw has been made.'**
  String msgWcFinalsDrawBody(int year);

  /// Inbox: qualified for the World Cup, headline.
  ///
  /// In en, this message translates to:
  /// **'Through to the World Cup'**
  String get msgQualWcTitle1;

  /// Inbox: qualified for the World Cup, headline.
  ///
  /// In en, this message translates to:
  /// **'World Cup booked'**
  String get msgQualWcTitle2;

  /// Inbox: qualified for the World Cup, headline.
  ///
  /// In en, this message translates to:
  /// **'We\'re going to the World Cup'**
  String get msgQualWcTitle3;

  /// Inbox: qualified for the World Cup, headline.
  ///
  /// In en, this message translates to:
  /// **'Ticket punched'**
  String get msgQualWcTitle4;

  /// Inbox: qualified for the World Cup, body.
  ///
  /// In en, this message translates to:
  /// **'You have qualified for the {year} World Cup finals.'**
  String msgQualWcBody1(int year);

  /// Inbox: qualified for the World Cup, body.
  ///
  /// In en, this message translates to:
  /// **'It\'s official: your nation is at the {year} World Cup.'**
  String msgQualWcBody2(int year);

  /// Inbox: qualified for the World Cup, body.
  ///
  /// In en, this message translates to:
  /// **'A place at the {year} World Cup is secured.'**
  String msgQualWcBody3(int year);

  /// Inbox: qualified for the World Cup, body.
  ///
  /// In en, this message translates to:
  /// **'You\'re through to the {year} World Cup finals.'**
  String msgQualWcBody4(int year);

  /// Inbox: qualified for the continental cup, headline.
  ///
  /// In en, this message translates to:
  /// **'Through to {cup}'**
  String msgQualContTitle1(String cup);

  /// Inbox: qualified for the continental cup, headline.
  ///
  /// In en, this message translates to:
  /// **'{cup} booked'**
  String msgQualContTitle2(String cup);

  /// Inbox: qualified for the continental cup, headline.
  ///
  /// In en, this message translates to:
  /// **'Qualified for {cup}'**
  String msgQualContTitle3(String cup);

  /// Inbox: qualified for the continental cup, body.
  ///
  /// In en, this message translates to:
  /// **'You have qualified for the {cup} finals.'**
  String msgQualContBody1(String cup);

  /// Inbox: qualified for the continental cup, body.
  ///
  /// In en, this message translates to:
  /// **'Your nation has sealed its place at {cup}.'**
  String msgQualContBody2(String cup);

  /// Inbox: qualified for the continental cup, body.
  ///
  /// In en, this message translates to:
  /// **'You\'re through to {cup}.'**
  String msgQualContBody3(String cup);

  /// Inbox: the manager's nation won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'{comp} CHAMPIONS!'**
  String msgChampTitleMine1(String comp);

  /// Inbox: the manager's nation won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'Champions of the {comp}!'**
  String msgChampTitleMine2(String comp);

  /// Inbox: the manager's nation won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'You\'ve won the {comp}!'**
  String msgChampTitleMine3(String comp);

  /// Inbox: somebody else won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'{comp} decided'**
  String msgChampTitleOther1(String comp);

  /// Inbox: somebody else won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'{comp} champions crowned'**
  String msgChampTitleOther2(String comp);

  /// Inbox: somebody else won a cup, headline.
  ///
  /// In en, this message translates to:
  /// **'The {comp} is won'**
  String msgChampTitleOther3(String comp);

  /// Inbox: the manager's nation won a cup, body.
  ///
  /// In en, this message translates to:
  /// **'Your nation are the {year} {comp} champions, beating {loser}{result}.'**
  String msgChampBodyMine1(String comp, String loser, String result, int year);

  /// Inbox: the manager's nation won a cup, body.
  ///
  /// In en, this message translates to:
  /// **'You\'ve won the {year} {comp}, seeing off {loser}{result}.'**
  String msgChampBodyMine2(String comp, String loser, String result, int year);

  /// Inbox: the manager's nation won a cup, body.
  ///
  /// In en, this message translates to:
  /// **'The {year} {comp} is yours. {loser} beaten{result}.'**
  String msgChampBodyMine3(String comp, String loser, String result, int year);

  /// Inbox: somebody else won a cup, body.
  ///
  /// In en, this message translates to:
  /// **'{winner} won the {year} {comp}, beating {loser}{result}.'**
  String msgChampBodyOther1(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  );

  /// Inbox: somebody else won a cup, body.
  ///
  /// In en, this message translates to:
  /// **'{winner} are the {year} {comp} champions, defeating {loser}{result}.'**
  String msgChampBodyOther2(
    String winner,
    String comp,
    String loser,
    String result,
    int year,
  );

  /// Inbox: the final's scoreline, appended to a champions message.
  ///
  /// In en, this message translates to:
  /// **' {home}–{away} in the final'**
  String msgFinalScoreSuffix(int home, int away);

  /// Inbox: a final settled on penalties, appended to a champions message.
  ///
  /// In en, this message translates to:
  /// **' on penalties, after a {home}–{away} final'**
  String msgFinalPensSuffix(int home, int away);

  /// Inbox: award headline.
  ///
  /// In en, this message translates to:
  /// **'World Player of the Year'**
  String get msgWpotyTitle;

  /// Inbox: award body, the manager's own player.
  ///
  /// In en, this message translates to:
  /// **'{name} ({nation}) is named {year} World Player of the Year, one of yours.'**
  String msgWpotyBodyMine(String name, String nation, int year);

  /// Inbox: award body.
  ///
  /// In en, this message translates to:
  /// **'{name} ({nation}) is named {year} World Player of the Year.'**
  String msgWpotyBodyOther(String name, String nation, int year);

  /// Inbox: award headline.
  ///
  /// In en, this message translates to:
  /// **'Young Player of the Tournament'**
  String get msgYpotTitle;

  /// Inbox: award body, the manager's own player.
  ///
  /// In en, this message translates to:
  /// **'{name} ({nation}), aged {age}, is named {year} Young Player of the Tournament, one of yours.'**
  String msgYpotBodyMine(String name, String nation, int age, int year);

  /// Inbox: award body.
  ///
  /// In en, this message translates to:
  /// **'{name} ({nation}), aged {age}, is named {year} Young Player of the Tournament.'**
  String msgYpotBodyOther(String name, String nation, int age, int year);

  /// Inbox: world ranking unchanged.
  ///
  /// In en, this message translates to:
  /// **'You hold at #{rank}.'**
  String msgRankHold1(int rank);

  /// Inbox: world ranking unchanged.
  ///
  /// In en, this message translates to:
  /// **'No change, still #{rank}.'**
  String msgRankHold2(int rank);

  /// Inbox: world ranking unchanged.
  ///
  /// In en, this message translates to:
  /// **'Steady at #{rank}.'**
  String msgRankHold3(int rank);

  /// Inbox: world ranking climbed.
  ///
  /// In en, this message translates to:
  /// **'Up {move, plural, one{1 place} other{{move} places}} this cycle, to #{rank}.'**
  String msgRankUp1(int move, int rank);

  /// Inbox: world ranking climbed.
  ///
  /// In en, this message translates to:
  /// **'A climb of {move, plural, one{1 place} other{{move} places}} lifts you to #{rank}.'**
  String msgRankUp2(int move, int rank);

  /// Inbox: world ranking climbed.
  ///
  /// In en, this message translates to:
  /// **'Up {move, plural, one{1 place} other{{move} places}}, now #{rank}.'**
  String msgRankUp3(int move, int rank);

  /// Inbox: world ranking slipped.
  ///
  /// In en, this message translates to:
  /// **'Down {move, plural, one{1 place} other{{move} places}} this cycle, to #{rank}.'**
  String msgRankDown1(int move, int rank);

  /// Inbox: world ranking slipped.
  ///
  /// In en, this message translates to:
  /// **'A slide of {move, plural, one{1 place} other{{move} places}} drops you to #{rank}.'**
  String msgRankDown2(int move, int rank);

  /// Inbox: world ranking slipped.
  ///
  /// In en, this message translates to:
  /// **'Down {move, plural, one{1 place} other{{move} places}}, now #{rank}.'**
  String msgRankDown3(int move, int rank);

  /// Inbox: the manager's nation is world number one.
  ///
  /// In en, this message translates to:
  /// **'You top the world.'**
  String get msgRankLeadYou;

  /// Inbox: who leads the world ranking.
  ///
  /// In en, this message translates to:
  /// **'{nation} top the world.'**
  String msgRankLeadOther(String nation);

  /// Inbox: ranking release headline.
  ///
  /// In en, this message translates to:
  /// **'World ranking · #{rank}'**
  String msgRankTitle(int rank);

  /// Inbox: ranking release body.
  ///
  /// In en, this message translates to:
  /// **'The world ranking has been updated. {lead} {movement}'**
  String msgRankBody(String lead, String movement);

  /// Inbox: caps milestone headline.
  ///
  /// In en, this message translates to:
  /// **'{name} reaches {count} caps'**
  String msgCapsTitle(String name, int count);

  /// Inbox: caps milestone body.
  ///
  /// In en, this message translates to:
  /// **'{name} has now made {count} appearances for your nation.'**
  String msgCapsBody(String name, int count);

  /// Inbox: goals milestone headline.
  ///
  /// In en, this message translates to:
  /// **'{name} reaches {count} goals'**
  String msgGoalsTitle(String name, int count);

  /// Inbox: goals milestone body.
  ///
  /// In en, this message translates to:
  /// **'{name} has scored {count} international goals for your nation.'**
  String msgGoalsBody(String name, int count);

  /// Inbox: yearly squad development report headline.
  ///
  /// In en, this message translates to:
  /// **'Squad development · {year}'**
  String msgDevTitle(int year);

  /// Inbox: the boys who have come up through the youth pyramid into the senior pool.
  ///
  /// In en, this message translates to:
  /// **'Through from the academy · {year}'**
  String msgThroughTitle(int year);

  /// Line above the academy-graduates table, distinguishing it from the yearly intake.
  ///
  /// In en, this message translates to:
  /// **'These are not a new intake — they are the boys who came in at eleven and have now grown into the senior pool.'**
  String get msgThroughNote;

  /// Inbox: yearly newcomers report headline.
  ///
  /// In en, this message translates to:
  /// **'New faces · {year}'**
  String msgNewFacesTitle(int year);

  /// Inbox: yearly youth intake headline.
  ///
  /// In en, this message translates to:
  /// **'Academy intake · {year}'**
  String msgIntakeTitle(int year);

  /// Inbox: the captain retires.
  ///
  /// In en, this message translates to:
  /// **'Your captain {name} retires'**
  String msgRetireCaptainTitle(String name);

  /// Inbox: a notable player retires.
  ///
  /// In en, this message translates to:
  /// **'{name} retires from internationals'**
  String msgRetireTitle(String name);

  /// Inbox: retirement body.
  ///
  /// In en, this message translates to:
  /// **'{name} has retired from international football at {age}.'**
  String msgRetireBody(String name, int age);

  /// Inbox: retirement body with a career tally.
  ///
  /// In en, this message translates to:
  /// **'{name} has retired from international football at {age}, bowing out with {tally}.'**
  String msgRetireBodyWith(String name, String tally, int age);

  /// Inbox: caps part of a retirement tally.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 cap} other{{count} caps}}'**
  String msgTallyCaps(int count);

  /// Inbox: goals part of a retirement tally.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 goal} other{{count} goals}}'**
  String msgTallyGoals(int count);

  /// Inbox: appended when the retiree was captain.
  ///
  /// In en, this message translates to:
  /// **' The armband is vacant — name a new captain from the call-up screen.'**
  String get msgArmbandVacant;

  /// Inbox: hall-of-fame headline.
  ///
  /// In en, this message translates to:
  /// **'{name} inducted into the Hall of Fame'**
  String msgHofTitle(String name);

  /// Inbox: hall-of-fame body.
  ///
  /// In en, this message translates to:
  /// **'{name} joins your nation’s Hall of Fame ({caps} caps, {goals} goals). See them in Legends.'**
  String msgHofBody(String name, int caps, int goals);

  /// Inbox: a player is banned after a sending-off.
  ///
  /// In en, this message translates to:
  /// **'{name} suspended'**
  String hubBanTitle(String name);

  /// Inbox: suspension body. {how} is one of the hubBanHow* strings.
  ///
  /// In en, this message translates to:
  /// **'{name} {how} and is banned for {matches, plural, one{your next match} other{the next {matches} matches}} — they will be unavailable for selection.'**
  String hubBanBody(String name, String how, int matches);

  /// Inbox: how a player was sent off.
  ///
  /// In en, this message translates to:
  /// **'was sent off for a second booking'**
  String get hubBanHowSecondYellow;

  /// Inbox: how a player was sent off.
  ///
  /// In en, this message translates to:
  /// **'was shown a straight red for violent conduct'**
  String get hubBanHowViolent;

  /// Inbox: how a player was sent off.
  ///
  /// In en, this message translates to:
  /// **'was sent off'**
  String get hubBanHowRed;

  /// Inbox: a player picked up a knock.
  ///
  /// In en, this message translates to:
  /// **'{name} injured'**
  String hubInjuryTitle(String name);

  /// Inbox: injury body.
  ///
  /// In en, this message translates to:
  /// **'{name} picked up a knock and is out for {matches, plural, one{1 match} other{{matches} matches}}.'**
  String hubInjuryBody(String name, int matches);

  /// Inbox: lost a final, headline.
  ///
  /// In en, this message translates to:
  /// **'Runners-up'**
  String get hubRunnerUpTitle1;

  /// Inbox: lost a final, headline.
  ///
  /// In en, this message translates to:
  /// **'So near, yet so far'**
  String get hubRunnerUpTitle2;

  /// Inbox: lost a final, headline.
  ///
  /// In en, this message translates to:
  /// **'Silver medals'**
  String get hubRunnerUpTitle3;

  /// Inbox: lost a final, body.
  ///
  /// In en, this message translates to:
  /// **'You reached the {cup} final but lost to {opponent}. So close — silver this time.'**
  String hubRunnerUpBody1(String cup, String opponent);

  /// Inbox: lost a final, body.
  ///
  /// In en, this message translates to:
  /// **'Beaten by {opponent} in the {cup} final. Runners-up — agonisingly close.'**
  String hubRunnerUpBody2(String cup, String opponent);

  /// Inbox: lost a final, body.
  ///
  /// In en, this message translates to:
  /// **'The {cup} final slipped away against {opponent}. So much to be proud of, but not the trophy.'**
  String hubRunnerUpBody3(String cup, String opponent);

  /// Inbox: knocked out of a tournament, headline.
  ///
  /// In en, this message translates to:
  /// **'Knocked out'**
  String get hubKnockedOutTitle1;

  /// Inbox: knocked out of a tournament, headline.
  ///
  /// In en, this message translates to:
  /// **'The end of the road'**
  String get hubKnockedOutTitle2;

  /// Inbox: knocked out of a tournament, headline.
  ///
  /// In en, this message translates to:
  /// **'Journey over'**
  String get hubKnockedOutTitle3;

  /// Inbox: knocked out of a tournament, body.
  ///
  /// In en, this message translates to:
  /// **'You\'re out of the {cup}, beaten by {opponent} in the {stage}.'**
  String hubKnockedOutBody1(String cup, String opponent, String stage);

  /// Inbox: knocked out of a tournament, body.
  ///
  /// In en, this message translates to:
  /// **'{opponent} end your {cup} in the {stage}.'**
  String hubKnockedOutBody2(String cup, String opponent, String stage);

  /// Inbox: knocked out of a tournament, body.
  ///
  /// In en, this message translates to:
  /// **'Your {cup} ends in the {stage}, beaten by {opponent}.'**
  String hubKnockedOutBody3(String cup, String opponent, String stage);

  /// Inbox: eliminated in the group stage, headline.
  ///
  /// In en, this message translates to:
  /// **'Group stage exit'**
  String get hubGroupExitTitle1;

  /// Inbox: eliminated in the group stage, headline.
  ///
  /// In en, this message translates to:
  /// **'Out at the group stage'**
  String get hubGroupExitTitle2;

  /// Inbox: eliminated in the group stage, headline.
  ///
  /// In en, this message translates to:
  /// **'Early bath'**
  String get hubGroupExitTitle3;

  /// Inbox: eliminated in the group stage, body.
  ///
  /// In en, this message translates to:
  /// **'Your {cup} is over at the group stage. Not enough to reach the knockouts.'**
  String hubGroupExitBody1(String cup);

  /// Inbox: eliminated in the group stage, body.
  ///
  /// In en, this message translates to:
  /// **'You failed to get out of the group. Your {cup} ends here.'**
  String hubGroupExitBody2(String cup);

  /// Inbox: eliminated in the group stage, body.
  ///
  /// In en, this message translates to:
  /// **'No knockout place this time. Your {cup} is done at the group stage.'**
  String hubGroupExitBody3(String cup);

  /// Inbox: the board's verdict on a cycle objective.
  ///
  /// In en, this message translates to:
  /// **'Objective met — {comp}'**
  String boardObjectiveMetTitle(String comp);

  /// Inbox: the board's verdict on a cycle objective.
  ///
  /// In en, this message translates to:
  /// **'Objective missed — {comp}'**
  String boardObjectiveMissedTitle(String comp);

  /// Inbox: the board's verdict body when the objective was met.
  ///
  /// In en, this message translates to:
  /// **'The board\'s target at the {comp}: {demand}. You finished: {finish}. They have what they asked for.'**
  String boardObjectiveMetBody(String comp, String demand, String finish);

  /// Inbox: the board's verdict body when the objective was missed.
  ///
  /// In en, this message translates to:
  /// **'The board\'s target at the {comp}: {demand}. You finished: {finish}. That is short of what was expected.'**
  String boardObjectiveMissedBody(String comp, String demand, String finish);

  /// Inbox: failed to qualify for the World Cup.
  ///
  /// In en, this message translates to:
  /// **'World Cup dream over'**
  String get newsWcMissTitle;

  /// Inbox: failed to qualify for the World Cup, body.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t make the {year} World Cup — the qualifying campaign fell short. Four more years.'**
  String newsWcMissBody(int year);

  /// Inbox: a new all-time scoring record.
  ///
  /// In en, this message translates to:
  /// **'All-time top scorer'**
  String get newsRecordScorerTitle;

  /// Inbox: all-time scoring record body.
  ///
  /// In en, this message translates to:
  /// **'{name} is now the game\'s all-time leading goalscorer with {goals} goals.'**
  String newsRecordScorerBody(String name, int goals);

  /// Inbox: a new all-time appearance record.
  ///
  /// In en, this message translates to:
  /// **'Most-capped player'**
  String get newsRecordCapsTitle;

  /// Inbox: all-time appearance record body.
  ///
  /// In en, this message translates to:
  /// **'{name} is now the game\'s most-capped player with {caps} appearances.'**
  String newsRecordCapsBody(String name, int caps);

  /// Inbox fallback when the record holder cannot be named.
  ///
  /// In en, this message translates to:
  /// **'A new record-breaker'**
  String get newsARecordBreaker;

  /// Inbox: a notable club transfer.
  ///
  /// In en, this message translates to:
  /// **'{name} joins {club}'**
  String newsTransferTitle(String name, String club);

  /// Inbox: transfer body.
  ///
  /// In en, this message translates to:
  /// **'{name} ({position}, {rating}) has left {fromClub} to sign for {destination} for {fee}.'**
  String newsTransferBody(
    String name,
    String position,
    String fromClub,
    String destination,
    String fee,
    int rating,
  );

  /// How a club abroad is named in transfer news.
  ///
  /// In en, this message translates to:
  /// **'{club} in {country}'**
  String newsTransferAbroad(String club, String country);

  /// Transfer fee when there is none.
  ///
  /// In en, this message translates to:
  /// **'a free transfer'**
  String get newsTransferFree;

  /// Inbox: a star naturalisation candidate.
  ///
  /// In en, this message translates to:
  /// **'⭐ {name} would switch to {nation}!'**
  String newsNatzStarTitle(String name, String nation);

  /// Inbox: a naturalisation candidate.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to play for {nation}'**
  String newsNatzTitle(String name, String nation);

  /// Inbox: naturalisation offer body.
  ///
  /// In en, this message translates to:
  /// **'{name}, a {age}-year-old {position} rated {rating} currently with {fromNation}, has family ties to {nation} and is open to switching. Open the Naturalisation offer to accept or decline.'**
  String newsNatzBody(
    String name,
    String position,
    String fromNation,
    String nation,
    int age,
    int rating,
  );

  /// Inbox: naturalisation offer body for a star player.
  ///
  /// In en, this message translates to:
  /// **'{name}, a {age}-year-old {position} rated {rating} currently with {fromNation}, is a star name who has family ties to {nation} and is open to switching. Open the Naturalisation offer to accept or decline.'**
  String newsNatzBodyStar(
    String name,
    String position,
    String fromNation,
    String nation,
    int age,
    int rating,
  );

  /// Fallback for an unnamed source nation in naturalisation news.
  ///
  /// In en, this message translates to:
  /// **'their nation'**
  String get newsTheirNation;

  /// Fallback for an unnamed destination nation in naturalisation news.
  ///
  /// In en, this message translates to:
  /// **'your nation'**
  String get newsYourNation;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'CHAMPIONS'**
  String get tourStatusChampions;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'FINALS'**
  String get tourStatusFinals;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'QUALIFYING'**
  String get tourStatusQualifying;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING'**
  String get tourStatusUpcoming;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'IN PROGRESS'**
  String get tourStatusInProgress;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
  String get tourStatusComingSoon;

  /// Tournament tile status.
  ///
  /// In en, this message translates to:
  /// **'DECIDED'**
  String get tourStatusDecided;

  /// Tournament tile status: which Nations Cup league the manager is in.
  ///
  /// In en, this message translates to:
  /// **'LEAGUE {letter}'**
  String tourStatusLeague(String letter);

  /// Draw-ceremony heading.
  ///
  /// In en, this message translates to:
  /// **'WORLD CUP QUALIFYING DRAW'**
  String get tourDrawWcQualifying;

  /// Draw-ceremony heading.
  ///
  /// In en, this message translates to:
  /// **'{cup} QUALIFYING DRAW'**
  String tourDrawContQualifying(String cup);

  /// Host-draw ceremony heading.
  ///
  /// In en, this message translates to:
  /// **'WORLD CUP HOST'**
  String get tourDrawWcHost;

  /// Host-draw ceremony heading.
  ///
  /// In en, this message translates to:
  /// **'{cup} HOST'**
  String tourDrawContHost(String cup);

  /// Fallback tournament name on the opening-ceremony screen.
  ///
  /// In en, this message translates to:
  /// **'CONTINENTAL CUP'**
  String get tourKickoffContinentalCup;

  /// Host banner: the competition and its year.
  ///
  /// In en, this message translates to:
  /// **'{competition} {year}'**
  String tourHostCompetitionYear(String competition, int year);

  /// Inbox: failed to qualify for the continental cup.
  ///
  /// In en, this message translates to:
  /// **'{cup} missed'**
  String newsContMissTitle(String cup);

  /// Inbox: failed to qualify for the continental cup, body.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t qualify for {cup} — the campaign came up short this time.'**
  String newsContMissBody(String cup);

  /// Inbox: the year's player award.
  ///
  /// In en, this message translates to:
  /// **'World Player of the Year {year}'**
  String newsPotyTitle(int year);

  /// Inbox: the year's player award, body.
  ///
  /// In en, this message translates to:
  /// **'{name} is the best player in the world this year.'**
  String newsPotyBody(String name);

  /// Inbox: appended when a different player takes the young-player award.
  ///
  /// In en, this message translates to:
  /// **' {name} takes the young player\'s award.'**
  String newsPotyYoungSuffix(String name);

  /// Live-match screen top bar.
  ///
  /// In en, this message translates to:
  /// **'MATCH'**
  String get matchTopBarTitle;

  /// Live match: stats tab before full time.
  ///
  /// In en, this message translates to:
  /// **'Stats available at full time.'**
  String get matchStatsAtFullTime;

  /// Live match: player-ratings heading.
  ///
  /// In en, this message translates to:
  /// **'PLAYER RATINGS'**
  String get matchPlayerRatings;

  /// Live match: substitutions heading.
  ///
  /// In en, this message translates to:
  /// **'SUBSTITUTIONS'**
  String get matchSubstitutions;

  /// Live match: bench heading.
  ///
  /// In en, this message translates to:
  /// **'SUBSTITUTES'**
  String get matchSubstitutes;

  /// Live match: man-of-the-match heading.
  ///
  /// In en, this message translates to:
  /// **'PLAYER OF THE MATCH'**
  String get matchPlayerOfTheMatch;

  /// Live match: the goal flash.
  ///
  /// In en, this message translates to:
  /// **'GOAL!'**
  String get matchGoalShout;

  /// Live match: the shoot-out scoreline.
  ///
  /// In en, this message translates to:
  /// **'SHOOTOUT {home}–{away}'**
  String matchShootoutScore(int home, int away);

  /// Tournament screen: venues card heading.
  ///
  /// In en, this message translates to:
  /// **'VENUES'**
  String get tourVenues;

  /// Draw ceremony: a seeding pot.
  ///
  /// In en, this message translates to:
  /// **'POT {number}'**
  String tourPot(int number);

  /// Host-draw screen heading.
  ///
  /// In en, this message translates to:
  /// **'HOST SELECTION'**
  String get tourHostSelection;

  /// Host-draw screen: the bidding nations.
  ///
  /// In en, this message translates to:
  /// **'CANDIDATES'**
  String get tourCandidates;

  /// Host-draw screen: a shared bid.
  ///
  /// In en, this message translates to:
  /// **'JOINT BID'**
  String get tourJointBid;

  /// Tournament awards: best goalkeeper.
  ///
  /// In en, this message translates to:
  /// **'GOLDEN GLOVE'**
  String get tourGoldenGlove;

  /// Tournament awards heading.
  ///
  /// In en, this message translates to:
  /// **'TEAM OF THE TOURNAMENT'**
  String get tourTeamOfTournament;

  /// Tournament bracket: the manager's own path.
  ///
  /// In en, this message translates to:
  /// **'YOUR RUN'**
  String get tourYourRun;

  /// Tournament history heading.
  ///
  /// In en, this message translates to:
  /// **'MEDAL TABLE'**
  String get tourMedalTable;

  /// Tournament history: who hosted an edition.
  ///
  /// In en, this message translates to:
  /// **'Host: {nation}'**
  String tourHostLine(String nation);

  /// A group's name in a bracket or table.
  ///
  /// In en, this message translates to:
  /// **'Group {name}'**
  String tourGroupNamed(String name);

  /// Finals-draw screen blurb.
  ///
  /// In en, this message translates to:
  /// **'Seeded by world ranking. Spot your nation before the draw.'**
  String get tourFinalsDrawBlurb;

  /// Tournaments screen: link to the world ranking.
  ///
  /// In en, this message translates to:
  /// **'World Ranking'**
  String get tourWorldRanking;

  /// Tournaments screen section heading.
  ///
  /// In en, this message translates to:
  /// **'YOUR COMPETITIONS'**
  String get tourYourCompetitions;

  /// Tournaments screen section heading.
  ///
  /// In en, this message translates to:
  /// **'OTHER CONTINENTS'**
  String get tourOtherContinents;

  /// Opening-ceremony screen: the host nations.
  ///
  /// In en, this message translates to:
  /// **'HOSTED BY  {hosts}'**
  String tourHostedBy(String hosts);

  /// Best-third-placed table: how many go through and where.
  ///
  /// In en, this message translates to:
  /// **'Top {count} advance to {destination}'**
  String tourThirdsAdvance(int count, String destination);

  /// Inbox: a player retires internationally after being ignored.
  ///
  /// In en, this message translates to:
  /// **'{name} walks away'**
  String newsWalkoutTitle(String name);

  /// Inbox: walkout body.
  ///
  /// In en, this message translates to:
  /// **'{name} has retired from international football at {age}, with {caps} caps. He asked to be told where he stood and was not, and he is not waiting any longer.'**
  String newsWalkoutBody(String name, int age, int caps);

  /// Press conference: a Accountability follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You\'ve backed them again. Is nobody in that dressing room accountable?'**
  String get pressProbeAccountability1;

  /// Press conference: a Accountability follow-up question.
  ///
  /// In en, this message translates to:
  /// **'That\'s the players defended. Who actually answers for a night like that?'**
  String get pressProbeAccountability2;

  /// Press conference: a Accountability follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Loyalty is easy from up there. Does anyone pay a price?'**
  String get pressProbeAccountability3;

  /// Press conference: a Accountability follow-up question.
  ///
  /// In en, this message translates to:
  /// **'If it\'s never the players, we\'re left with one name. Yours.'**
  String get pressProbeAccountability4;

  /// Press conference: a YourFuture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You\'ve taken it on yourself. Should we be asking about your future?'**
  String get pressProbeYourFuture1;

  /// Press conference: a YourFuture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Falling on your sword is noble. Is the job still yours?'**
  String get pressProbeYourFuture2;

  /// Press conference: a YourFuture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You keep saying it\'s you. At what point is that a resignation?'**
  String get pressProbeYourFuture3;

  /// Press conference: a YourFuture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'The board are listening too. Are you sure you want that on record?'**
  String get pressProbeYourFuture4;

  /// Press conference: a DressingRoom follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Strong words in public. Have you lost that dressing room?'**
  String get pressProbeDressingRoom1;

  /// Press conference: a DressingRoom follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You\'ve just told the country they\'re not good enough. How does that help?'**
  String get pressProbeDressingRoom2;

  /// Press conference: a DressingRoom follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Demanding it here rather than in there — is that leadership?'**
  String get pressProbeDressingRoom3;

  /// Press conference: a DressingRoom follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Players read this too. What do they hear tomorrow morning?'**
  String get pressProbeDressingRoom4;

  /// Press conference: a Expectation follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You\'ve raised the bar in public. Is that not a hostage to fortune?'**
  String get pressProbeExpectation1;

  /// Press conference: a Expectation follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Big promise. What happens the day you don\'t deliver it?'**
  String get pressProbeExpectation2;

  /// Press conference: a Expectation follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Every manager before you said the same and packed a bag. Why are you different?'**
  String get pressProbeExpectation3;

  /// Press conference: a Expectation follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You\'ve set the target. Will you resign if you miss it?'**
  String get pressProbeExpectation4;

  /// Press conference: a Substance follow-up question.
  ///
  /// In en, this message translates to:
  /// **'With respect, that\'s not an answer. Give us something.'**
  String get pressProbeSubstance1;

  /// Press conference: a Substance follow-up question.
  ///
  /// In en, this message translates to:
  /// **'The country wants to hear from you. Anything at all?'**
  String get pressProbeSubstance2;

  /// Press conference: a Substance follow-up question.
  ///
  /// In en, this message translates to:
  /// **'You can keep saying nothing. We\'ll keep printing it.'**
  String get pressProbeSubstance3;

  /// Press conference: a Substance follow-up question.
  ///
  /// In en, this message translates to:
  /// **'One straight sentence. What do you actually think?'**
  String get pressProbeSubstance4;

  /// Press conference: a Selection follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Same names, same shape, same result. Why does that team keep getting picked?'**
  String get pressProbeSelection1;

  /// Press conference: a Selection follow-up question.
  ///
  /// In en, this message translates to:
  /// **'There are players in form watching this on television. Explain the selection.'**
  String get pressProbeSelection2;

  /// Press conference: a Selection follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Is the XI picked on merit, or on reputation?'**
  String get pressProbeSelection3;

  /// Press conference: a Selection follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Tactically, we all saw the problem. Did you?'**
  String get pressProbeSelection4;

  /// Press conference: a TheFans follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Thousands travelled for that. What do you say to them tonight?'**
  String get pressProbeTheFans1;

  /// Press conference: a TheFans follow-up question.
  ///
  /// In en, this message translates to:
  /// **'The supporters have stuck with this team for years. What are you giving them?'**
  String get pressProbeTheFans2;

  /// Press conference: a TheFans follow-up question.
  ///
  /// In en, this message translates to:
  /// **'They sing your name or they don\'t. Which is it going to be?'**
  String get pressProbeTheFans3;

  /// Press conference: a TheFans follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Message to the people back home. Go on.'**
  String get pressProbeTheFans4;

  /// Press conference: a BigPicture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Step back for me. Where is this nation actually going?'**
  String get pressProbeBigPicture1;

  /// Press conference: a BigPicture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'From the outside, nothing has changed here in years. Has it?'**
  String get pressProbeBigPicture2;

  /// Press conference: a BigPicture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'In four years\' time, what does this side look like?'**
  String get pressProbeBigPicture3;

  /// Press conference: a BigPicture follow-up question.
  ///
  /// In en, this message translates to:
  /// **'Is this a project, or is it just the next match?'**
  String get pressProbeBigPicture4;

  /// Press conference: a reporter's aside when the manager keeps taking the same stance.
  ///
  /// In en, this message translates to:
  /// **'You always back them. We\'ve heard it.'**
  String get pressNeedleBackPlayers;

  /// Press conference: a reporter's aside when the manager keeps taking the same stance.
  ///
  /// In en, this message translates to:
  /// **'It\'s always your fault, apparently.'**
  String get pressNeedleTakeBlame;

  /// Press conference: a reporter's aside when the manager keeps taking the same stance.
  ///
  /// In en, this message translates to:
  /// **'More demands. Again.'**
  String get pressNeedleDemandMore;

  /// Press conference: a reporter's aside when the manager keeps taking the same stance.
  ///
  /// In en, this message translates to:
  /// **'Another promise for the file.'**
  String get pressNeedleRaiseBar;

  /// Press conference: a reporter's aside when the manager keeps taking the same stance.
  ///
  /// In en, this message translates to:
  /// **'You never give us anything.'**
  String get pressNeedlePlayDown;

  /// Press conference: the morning's headline after a conference that went went.
  ///
  /// In en, this message translates to:
  /// **'A manager in charge of the room'**
  String get pressHeadlineWent1;

  /// Press conference: the morning's headline after a conference that went went.
  ///
  /// In en, this message translates to:
  /// **'They came for a row and got a leader'**
  String get pressHeadlineWent2;

  /// Press conference: the morning's headline after a conference that went went.
  ///
  /// In en, this message translates to:
  /// **'Straight answers, and they landed'**
  String get pressHeadlineWent3;

  /// Press conference: the morning's headline after a conference that went mixed.
  ///
  /// In en, this message translates to:
  /// **'Plenty said, little settled'**
  String get pressHeadlineMixed1;

  /// Press conference: the morning's headline after a conference that went mixed.
  ///
  /// In en, this message translates to:
  /// **'Something for everyone, and nothing for anyone'**
  String get pressHeadlineMixed2;

  /// Press conference: the morning's headline after a conference that went mixed.
  ///
  /// In en, this message translates to:
  /// **'A conference that left the questions open'**
  String get pressHeadlineMixed3;

  /// Press conference: the morning's headline after a conference that went badly.
  ///
  /// In en, this message translates to:
  /// **'A bruising afternoon in front of the cameras'**
  String get pressHeadlineBadly1;

  /// Press conference: the morning's headline after a conference that went badly.
  ///
  /// In en, this message translates to:
  /// **'The room turned, and it showed'**
  String get pressHeadlineBadly2;

  /// Press conference: the morning's headline after a conference that went badly.
  ///
  /// In en, this message translates to:
  /// **'Answers that will read worse in the morning'**
  String get pressHeadlineBadly3;

  /// Press conference: the morning's headline after a conference that went flat.
  ///
  /// In en, this message translates to:
  /// **'Nothing said, nothing gained'**
  String get pressHeadlineFlat1;

  /// Press conference: the morning's headline after a conference that went flat.
  ///
  /// In en, this message translates to:
  /// **'Ten minutes, no news'**
  String get pressHeadlineFlat2;

  /// Press conference: the morning's headline after a conference that went flat.
  ///
  /// In en, this message translates to:
  /// **'A blank page for the back page'**
  String get pressHeadlineFlat3;

  /// Press sheet heading.
  ///
  /// In en, this message translates to:
  /// **'PRESS CONFERENCE'**
  String get pressConferenceTitle;

  /// Press sheet progress line.
  ///
  /// In en, this message translates to:
  /// **'Question {index} of {total}'**
  String pressQuestionOf(int index, int total);

  /// Press sheet: heading over the closing headline.
  ///
  /// In en, this message translates to:
  /// **'TOMORROW\'S BACK PAGE'**
  String get pressTomorrowsHeadline;

  /// Press sheet: the button that closes the conference.
  ///
  /// In en, this message translates to:
  /// **'LEAVE THE ROOM'**
  String get pressLeaveRoom;

  /// Press sheet: the summary line's squad column.
  ///
  /// In en, this message translates to:
  /// **'Dressing room'**
  String get pressRoomVerdictSquad;

  /// Press sheet: the summary line's board column.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get pressRoomVerdictBoard;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'no notes. none. perfect.'**
  String get yReactionElation0;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'I am unwell (good).'**
  String get yReactionElation1;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'framing this. putting it above the fireplace.'**
  String get yReactionElation2;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'we are so back'**
  String get yReactionElation3;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Screenshotting this for the doubters. All of them.'**
  String get yReactionElation4;

  /// Y feed: a elation reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'I\'m going to be insufferable about this for a decade.'**
  String get yReactionElation5;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'that took ten years off me'**
  String get yReactionRelief0;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Ugly. Three points. Moving on.'**
  String get yReactionRelief1;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Nobody speak. Nobody jinx it.'**
  String get yReactionRelief2;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Not pretty, but I\'ll take it every single time.'**
  String get yReactionRelief3;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Heart rate: unacceptable.'**
  String get yReactionRelief4;

  /// Y feed: a relief reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Somehow. Somehow!'**
  String get yReactionRelief5;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Absolute state of this.'**
  String get yReactionFury0;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Not good enough. Not remotely.'**
  String get yReactionFury1;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'I want names.'**
  String get yReactionFury2;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Every four years, the same. EVERY four years.'**
  String get yReactionFury3;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Deleting the app. Reinstalling Thursday.'**
  String get yReactionFury4;

  /// Y feed: a fury reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Somebody explain that to me slowly.'**
  String get yReactionFury5;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'well.'**
  String get yReactionDespair0;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'I have run out of ways to say this.'**
  String get yReactionDespair1;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Going for a walk. A long one.'**
  String get yReactionDespair2;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'this is the darkest timeline'**
  String get yReactionDespair3;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Wake me in four years.'**
  String get yReactionDespair4;

  /// Y feed: a despair reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'No jokes today. Nothing.'**
  String get yReactionDespair5;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Said it in January. Check the timeline.'**
  String get yReactionSmugness0;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Some of you owe some of us an apology.'**
  String get yReactionSmugness1;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Quietly, but: told you.'**
  String get yReactionSmugness2;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'The doubters have gone very quiet.'**
  String get yReactionSmugness3;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'bookmark this one'**
  String get yReactionSmugness4;

  /// Y feed: a smugness reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Not that anybody\'s counting. I\'m counting.'**
  String get yReactionSmugness5;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'it happened. next.'**
  String get yReactionShrug0;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Fine. Whatever. Onwards.'**
  String get yReactionShrug1;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Filing this one under \'football\'.'**
  String get yReactionShrug2;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'no thoughts, head empty'**
  String get yReactionShrug3;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Wake me for the next one.'**
  String get yReactionShrug4;

  /// Y feed: a shrug reply under somebody else's post.
  ///
  /// In en, this message translates to:
  /// **'Genuinely nothing to add.'**
  String get yReactionShrug5;

  /// Best-third-placed table: why some results are dropped.
  ///
  /// In en, this message translates to:
  /// **'Groups are uneven — results against each big group\'s bottom side are dropped, so every team is judged over the same games.'**
  String get tourThirdsUneven;

  /// Premium gate: headline at the end of the free cycle.
  ///
  /// In en, this message translates to:
  /// **'YOUR FIRST CYCLE IS OVER'**
  String get gateTitle;

  /// Premium gate: the pitch under the headline.
  ///
  /// In en, this message translates to:
  /// **'Four years, a continental championship and a World Cup — that was the free part, and nothing was held back. Carry this save on for a one-off payment.'**
  String get gateLead;

  /// Premium gate benefit.
  ///
  /// In en, this message translates to:
  /// **'Unlimited careers — every cycle from here on'**
  String get gateBenefitEndless;

  /// Premium gate benefit.
  ///
  /// In en, this message translates to:
  /// **'Every nation in the world to manage'**
  String get gateBenefitNations;

  /// Premium gate benefit.
  ///
  /// In en, this message translates to:
  /// **'10 save slots instead of 3'**
  String get gateBenefitSaves;

  /// Premium gate benefit.
  ///
  /// In en, this message translates to:
  /// **'Every future update included'**
  String get gateBenefitUpdates;

  /// Premium gate benefit.
  ///
  /// In en, this message translates to:
  /// **'Works offline — no subscription, no ads, no account'**
  String get gateBenefitOffline;

  /// Premium gate: the line above the price.
  ///
  /// In en, this message translates to:
  /// **'One payment, forever'**
  String get gatePriceLead;

  /// Premium gate: the price. Placeholder until the store's own localised price is wired in.
  ///
  /// In en, this message translates to:
  /// **'€11.99'**
  String get gatePrice;

  /// Premium gate: the button that continues the career.
  ///
  /// In en, this message translates to:
  /// **'BUY AND CONTINUE'**
  String get gateBuy;

  /// Premium gate: the button that leaves the save.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get gateExit;

  /// Premium gate: an honest note while the store is not wired up.
  ///
  /// In en, this message translates to:
  /// **'Not connected to payment yet — this button just continues.'**
  String get gateNotChargedYet;

  /// Settings: heading for the backup section.
  ///
  /// In en, this message translates to:
  /// **'SAVES'**
  String get backupTitle;

  /// Settings: what the backup section is for.
  ///
  /// In en, this message translates to:
  /// **'Every save lives in one file on this phone. Export a copy so a lost or reinstalled phone does not cost you a career.'**
  String get backupBlurb;

  /// Settings: the export button.
  ///
  /// In en, this message translates to:
  /// **'EXPORT A BACKUP'**
  String get backupExport;

  /// Subject line when the exported save is shared.
  ///
  /// In en, this message translates to:
  /// **'FNM saves'**
  String get backupExportSubject;

  /// Settings: the restore button.
  ///
  /// In en, this message translates to:
  /// **'RESTORE FROM A FILE'**
  String get backupRestore;

  /// Confirmation title before a restore.
  ///
  /// In en, this message translates to:
  /// **'Replace every save?'**
  String get backupRestoreWarnTitle;

  /// Confirmation body before a restore.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces every save on this phone with the ones in the file. The app will restart.'**
  String get backupRestoreWarnBody;

  /// Confirmation button for a restore.
  ///
  /// In en, this message translates to:
  /// **'REPLACE'**
  String get backupRestoreConfirm;

  /// Dismisses the restore confirmation.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get backupCancel;

  /// Snackbar after a successful export.
  ///
  /// In en, this message translates to:
  /// **'Backup ready — choose where to keep it.'**
  String get backupExported;

  /// Snackbar when an export fails.
  ///
  /// In en, this message translates to:
  /// **'Could not write the backup.'**
  String get backupFailed;

  /// Restore refused: not a readable database.
  ///
  /// In en, this message translates to:
  /// **'That file could not be opened.'**
  String get backupRejectedUnreadable;

  /// Restore refused: a database, but not ours.
  ///
  /// In en, this message translates to:
  /// **'That is not an FNM save.'**
  String get backupRejectedNotFnm;

  /// Restore refused: the backup is from a later build.
  ///
  /// In en, this message translates to:
  /// **'That save was made by a newer version of the app. Update first.'**
  String get backupRejectedNewer;

  /// Restore refused: older than the migration path reaches.
  ///
  /// In en, this message translates to:
  /// **'That save is too old to be restored by this version.'**
  String get backupRejectedTooOld;

  /// Saves list: tooltip on the per-career export button.
  ///
  /// In en, this message translates to:
  /// **'Share this career'**
  String get careerShare;

  /// Saves list: the button that adds a career from a file.
  ///
  /// In en, this message translates to:
  /// **'IMPORT A CAREER'**
  String get careerImport;

  /// Subject line when a single career is shared.
  ///
  /// In en, this message translates to:
  /// **'An FNM career'**
  String get careerShareSubject;

  /// Snackbar after a career has been added from a file.
  ///
  /// In en, this message translates to:
  /// **'Career imported.'**
  String get careerImported;

  /// Import refused: unreadable bundle.
  ///
  /// In en, this message translates to:
  /// **'That file is not an FNM career.'**
  String get careerImportFailedUnreadable;

  /// Import refused: the bundle is from a later build.
  ///
  /// In en, this message translates to:
  /// **'That career was exported by a newer version of the app. Update first.'**
  String get careerImportFailedNewer;

  /// Snackbar when a per-career export fails.
  ///
  /// In en, this message translates to:
  /// **'Could not export that career.'**
  String get careerShareFailed;

  /// Manager screen: app bar title.
  ///
  /// In en, this message translates to:
  /// **'MANAGER'**
  String get managerTitle;

  /// Manager screen: skills section heading.
  ///
  /// In en, this message translates to:
  /// **'YOUR SKILLS'**
  String get managerSkills;

  /// Manager screen: unspent skill points.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No points to spend} one{1 point to spend} other{{count} points to spend}}'**
  String managerPointsAvailable(int count);

  /// Manager screen: how points are earned.
  ///
  /// In en, this message translates to:
  /// **'Two points for every cycle you complete, one for every trophy you win.'**
  String get managerPointsHow;

  /// Manager skill name.
  ///
  /// In en, this message translates to:
  /// **'Man Management'**
  String get managerSkillManManagement;

  /// Manager skill effect.
  ///
  /// In en, this message translates to:
  /// **'What you say in public and in your office lands harder.'**
  String get managerSkillManManagementBlurb;

  /// Manager skill name.
  ///
  /// In en, this message translates to:
  /// **'Tactical'**
  String get managerSkillTactical;

  /// Manager skill effect.
  ///
  /// In en, this message translates to:
  /// **'Your side settles into a new shape faster.'**
  String get managerSkillTacticalBlurb;

  /// Manager skill name.
  ///
  /// In en, this message translates to:
  /// **'Youth Development'**
  String get managerSkillYouth;

  /// Manager skill effect.
  ///
  /// In en, this message translates to:
  /// **'More comes out of the academy.'**
  String get managerSkillYouthBlurb;

  /// Manager skill name.
  ///
  /// In en, this message translates to:
  /// **'Negotiation'**
  String get managerSkillNegotiation;

  /// Manager skill effect.
  ///
  /// In en, this message translates to:
  /// **'The federation funds you better.'**
  String get managerSkillNegotiationBlurb;

  /// Manager screen: staff section heading.
  ///
  /// In en, this message translates to:
  /// **'YOUR STAFF'**
  String get managerStaff;

  /// Manager screen: the standing staff cost.
  ///
  /// In en, this message translates to:
  /// **'Wages: {amount} per cycle'**
  String managerStaffWages(String amount);

  /// Staff role.
  ///
  /// In en, this message translates to:
  /// **'Assistant Manager'**
  String get managerRoleAssistant;

  /// Staff role effect.
  ///
  /// In en, this message translates to:
  /// **'Runs the training. Everything you focus on, he does more of.'**
  String get managerRoleAssistantBlurb;

  /// Staff role.
  ///
  /// In en, this message translates to:
  /// **'Chief Scout'**
  String get managerRoleScout;

  /// Staff role effect.
  ///
  /// In en, this message translates to:
  /// **'Tells you what a young player will become, sooner.'**
  String get managerRoleScoutBlurb;

  /// Staff role.
  ///
  /// In en, this message translates to:
  /// **'Fitness Coach'**
  String get managerRoleFitness;

  /// Staff role effect.
  ///
  /// In en, this message translates to:
  /// **'Keeps them on the pitch.'**
  String get managerRoleFitnessBlurb;

  /// Shown against a staff role with nobody hired.
  ///
  /// In en, this message translates to:
  /// **'Nobody in the job'**
  String get staffVacant;

  /// Option in the staff picker that hires nobody.
  ///
  /// In en, this message translates to:
  /// **'Leave the job empty'**
  String get staffLeaveVacant;

  /// Staff quality tier.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get managerTierNone;

  /// Staff quality tier.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get managerTierBasic;

  /// Staff quality tier.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get managerTierGood;

  /// Staff quality tier.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get managerTierElite;

  /// Cost of hiring nobody.
  ///
  /// In en, this message translates to:
  /// **'free'**
  String get managerFree;

  /// Manager screen: training focus section heading.
  ///
  /// In en, this message translates to:
  /// **'BETWEEN WINDOWS'**
  String get managerTraining;

  /// Manager screen: what the training focus is.
  ///
  /// In en, this message translates to:
  /// **'What the squad works on when there is no match to play.'**
  String get managerTrainingBlurb;

  /// Training focus.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get managerFocusBalanced;

  /// Training focus effect.
  ///
  /// In en, this message translates to:
  /// **'A bit of everything.'**
  String get managerFocusBalancedBlurb;

  /// Training focus.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get managerFocusFitness;

  /// Training focus effect.
  ///
  /// In en, this message translates to:
  /// **'Fewer knocks.'**
  String get managerFocusFitnessBlurb;

  /// Training focus.
  ///
  /// In en, this message translates to:
  /// **'Cohesion'**
  String get managerFocusCohesion;

  /// Training focus effect.
  ///
  /// In en, this message translates to:
  /// **'The shape beds in faster.'**
  String get managerFocusCohesionBlurb;

  /// Training focus.
  ///
  /// In en, this message translates to:
  /// **'Youth'**
  String get managerFocusYouth;

  /// Training focus effect.
  ///
  /// In en, this message translates to:
  /// **'Hours with the youngest in the pool.'**
  String get managerFocusYouthBlurb;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'First time here?'**
  String get tourOfferTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'This is a big game. Want a quick walk through the screens that matter? It takes a minute, and you can start it again any time from Settings.'**
  String get tourOfferBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Show me around'**
  String get tourOfferYes;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'No thanks'**
  String get tourOfferNo;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get tourBack;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tourDone;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'This is the whole game'**
  String get tourHubTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'One button, and it changes as the cycle moves: a draw to watch, a squad to name, a match to play. Above it sit the board\'s confidence in you and the objectives they have set.'**
  String get tourHubBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The federation\'s money'**
  String get tourBudgetTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Once every four-year cycle you split the war chest between the departments. Your staff are paid out of it first, so hiring an elite scout is a decision you make against the academy, not alongside it.'**
  String get tourBudgetBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'How the side plays'**
  String get tourTacticsTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Your shape, your way of playing, your captain and who takes the set pieces. Leave the last two unset and the game will warn you before kick-off rather than quietly picking for you.'**
  String get tourTacticsBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Everyone you can pick'**
  String get tourSquadTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The whole pool, not just the squad: who is in form, who is carrying a knock, who is banned, and who has just come through the academy.'**
  String get tourSquadBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Naming a squad'**
  String get tourCallUpsTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'You name one squad per international window and it plays every match of that window, exactly as a real manager does. An injury inside the window pulls in a replacement for you.'**
  String get tourCallUpsBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Your career'**
  String get tourRecordsTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Everything you have done: the matches, the team records, the trophies, and every nation you have managed.'**
  String get tourRecordsBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The rest of the world'**
  String get tourCupsTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Every competition running right now — groups, standings and knockouts — including the ones you are not in. The world keeps playing whether or not you qualified.'**
  String get tourCupsBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Replay the tutorial'**
  String get settingsTourTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Walk through the key screens again from the start.'**
  String get settingsTourBlurb;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Who you answer to'**
  String get tourBoardTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The board\'s confidence in you, and the objectives they have set for this cycle. Miss the brief and this is where you will see it coming.'**
  String get tourBoardBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The people around you'**
  String get tourStaffTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'An assistant, a scout and a fitness coach, hired by name. Their wages come out of this budget before the departments do, so a great scout is a decision against the academy.'**
  String get tourStaffBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Your way of playing'**
  String get tourPlaystyleTitle;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'The shape is only half a tactic. This is the other half — how high you press, how direct you are, how much you risk.'**
  String get tourPlaystyleBody;

  /// Guided tour string.
  ///
  /// In en, this message translates to:
  /// **'Start a career first — the walk through visits your own screens.'**
  String get settingsTourNoSave;

  /// Sub picker: an out-of-position candidate, with his age.
  ///
  /// In en, this message translates to:
  /// **'Out of position · Age {age}'**
  String tacticsOutOfPositionAge(int age);

  /// Finances: says the next cycle's budget is decided at its start, not here.
  ///
  /// In en, this message translates to:
  /// **'The next cycle\'s budget is set at the start of that cycle, in one go. Until then this is what your money is doing.'**
  String get federationNextCycleLocked;

  /// Budget screen: the allocation for this cycle is already committed.
  ///
  /// In en, this message translates to:
  /// **'Already set for this cycle'**
  String get federationBudgetAlreadySet;

  /// Y feed: anticipation before a final.
  ///
  /// In en, this message translates to:
  /// **'It\'s {opponent} for the big one. All week, this is all anybody is going to talk about.'**
  String yFinalLooms0(String opponent);

  /// Y feed: anticipation before a final.
  ///
  /// In en, this message translates to:
  /// **'Confirmed: {opponent} stand between us and it. Four years for this.'**
  String yFinalLooms1(String opponent);

  /// Y feed: anticipation before a final.
  ///
  /// In en, this message translates to:
  /// **'Right. {opponent}. Nobody sleeps until this is over.'**
  String yFinalLooms2(String opponent);

  /// Y feed: anticipation before a final.
  ///
  /// In en, this message translates to:
  /// **'{opponent} next, and everything else can wait. What a week to be alive.'**
  String yFinalLooms3(String opponent);

  /// Friendlies: why these opponents are suggested first.
  ///
  /// In en, this message translates to:
  /// **'Suggested first: sides who play like {rivals}, who you have drawn.'**
  String friendliesLikeYourGroup(String rivals);

  /// Inbox: the window's transfers, as one report.
  ///
  /// In en, this message translates to:
  /// **'Transfer window · {year}'**
  String newsTransferWindowTitle(int year);

  /// Saves list: how long since this save was opened, in one short unit.
  ///
  /// In en, this message translates to:
  /// **'Last {when} ago'**
  String careerLastAgo(String when);

  /// Settings: what the free game covers.
  ///
  /// In en, this message translates to:
  /// **'One free four-year cycle'**
  String get settingsFreeScopeTitle;

  /// Settings: what the free game covers.
  ///
  /// In en, this message translates to:
  /// **'A complete cycle — qualifying, a continental championship and a World Cup — with nothing held back. Carrying a save on past it is a single payment, once, and it covers every save and every future update.'**
  String get settingsFreeScopeBlurb;

  /// Settings: what the free game covers.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get settingsUnlockedTitle;

  /// Settings: what the free game covers.
  ///
  /// In en, this message translates to:
  /// **'Unlimited careers, every nation, ten save slots and every future update. Thank you.'**
  String get settingsUnlockedBlurb;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
