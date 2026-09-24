# Press and feed: depth, and questions that know who is playing

**Status:** spec, awaiting approval
**Reported by:** two playtesters, 2026-09-24

> "press and tweets is too general"
> "som druhý v skupine a postupil som ale novinári sa ma pýtajú kedy rezignujem,
> vlastne celkovo tie novinárske otázky boli mimo a furt ma vyzývali odstúpiť"

## Two problems, not one

**The tone misfires.** `underPressure` fires on three competitive games without
a win, where "without a win" is `forGoals <= against`, so draws count. Qualify
second with two draws and it fires. Worse, topics are gathered INDEPENDENTLY
(`press_providers.dart`): nothing says that qualifying silences "when will you
resign", so both questions land in the same conference. This is a bug and is
fixed regardless of the rest.

**The press cannot see people.** All fifteen `PressTopic` values read the
scoreboard. Not one knows a player's name, a selection decision, a sending-off
or an opponent. That is what "too general" means: the only thing a journalist
can ask about is the score, so every conference is the same conference with a
different number in it. The Y feed has the same ceiling — its personas are good
(seven traits, a recurring cast, derived stance, tone bands) and they are all
reacting to a scoreline.

So this is not "write more copy". It is giving the press and the feed access to
the squad and the match, which they have never had.

## Decisions taken

- **Three questions per conference**, kept, but each carrying specifics.
- **New subject areas:** players and selection, match incidents, opponent and
  rivalry. Clubs and transfers explicitly OUT of scope for now.
- **Consequences unchanged.** Answers keep the weight they have today; this
  work is about what is asked, not about what it costs.

## A. The suppression fix

Topics gain a precedence relation: a topic may SILENCE others in the same
window. A conference then never contradicts itself.

    qualified  silences underPressure, crisis, missedOut
    triumph    silences underPressure, crisis, luckyWin
    bigWin     silences luckyWin

Stated as data beside `PressTopic`, not as `if`s at the call sites, so adding a
topic means adding a row rather than auditing the selector.

Separately, the winless test stops counting a draw that came with qualification
attached.

## B. Subjects

A new `PressSubject`, carried by a question alongside its topic:

    team                  the side, as now
    player(playerId)      a named man
    opponent(nationId)    the next or last opponent
    incident(event)       one thing that happened, with its minute

Copy for a subject-bearing topic takes ARGUMENTS. This is the whole difference:

    before:  "How do you respond to the criticism?"
    after:   "Hayes walked in the 34th minute and you went out with ten.
              His mistake, or yours for playing him on a yellow?"

## C. The new topics

**Players and selection** — reads the squad, the call-ups, the captain and
career stats, all of which already exist.

    strikerDrought        your first-choice forward, N caps without a goal
    youngsterBreakthrough  a young or uncapped man who just had a big game
    droppedStar           a high-rated player left out of the XI
    captaincyQuestion     a new captain, or one out of form
    veteranEnd            a 34+ regular whose level is going
    debutant              a first cap

**Match incidents** — reads `MatchResult.events` (`goal`, `yellowCard`,
`redCard`, `injury`, `substitution`), which the press has never opened.

    sendingOff            a red card: who, what minute, what it cost
    injuryBlow            a key man hurt, sharper before a tournament
    shootoutFate          settled on penalties, won or lost
    lateDrama             a goal for or against inside the last ten minutes

**Opponent and rivalry** — reads `rivalryProvider` and the head-to-head record.

    rivalryNext           the next match is against a rival
    headToHeadRun         a long unbeaten or winless run against them
    revengeMatch          facing the side that put you out last time

Thirteen new topics against fifteen existing.

## D. The feed gets the same subjects

`y_feed.dart` takes the same `PressSubject` values, so the cast reacts to a
sending-off, a debutant and a rival by name, through the personas and tone
bands that are already built. A cynic on a red card and a loyalist on the same
red card are different posts; today neither can see it happened.

## Selection, so three questions stay three good questions

When more topics qualify than there are slots, prefer, in order:

1. an `incident` from the most recent match
2. a `player` subject
3. an `opponent` subject
4. a `team` subject

so that a conference leads with the thing that actually just happened, and the
generic team question is the filler rather than the whole card.

## Out of scope

Clubs and transfers as a subject. Changing what an answer costs. Any new
consequence system.

## Testing

- The reported misfire gets a test by name: qualified second with draws, and
  the conference must not ask about resigning.
- Every new topic gets a selection test: it fires when it should and does not
  when it should not.
- Copy width at 320/360/400 in both languages, as everything else here.
- A guard that every `PressTopic` has copy in both arbs, so a topic cannot ship
  with an empty question.
