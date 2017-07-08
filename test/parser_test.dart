library svg.test.parser_test;

import 'dart:math';

import 'package:svg/svg.dart' as svg;
import 'package:svg/src/command.dart';
import 'package:svg/src/parser.dart';
import 'package:test/test.dart';

void main() {
  group('SvgParserDefinition', () {
    final definition = const SvgParserDefinition();

    group('Fractional constants', () {
      final parseFraction = definition.floatingPointConstant().parse;

      test('can parse without leading zero', () {
        expect(parseFraction('.05').value, 0.05);
      });

      test('can parse with leading zero', () {
        expect(parseFraction('0.05').value, 0.05);
      });

      test('can parse without any leading digits', () {
        expect(parseFraction('5.').value, 5.0);
      });
    });

    group('Floating point constants', () {
      final parseFloat = definition.floatingPointConstant().parse;

      test('can parse with a fraction', () {
        expect(parseFloat('1.05').value , 1.05);
      });

      test('can parse with digits and an exponent', () {
        expect(parseFloat('12e5').value, 12e5);
      });

      test('can parse with a fraction and leading exponent', () {
        expect(parseFloat('0.05e5').value, 0.05e5);
      });
    });

    group('Integer constants', () {
      final parseInt = definition.integerConstant().parse;

      test('can parse a single digit', () {
        expect(parseInt('5').value, 5);
      });

      test('can parse multiple digits', () {
        expect(parseInt('123').value, 123);
      });
    });

    group('Number', () {
      final parseNum = definition.number().parse;

      test('can parse a positive number', () {
        expect(parseNum('5').value, 5);
      });

      test('can parse a negative number', () {
        expect(parseNum('-5').value, -5);
      });
    });

    group('Non-negative number', () {
      final parseNonNegative = definition.nonNegativeNumber().parse;

      test('can parse an integer', () {
        expect(parseNonNegative('50').value, 50);
      });

      test('can parse a float', () {
        expect(parseNonNegative('1.05').value , 1.05);
      });
    });

    group('Coordinate pair', () {
      final parseCoordinatePair = definition.coordinatePair().parse;

      test('can parse single digits', () {
        expect(parseCoordinatePair('5,5').value, const Point(5, 5));
      });

      test('can parse multiple digits', () {
        expect(parseCoordinatePair('12,-12').value, const Point(12, -12));
      });
    });

    group('Line to', () {
      final parseLine = definition.build(
            start: definition.lineTo)
            .parse;

      test('can parse a single line', () {
        expect(
            parseLine('l5,5').value,
            [const SvgPathLineSegment(5, 5, isRelative: true)]);
      });

      test('can parse a single line with fractional values', () {
        expect(
            parseLine('l1.2,3').value,
            [const SvgPathLineSegment(1.2, 3, isRelative: true)]);
      });

      test('can parse multiple line values', () {
        expect(
            parseLine('l1,1,2,2').value, [
              const SvgPathLineSegment(1, 1, isRelative: true),
              const SvgPathLineSegment(2, 2, isRelative: true)
            ]);
      });
    });

    group('Move to', () {
      final parseMove = definition.build(
          start: definition.moveTo)
          .parse;

      test('can parse a simple command', () {
        expect(
            parseMove('m5,5').value,
            [const SvgPathMoveSegment(5, 5)]);
      });

      test('can parse a simple command using space', () {
        expect(
          parseMove('m5 5').value,
          [const SvgPathMoveSegment(5, 5)]);
      });

      test('can parse followed by additional moves', () {
        expect(
            parseMove('m0,0,5,5').value,
            [
              const SvgPathMoveSegment(0, 0),
              const SvgPathMoveSegment(5, 5)
            ]);
      });
    });

    group('Draw to', () {
      final parseDraw = definition.build(
          start: definition.drawToCommand)
          .parse;

      test('can parse a close path', () {
        expect(parseDraw('z').value, [const SvgPathClose()]);
      });

      test('can parse a line to', () {
        expect(parseDraw('l5,5').value, [
          const SvgPathLineSegment(5, 5, isRelative: true)
        ]);
      });
    });

    group('Draw to (multiple)', () {
      final parseDraws = definition.build(
          start: definition.drawToCommands)
          .parse;

      test('can parse multiple lines, then a close', () {
        expect(parseDraws('L15,15L14,14z').value, [
          const SvgPathLineSegment(15, 15),
          const SvgPathLineSegment(14, 14),
          const SvgPathClose()
        ]);
      });

      test('can parse multiple lines with fractional values', () {
        expect(parseDraws('L5.5,4.4L3.3,2.2z').value, [
          const SvgPathLineSegment(5.5, 4.4),
          const SvgPathLineSegment(3.3, 2.2),
          const SvgPathClose()
        ]);
      });

      test('can parse multiple lines with space inbetween', () {
        expect(parseDraws('L8,9 L8,7z').value, [
          const SvgPathLineSegment(8, 9),
          const SvgPathLineSegment(8, 7),
          const SvgPathClose()
        ]);
      });

      test('can parse multiple lines with no separator', () {
        expect(parseDraws('L5.5,4.4 3.3,2.2 1.1,0.0z').value, [
          const SvgPathLineSegment(5.5, 4.4),
          const SvgPathLineSegment(3.3, 2.2),
          const SvgPathLineSegment(1.1, 0.0),
          const SvgPathClose()
        ]);
      });

      test('parse relative', () {
        expect(parseDraws('L0,0l10,5z').value, [
          const SvgPathLineSegment(0, 0, isRelative: false),
          const SvgPathLineSegment(10, 5, isRelative: true),
          const SvgPathClose()
        ]);
      });
    });

    group('Move to draw to command', () {
      final parseDraw = definition.build(
          start: definition.moveToDrawToCommandGroup)
          .parse;

      test('can parse a move/draw command', () {
        expect(
            parseDraw('M1,2L3,4').value,
            const [
              const SvgPathMoveSegment(1, 2),
              const SvgPathLineSegment(3, 4)
            ]);
      });

      test('can parse a move/draw command with a comma in between', () {
        expect(
            parseDraw('M1,2,L3,4').value,
            const [
              const SvgPathMoveSegment(1, 2),
              const SvgPathLineSegment(3, 4)
            ]);
      });

      test('can parse a move/draw command with a space in between', () {
        expect(
          parseDraw('M1,2 L3,4').value,
          const [
            const SvgPathMoveSegment(1, 2),
            const SvgPathLineSegment(3, 4)
          ]);
      });
    });

    group('Horizontal draw to command', () {
      final parseDraw = definition.build(
        start: definition.drawToCommand)
        .parse;

      test('can parse a horizontal line to command', () {
        expect(
          parseDraw('H1').value,
          const [
            const SvgPathLineSegment(1, null, isRelative: false)
          ]);
      });

      test('can parse a relative horizontal line to command', () {
        expect(
          parseDraw('h2').value,
          const [
            const SvgPathLineSegment(2, null, isRelative : true)
          ]);
      });

      test('can parse a horizontal line with whitespace', () {
        expect(
          parseDraw('H 3').value,
          const [
            const SvgPathLineSegment(3, null)
          ]);
      });
    });

    group('Horizontal draw to (multiple)', () {
      final parseDraws = definition.build(
        start: definition.drawToCommands)
        .parse;

      test('can parse multiple horizontal draws with a close', () {
        expect(
          parseDraws('h1H2z').value,
          const [
            const SvgPathLineSegment(1, null, isRelative: true),
            const SvgPathLineSegment(2, null, isRelative: false),
            const SvgPathClose()
          ]);
      });

      test('can parse multiple horizontal draws with space inbetween', () {
        expect(
          parseDraws('H3 H5z').value,
          const [
            const SvgPathLineSegment(3, null),
            const SvgPathLineSegment(5, null),
            const SvgPathClose()
          ]);
      });

      test('can parse two horizontal draws with no specifier', () {
        expect(
          parseDraws('H1-2z').value,
          const[
            const SvgPathLineSegment(1, null),
            const SvgPathLineSegment(-2, null),
            const SvgPathClose()
          ]);
      });

      test('can parse multiple horizontal draws with no specifier', () {
        expect(
          parseDraws('H7.5 -8.1 -3z').value,
          const[
            const SvgPathLineSegment(7.5, null),
            const SvgPathLineSegment(-8.1, null),
            const SvgPathLineSegment(-3, null),
            const SvgPathClose()
          ]);
      });
    });

    group('Vertical draw to command', () {
      final parseDraw = definition.build(
        start: definition.drawToCommand)
        .parse;

      test('can parse a vertical line to command', () {
        expect(
          parseDraw('V1').value,
          const [
            const SvgPathLineSegment(null, 1, isRelative: false)
          ]);
      });

      test('can parse a relative vertical line to command', () {
        expect(
          parseDraw('v2').value,
          const [
            const SvgPathLineSegment(null, 2, isRelative : true)
          ]);
      });

      test('can parse a vertical line with whitespace', () {
        expect(
          parseDraw('V 3').value,
          const [
            const SvgPathLineSegment(null, 3)
          ]);
      });
    });

    group('Vertical draw to (multiple)', () {
      final parseDraws = definition.build(
        start: definition.drawToCommands)
        .parse;

      test('can parse multiple vertical draws with a close', () {
        expect(
          parseDraws('v1V2z').value,
          const [
            const SvgPathLineSegment(null, 1, isRelative: true),
            const SvgPathLineSegment(null, 2, isRelative: false),
            const SvgPathClose()
          ]);
      });

      test('can parse multiple vertical draws with space inbetween', () {
        expect(
          parseDraws('V3 V5z').value,
          const [
            const SvgPathLineSegment(null, 3),
            const SvgPathLineSegment(null, 5),
            const SvgPathClose()
          ]);
      });

      test('can parse two vertical draws with no specifier', () {
        expect(
          parseDraws('V1-2z').value,
          const[
            const SvgPathLineSegment(null, 1),
            const SvgPathLineSegment(null, -2),
            const SvgPathClose()
          ]);
      });

      test('can parse multiple vertical draws with no specifier', () {
        expect(
          parseDraws('V7.5 -8.1 -3z').value,
          const[
            const SvgPathLineSegment(null, 7.5),
            const SvgPathLineSegment(null, -8.1),
            const SvgPathLineSegment(null, -3),
            const SvgPathClose()
          ]);
      });
    });

    group('Quadratic Curve Draw To', () {
      final parseDraw = definition.build(
        start: definition.drawToCommand)
        .parse;

      test('can parse a quadratic line to command', () {
        expect(
          parseDraw('Q 1.5,1.5 2,2').value,
          const[
            const SvgPathCurveQuadraticSegment(2, 2, 1.5, 1.5)
          ]);
      });

      test('can parse a relative quadratic line', () {
        expect(
          parseDraw('q1 2 3 4').value,
          const [
            const SvgPathCurveQuadraticSegment(3, 4, 1, 2, isRelative: true)
          ]);
      });
    });

    group('Quadratic Curve Draw To (Multiple)', () {
      final parseDraws = definition.build(
        start: definition.drawToCommands)
        .parse;

      test('can parse multiple curves with only one specifier', () {
        expect(
          parseDraws('Q1 2 3 4 5 6 7 8z').value,
          const [
            const SvgPathCurveQuadraticSegment(3, 4, 1, 2),
            const SvgPathCurveQuadraticSegment(7, 8, 5, 6),
            const SvgPathClose()
          ]);
      });

      test('can parse parse multiple curves with multiple specifiers', () {
        expect(
          parseDraws('Q1 2 3 4 q1.2,3.4 5.6,78z').value,
          const [
            const SvgPathCurveQuadraticSegment(3, 4, 1, 2),
            const SvgPathCurveQuadraticSegment(5.6, 78, 1.2, 3.4, isRelative: true),
            const SvgPathClose()
          ]);
      });
    });

    group('Cubic Curve Draw To', () {
      final parseDraw = definition
        .build(
        start: definition.drawToCommand)
        .parse;

      test('can parse a cubic line to command', () {
        expect(
          parseDraw('C 1.5,1.5 2,2 3,3').value,
          const[
            const SvgPathCurveCubicSegment(3, 3, 1.5, 1.5, 2, 2)
          ]);
      });
    });

    group('Cubic Curve Draw To (Multiple)', () {
      final parseDraws = definition.build(
        start: definition.drawToCommands)
        .parse;

      test('can parse multiple curves with only one specifier', () {
        expect(
          parseDraws('C1,2 3,4 5,6 7,8,9,10,11,12').value,
          const [
            const SvgPathCurveCubicSegment(5, 6, 1, 2, 3, 4),
            const SvgPathCurveCubicSegment(11, 12, 7, 8, 9, 10)
          ]);
      });

      test('can parse multiple curves with multiple specifiers', () {
        expect(
          parseDraws('C 1.1 2.2 3.3 4.4 5.5 6.6 c1,2,3,4,5,6z').value,
          const [
            const SvgPathCurveCubicSegment(5.5, 6.6, 1.1, 2.2, 3.3, 4.4, isRelative: false),
            const SvgPathCurveCubicSegment(5, 6, 1, 2, 3, 4, isRelative: true),
            const SvgPathClose()
          ]);
      });
    });

    group('Path', () {
      final parseSvgPath = definition.build(
          start: definition.moveToDrawToCommandGroups)
          .parse;

      test('can parse a path', () {
        // This is a shape path for drawing an up-arrow :)
        expect(parseSvgPath('M0,15,L15,15L7.5,0z').value, const [
          const SvgPathMoveSegment(0, 15),
          const SvgPathLineSegment(15, 15),
          const SvgPathLineSegment(7.5, 0),
          const SvgPathClose()
        ]);
      });
    });
  });

  test('parseSvgPath works as intended', () {
    expect(svg.parseSvgPath('M0,15,L15,15L7.5,0z'), const [
      const SvgPathMoveSegment(0, 15),
      const SvgPathLineSegment(15, 15),
      const SvgPathLineSegment(7.5, 0),
      const SvgPathClose()
    ]);
  });
}
