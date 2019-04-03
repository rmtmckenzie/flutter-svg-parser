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

  moveToDrawToCommandGroups() =>
    moveToDrawToCommandGroup().plus();

//  /// moveto-drawto-command-group
//  /// | moveto-drawto-command-group comma-or-wsp? moveto-drawto-command-groups
//  moveToDrawToCommandGroups() =>
//      (moveToDrawToCommandGroup() &
//          commaOrWhitespace().optional() &
//          ref(moveToDrawToCommandGroups))
//      | moveToDrawToCommandGroup();

  /// moveto comma-or-wsp? drawto-commands?
  moveToDrawToCommandGroup() =>
    (commaWhitespace() & moveTo() & drawToCommands())
    | (moveTo() & drawToCommands());

  drawToCommands() =>
    wcDrawToCommand().plus();

//  /// drawto-command
//  /// | drawto-command comma-or-wsp? drawto-commands
//  drawToCommands() =>
//      (drawToCommand() & commaOrWhitespace().optional() & ref(drawToCommands))
//      | drawToCommand();


  wcDrawToCommand() =>
    (commaWhitespace() & drawToCommand())
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
  drawToCommand() => (
    lineTo() |
    horizontalLineTo() |
    verticalLineTo() |
    closePath() |
    quadraticBezierLineTo() |
    cubicBezierLineTo() |
    smoothQuadraticBezierLineTo() |
    smoothCubicBezierLineTo() |
    arcTo()
  );

  /// ( "M" | "m" ) moveto-argument-sequence
  moveTo() => pattern('Mm') & pointToArgumentSequence();

  /// ( "Z" | "z" )
  closePath() => pattern('Zz');

  /// ( "L" | "l" ) pointto-argument-sequence
  lineTo() => pattern('Ll') &  pointToArgumentSequence();

  /// ("H" | "h" ) singlearg-pointto-argument-sequence
  horizontalLineTo() => pattern('Hh') & coordinateSequence();

  /// ("V" | "v" ) singlearg-pointto-argument-sequence
  verticalLineTo() => pattern('Vv') & coordinateSequence();

  /// ("Q" | "q") double-pointto-argument-sequence
  quadraticBezierLineTo() => pattern('Qq') & doublePointToArgumentSequence();

  /// ("C" | "c") triple-pointto-argument-sequence
  cubicBezierLineTo() => pattern('Cc') & triplePointToArgumentSequence();

  /// ("S" | "s") double-pointto-argument-sequence
  smoothCubicBezierLineTo() => pattern('Ss') & doublePointToArgumentSequence();

  /// ("T" | "t") pointto-argument-sequence
  smoothQuadraticBezierLineTo() => pattern('Tt') & pointToArgumentSequence();

  arcTo() => pattern('Aa') & arcToArgumentSequence();

  coordinateSequence() => wcCoordinate().plus();

//  /// coordinate | coordinate comma-or-wsp? & horizontal-lineto-argument-sequence
//  halfPointToArgumentSequence() =>
//      (coordinate() &
//          commaOrWhitespace().optional() &
//          ref(halfPointToArgumentSequence))
//      | coordinate();

//  /// coordinate-pair
//  /// | coordinate-pair comma-or-wsp? pointto-argument-sequence
//  pointToArgumentSequence() =>
//      (coordinatePair() &
//          commaOrWhitespace().optional() &
//          ref(pointToArgumentSequence))
//      | coordinatePair();

  pointToArgumentSequence() => (
    wcCoordinatePair()
  ).plus();

//  /// coordinate-pair comma-or-wsp? coordinate-pair
//  /// | coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? double-pointto-argument-sequence
//  doublePointToArgumentSequence() =>
//      (coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair() &
//          commaOrWhitespace().optional() &
//          ref(doublePointToArgumentSequence))
//      | (coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair());

  doublePointToArgumentSequence() => (
    wcCoordinatePair() & wcCoordinatePair()
  ).plus();

//  /// coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? coordinate-pair
//  /// | coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? coordinate-pair comma-or-wsp? triple-pointto-argument-sequence
//  triplePointToArgumentSequence() =>
//      (coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair() &
//          commaOrWhitespace().optional() &
//          ref(triplePointToArgumentSequence))
//      | (coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair() &
//          commaOrWhitespace().optional() &
//          coordinatePair());

  triplePointToArgumentSequence() => (
    wcCoordinatePair() & wcCoordinatePair() & wcCoordinatePair()
  ).plus();

  arcToArgumentSequence() => arcToArguments().plus();

  arcToArguments() => (
    wcCoordinatePair() & commaWhitespace().optional() &
    number() & commaWhitespace().optional() &
    flag() & commaWhitespace().optional() &
    flag() & wcCoordinatePair()
  );

  wcCoordinate() =>
    (commaWhitespace() & coordinate())
    | coordinate();

  wcCoordinatePair() =>
    (commaWhitespace() & coordinatePair())
    | coordinatePair();

  /// coordinate comma-or-wsp? coordinate
  coordinatePair() =>
    coordinate() & commaWhitespace().optional() & coordinate();

  /// number
  coordinate() => number();

  /// integer-constant
  /// | floating-point-constant
  nonNegativeNumber() => floatingPointConstant() | integerConstant();

  /// sign? integer-constant
  /// | sign? floating-point-constant
  number() =>
      sign() & floatingPointConstant()
      | sign() & integerConstant()
      | floatingPointConstant()
      | integerConstant();

  /// "0" | 1
  flag() => pattern('01');

  /// (wsp* comma wsp*)
  commaWhitespace() =>
      (whitespace().plus() & comma() & whitespace().plus())
      | (comma() & whitespace().plus())
      | (whitespace().plus() & comma())
      | whitespace().plus()
      | comma();

  /// ","
  comma() => char(',');

  /// digit-sequence
  integerConstant() => digitSequence();

  /// fractional-constant exponent?
  /// | digit-sequence exponent
  floatingPointConstant() =>
    (fractionalConstant() & exponent())
    | (digitSequence() & exponent())
    | fractionalConstant();

  /// digit-sequence? "." digit-sequence
  /// | digit-sequence "."
  fractionalConstant() =>
    (digitSequence() & char('.') & digitSequence())
    | (char('.') & digitSequence())
    | (digitSequence() & char('.'));

  /// ( "e" | "E" ) sign? digit-sequence
  exponent() =>
    (pattern('eE') & digitSequence())
    | (pattern('eE') & sign() & digitSequence());

  /// "+" | "-"
  sign() => pattern('+-');

  /// digit
  /// | digit digit-sequence
  digitSequence() =>  digit().plus().flatten();
}
