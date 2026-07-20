// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get matchPreviewTitle => 'MATCH PREVIEW';

  @override
  String get matchKickOff => 'Kick off';

  @override
  String get matchTactics => 'Tactics';

  @override
  String get matchYourXi => 'YOUR XI';

  @override
  String get matchHeadToHead => 'HEAD TO HEAD';

  @override
  String ceremonyWorldCupYear(int year) {
    return 'WORLD CUP $year';
  }

  @override
  String get ceremonyFinalsAreHere => 'THE FINALS ARE HERE';

  @override
  String ceremonyHostedBy(String hosts) {
    return 'HOSTED BY  $hosts';
  }

  @override
  String get ceremonyHostTbc => 'HOST TO BE CONFIRMED';

  @override
  String get matchHalfTime => 'HALF TIME';

  @override
  String get matchContinue => 'Continue';

  @override
  String matchTacticsWithSubs(int used, int max) {
    return 'Tactics · $used/$max subs';
  }

  @override
  String get teamTalkHeading => 'TEAM TALK';

  @override
  String get teamTalkPrompt => 'Set the tone for the second half.';

  @override
  String get teamTalkCalmLabel => 'Calm heads';

  @override
  String get teamTalkCalmBlurb => 'Steady the side — a small all-round lift.';

  @override
  String get teamTalkEncourageLabel => 'Encourage';

  @override
  String get teamTalkEncourageBlurb => 'Push forward and go for the game.';

  @override
  String get teamTalkDemandMoreLabel => 'Demand more';

  @override
  String get teamTalkDemandMoreBlurb => 'Throw everything at it — attack hard.';

  @override
  String get teamTalkPraiseLabel => 'Keep it tight';

  @override
  String get teamTalkPraiseBlurb => 'Stay compact and protect what you have.';
}
