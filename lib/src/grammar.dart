library svg.src.grammar;

import 'package:petitparser/petitparser.dart';

/// An implementation of the the [WC3 SVG Path Grammar]
/// (http://www.w3.org/TR/SVG/paths.html) for Dart.
class SvgGrammarDefinition extends GrammarDefinition {
  const SvgGrammarDefinition();

  @override
  start() => svgPath();

  /// wsp* moveto-drawto-command-groups? wsp*
  svgPath() =>
      whitespace().star() &
      moveToDrawToCommandGroups().optional() &
      whitespace().star();

  /// moveto-drawto-command-group
  /// | moveto-drawto-command-group comma-or-wsp? moveto-drawto-command-groups
  moveToDrawToCommandGroups() =>
      (moveToDrawToCommandGroup() &
          commaOrWhitespace().optional() &
          ref(moveToDrawToCommandGroups))
      | moveToDrawToCommandGroup();

  /// moveto comma-or-wsp? drawto-commands?
  moveToDrawToCommandGroup() =>
      moveTo() & commaOrWhitespace().optional() & drawToCommands();

  /// drawto-command
  /// | drawto-command comma-or-wsp? drawto-commands
  drawToCommands() =>
      (drawToCommand() & commaOrWhitespace().optional() & ref(drawToCommands))
      | drawToCommand();

  /// closepath
  /// | lineto
  /// | horizontal-lineto
  /// | vertical-lineto
  /// | curveto
  /// | smooth-curveto
  /// | quadratic-bezier-curveto
  /// | smooth-quadratic-bezier-curveto
  /// | elliptical-arc
  drawToCommand() =>
    lineTo() |
    horizontalLineTo() |
    verticalLineTo() |
    closePath() |
    cubicBezierLineTo() |
    quadraticBezierLineTo();

  /// ( "M" | "m" ) comma-or-wsp? moveto-argument-sequence
  moveTo() => pattern('Mm') & commaOrWhitespace().optional() & pointToArgumentSequence();

  /// ( "Z" | "z" )
  closePath() => pattern('Zz');

  /// ( "L" | "l" ) comma-or-wsp? pointto-argument-sequence
  lineTo() => pattern('Ll') & commaOrWhitespace().optional() & pointToArgumentSequence();

  /// ("H" | "h" ) comma-or-wsp? singlearg-pointto-argument-sequence
  horizontalLineTo() => pattern('Hh') & commaOrWhitespace().optional() & halfPointToArgumentSequence();

  /// ("V" | "v" ) comma-or-wsp? singlearg-pointto-argument-sequence
  verticalLineTo() => pattern('Vv') & commaOrWhitespace().optional() & halfPointToArgumentSequence();

  /// ("Q" | "q") comma-or-wsp? double-pointto-argument-sequence
  quadraticBezierLineTo() => pattern('Qq') & commaOrWhitespace().optional() & doublePointToArgumentSequence();

  /// ("C" | "c") comma-or-wsp? triple-pointto-argument-sequence
  cubicBezierLineTo() => pattern('Cc') & commaOrWhitespace().optional() & triplePointToArgumentSequence();

  /// coordinate | coordinate comma-or-wsp? & horizontal-lineto-argument-sequence
  halfPointToArgumentSequence() =>
      (coordinate() &
          commaOrWhitespace().optional() &
          ref(halfPointToArgumentSequence))
      | coordinate();

  /// coordinate-pair
  /// | coordinate-pair comma-or-wsp? pointto-argument-sequence
  pointToArgumentSequence() =>
      (coordinatePair() &
          commaOrWhitespace().optional() &
          ref(pointToArgumentSequence))
      | coordinatePair();

  /// coordinate-pair comma-or-wsp? coordinate-pair
  /// | coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? double-pointto-argument-sequence
  doublePointToArgumentSequence() =>
      (coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair() &
          commaOrWhitespace().optional() &
          ref(doublePointToArgumentSequence))
      | (coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair());

  /// coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? coordinate-pair
  /// | coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? triple-pointto-argument-sequence
  triplePointToArgumentSequence() =>
      (coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair() &
          commaOrWhitespace().optional() &
          ref(triplePointToArgumentSequence))
      | (coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair() &
          commaOrWhitespace().optional() &
          coordinatePair());

  /// coordinate comma-or-wsp? coordinate
  coordinatePair() =>
      coordinate() & commaOrWhitespace().optional() & coordinate();

  /// number
  coordinate() => number();

  /// integer-constant
  /// | floating-point-constant
  nonNegativeNumber() => floatingPointConstant() | integerConstant();

  /// sign? integer-constant
  /// | sign? floating-point-constant
  number() =>
      sign().optional() & floatingPointConstant()
      | sign().optional() & integerConstant();

  /// "0" | 1
  flag() => pattern('01');

  /// (wsp+ comma? wsp*) | (comma wsp*)
  commaWhitespace() =>
      (comma() & whitespace().star())
      | (whitespace().plus() & comma().optional() & whitespace().star());

  /// (wsp+) | (commaWhitespace)
  commaOrWhitespace() =>
      whitespace().plus()
      | commaWhitespace();

  /// ","
  comma() => char(',');

  /// digit-sequence
  integerConstant() => digitSequence();

  /// fractional-constant exponent?
  /// | digit-sequence exponent
  floatingPointConstant() =>
      fractionalConstant() & exponent().optional()
      | digitSequence() & exponent();

  /// digit-sequence? "." digit-sequence
  /// | digit-sequence "."
  fractionalConstant() =>
      (digitSequence().optional() & char('.') & digitSequence())
      | (digitSequence() & char('.'));

  /// ( "e" | "E" ) sign? digit-sequence
  exponent() => pattern('eE') & sign().optional() & digitSequence();

  /// "+" | "-"
  sign() => pattern('+-');

  /// digit
  /// | digit digit-sequence
  digitSequence() =>  digit().plus().flatten();
}
