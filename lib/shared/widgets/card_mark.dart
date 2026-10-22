import 'package:flutter/material.dart';
import 'package:fnm/domain/services/match/card_status.dart';

/// The referee's yellow and red, as every in-match screen draws them.
const Color kYellowCardColor = Color(0xFFEFC94C);
const Color kRedCardColor = Color(0xFFD64545);

/// A player's card: the mark the match timeline has always drawn for a
/// booking or a sending-off, lifted out so the pitch and the substitution
/// lists draw the SAME mark. A second booking shows both cards, the way it
/// happened — the yellow he was already on with the red overlapping in front.
///
/// [size] is the red's (or the single card's) size; the timeline's 16 is the
/// default. [onKit] adds a dark halo for a mark sitting on a player's ball,
/// where a yellow on a yellow shirt would otherwise vanish.
class CardMark extends StatelessWidget {
  const CardMark(this.card, {this.size = 16, this.onKit = false, super.key});

  final MatchCard card;
  final double size;
  final bool onKit;

  Icon _card(Color color, double size) => Icon(
    Icons.square_rounded,
    size: size,
    color: color,
    shadows: onKit ? const [Shadow(blurRadius: 2)] : null,
  );

  @override
  Widget build(BuildContext context) => switch (card) {
    MatchCard.yellow => _card(kYellowCardColor, size),
    MatchCard.red => _card(kRedCardColor, size),
    MatchCard.secondYellow => SizedBox(
      width: size * 22 / 16,
      height: size,
      child: Stack(
        children: [
          Positioned(left: 0, child: _card(kYellowCardColor, size * 14 / 16)),
          Positioned(right: 0, child: _card(kRedCardColor, size)),
        ],
      ),
    ),
  };
}
