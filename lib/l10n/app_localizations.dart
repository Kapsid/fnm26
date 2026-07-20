import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
