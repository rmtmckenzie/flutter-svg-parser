library svg.test.grammar_test;

import 'package:petitparser/petitparser.dart';
import 'package:svg/src/grammar.dart';
import 'package:test/test.dart';

void main() {
  group('SvgGrammarDefinition', () {
    final definition = const SvgGrammarDefinition();
    ;

    group('Digits', () {
      final parseDigits = definition
        .digitSequence()
        .parse;

      test('can parse a single digit', () {
        expect(parseDigits('5').value, '5');
      });

      test('can parse multiple digits', () {
        expect(parseDigits('321').value, '321');
      });
    });

    group('Exponents', () {
      final parseExponent = definition
        .exponent()
        .parse;

      test('can parse a positive exponent', () {
        expect(parseExponent('e+50').value, ['e', '+', '50']);
      });

      test('can parse a negative exponent', () {
        expect(parseExponent('E-10').value, ['E', '-', '10']);
      });
    });

    group('Fractional constants', () {
      final parseFraction = definition
        .fractionalConstant()
        .parse;
      final acceptFraction = definition
        .fractionalConstant()
        .accept;

      test('can parse without leading zero', () {
        expect(parseFraction('.05').value, ['.', '05']);
      });

      test('can parse with leading zero', () {
        expect(parseFraction('0.05').value, ['0', '.', '05']);
      });

      test('can parse without any leading digits', () {
        expect(parseFraction('5.').value, ['5', '.']);
      });

      test('does not accept without a "."', () {
        expect(acceptFraction('10e5'), isFalse);
      });
    });

    group('Floating point constants', () {
      final parseFloat = definition
        .floatingPointConstant()
        .parse;

      test('can parse with a fraction', () {
        expect(parseFloat('1.05').value, ['1', '.', '05']);
      });

      test('can parse with digits and an exponent', () {
        expect(parseFloat('12e5').value, ['12', ['e', '5']]);
      });

      test('can parse with a fraction and leading exponent', () {
        expect(
          parseFloat('0.05e5').value,
          [['0', '.', '05'], ['e', '5']]);
      });
    });

    group('Integer constant', () {
      final parseInt = definition
        .integerConstant()
        .parse;

      test('can parse a single digit', () {
        expect(parseInt('5').value, '5');
      });

      test('can parse multiple digits', () {
        expect(parseInt('123').value, '123');
      });
    });

    group('Comma and whitespace', () {
      final parseCommaWsp = definition
        .commaWhitespace()
        .parse;

      test('can parse simple case', () {
        expect(parseCommaWsp(' , ').value, [[' '], ',', [' ']]);
      });

      test('can parse without whitespace', () {
        expect(parseCommaWsp(',').value, ',');
      });

      test('can parse without a comma', () {
        expect(parseCommaWsp(' ').value, [' ']);
      });
    });

    group('Number', () {
      final parseNum = definition
        .number()
        .parse;

      test('can parse a positive number', () {
        expect(parseNum('5').value, '5');
      });

      test('can parse a negative number', () {
        expect(parseNum('-5').value, ['-', '5']);
      });
    });

    group('Non-negative number', () {
      final parseNonNegative = definition
        .nonNegativeNumber()
        .parse;

      test('can parse an integer', () {
        expect(parseNonNegative('50').value, '50');
      });

      test('can parse a float', () {
        expect(parseNonNegative('1.05').value, ['1', '.', '05']);
      });
    });

    group('Coordinate pair', () {
      final parseCoordinatePair = definition
        .coordinatePair()
        .parse;

      test('can parse single digits', () {
        expect(
          parseCoordinatePair('5,5').value,
          ['5', ',', '5']);
      });

      test('can parse multiple digits', () {
        expect(
          parseCoordinatePair('12,-12').value,
          ['12', ',', ['-', '12']]);
      });
    });

    group('Line to', () {
      final parseLine = definition
        .build(
        start: definition.lineTo)
        .parse;

      test('can parse a single line', () {
        expect(
          parseLine('l5,5').value,
          ['l', [['5', ',', '5']]]);
      });

      test('can parse a fractional value single line', () {
        expect(parseLine('l1.2,3').value,
          ['l', [
            [['1', '.', '2'], ',', '3']
          ]]);
      });

      test('can parse multiple line values', () {
        expect(parseLine('l1,1,2,2').value,
          [
            'l',
            [['1', ',', '1'], [',', ['2', ',', '2']]]
          ]);
      });
    });

    group('Move to', () {
      final parseMove = definition
        .build(
        start: definition.moveTo)
        .parse;

      test('can parse a simple command', () {
        expect(
          parseMove('m5,5').value,
          ['m', [['5', ',', '5']]]);
      });

      test('can parse followed by additional moves', () {
        expect(
          parseMove('M0,0,5,5').value,
          ['M', [['0', ',', '0'], [',', ['5', ',', '5']]]]);
      });
    });

    group('Draw to', () {
      final parseDraw = definition
        .build(
        start: definition.drawToCommand)
        .parse;

      test('can parse a close path', () {
        expect(parseDraw('z').value, 'z');
      });

      test('can parse a line to', () {
        expect(
          parseDraw('l5,5').value,
          ['l', [['5', ',', '5']]]);
      });
    });

    group('Draw to (multiple)', () {
      final parseDraws = definition
        .build(
        start: definition.drawToCommands)
        .parse;

      test('can parse multiple lines, then a close', () {
        expect(parseDraws('L15,15L14,14z').value,
          [['L', [['15', ',', '15']]], ['L', [['14', ',', '14']]], 'z']);
      });

      test('can parse multiple lines with fractional values', () {
        expect(parseDraws('L5.5,4.4L3.3,2.2z').value, [
          ['L', [[['5', '.', '5'], ',', ['4', '.', '4']]]],
          ['L', [[['3', '.', '3'], ',', ['2', '.', '2']]]],
          'z'
        ]);
      });
    });

    group('Horizontal Draw to', () {
      final parseDraw = definition
        .build(
        start: definition.horizontalLineTo)
        .parse;

      test('Can parse a simple horizontal command', () {
        expect(
          parseDraw('h10').value,
          ['h', ['10']]);
      });

      test('Can parse a multiple horizontal command', () {
        expect(
          parseDraw('h10 20,30').value,
          ['h', ['10', [[' '], '20'], [',', '30']]]);
      });
    });

    group('Vertical Draw to', () {
      final parseDraw = definition
        .build(
        start: definition.verticalLineTo)
        .parse;

      test('Can parse a simple vertical command', () {
        expect(
          parseDraw('v12').value,
          ['v', ['12']]);
      });

      test('Can parse multiple vertical commands', () {
        expect(
          parseDraw('V10 20').value,
          ['V', ['10', [[' '], '20']]]);
      });
    });

    group('Quadratic Draw to', () {
      final parseDraw = definition
        .build(
        start: definition.quadraticBezierLineTo)
        .parse;

      test('Can parse a simple quadratic draw command', () {
        expect(
          parseDraw('Q6,2 7,6').value, ['Q', [[['6', ',', '2'], [[' '], ['7', ',', '6']]]]]);
      });

      test('Can parse a double quadratic draw commands', () {
        expect(
          parseDraw('Q1.1,2.2,3.3,4.4,5,6,7,8').value, [
          'Q',
          [
            [
              [['1', '.', '1'], ',', ['2', '.', '2']],
              [',', [['3', '.', '3'], ',', ['4', '.', '4']]]
            ],
            [[',', ['5', ',', '6']], [',', ['7', ',', '8']]]
          ]
        ]);
      });

      test('Can parse a triple quadratic draw command', () {
        expect(
          parseDraw('Q1,1 2,2  3,3 4,4  5,5 6,6').value,
          [
            'Q',
            [
              [['1', ',', '1'], [[' '], ['2', ',', '2']]],
              [[[' ', ' '], ['3', ',', '3']], [[' '], ['4', ',', '4']]],
              [[[' ', ' '], ['5', ',', '5']], [[' '], ['6', ',', '6']]]
            ]
          ]);
      });
    });

    group('Cubic draw to', () {
      final parseDraw = definition
        .build(
        start: definition.cubicBezierLineTo)
        .parse;

      test('Can parse a simple cubic draw command', () {
        expect(
          parseDraw('c1,1 2,2 3,3').value,
          ['c', [[['1', ',', '1'], [[' '], ['2', ',', '2']], [[' '], ['3', ',', '3']]]]]);
      });

      test('Can parse a double cubic draw command', () {
        expect(
          parseDraw('C0,1 2,3 4,5 6,7 8,9 10,11').value,
          [
            'C',
            [
              [['0', ',', '1'], [[' '], ['2', ',', '3']], [[' '], ['4', ',', '5']]],
              [
                [[' '], ['6', ',', '7']],
                [[' '], ['8', ',', '9']],
                [[' '], ['10', ',', '11']]
              ]
            ]
          ]);
      });

      test('Can parse a triple cubic draw command', () {
        expect(
          parseDraw('c1,1 2,2 3,3  4,4 5,5 6,6  7,7 8,8 9,9').value,
          [
            'c',
            [
              [
                ['1', ',', '1'],
                [[' '], ['2', ',', '2']],
                [[' '], ['3', ',', '3']]
              ],
              [
                [[' ', ' '], ['4', ',', '4']],
                [[' '], ['5', ',', '5']],
                [[' '], ['6', ',', '6']]
              ],
              [
                [[' ', ' '], ['7', ',', '7']],
                [[' '], ['8', ',', '8']],
                [[' '], ['9', ',', '9']]
              ]
            ]
          ]);
      });
    });

    group('Smooth quadtratic draw to command', () {
      final parseDraw = definition
        .build(start: definition.smoothQuadraticBezierLineTo).parse;

      test('can parse a smooth quadratic draw to command', () {
        expect(
          parseDraw('t1,2').value,
          [
            't',
            [
              ['1', ',', '2']
            ]
          ]
        );
      });

      test('can parse multiple smooth quadratic draw to commands', () {
        expect(
          parseDraw('T1,4 2,3 6,7.1').value,
          [
            'T',
            [
              ['1', ',', '4'],
              [[' '], ['2', ',', '3']],
              [[' '], ['6', ',', ['7', '.', '1']]]
            ]
          ]
        );
      });
    });

    group('Smooth cubic draw to command', () {
      final parseDraw = definition
        .build(start: definition.smoothCubicBezierLineTo).parse;

      test('can parse a smooth cubic draw to command', () {
        expect(
          parseDraw('S1,2 3,4').value,
          [
            'S',
            [
              [
                ['1', ',', '2'],
                [[' '], ['3', ',', '4']]
              ]
            ]
          ]
        );
      });

      test('can parse multiple smoth cubic draw to commands', () {
        expect(
          parseDraw('S 1 2 3 4, 5 6 7 8').value,
          [
            'S',
            [
              [
                [[' '], ['1', [' '], '2']],
                [[' '], ['3', [' '], '4']]
              ],
              [
                [[',', [' ']], ['5', [' '], '6']],
                [[' '], ['7', [' '], '8']]
              ]
            ]
          ]
        );
      });
    });

    group('Move to draw to command', () {
      final parseDraw = definition
        .build(start: definition.moveToDrawToCommandGroup).parse;

      test('can parse a move/draw command', () {
        expect(
          parseDraw('M1,2L3,4').value,
          ['M', [['1', ',', '2']], [['L', [['3', ',', '4']]]]]);
      });

      test('can parse a move/draw command with a comma in between', () {
        expect(
          parseDraw('M1,2,L3,4').value,
          ['M', [['1', ',', '2']], [[',', ['L', [['3', ',', '4']]]]]]);
      });
    });

    group('Move to draw to command groups', () {
      final parseDraws = definition
        .build(
        start: definition.moveToDrawToCommandGroups)
        .parse;

      test('can parse a move/draw command', () {
        expect(
          parseDraws('M1,2L3,4M5,6L7,8').value,
          [
            ['M', [['1', ',', '2']], [['L', [['3', ',', '4']]]]],
            ['M', [['5', ',', '6']], [['L', [['7', ',', '8']]]]]
          ]);
      });
    });

    group('Path', () {
      final parseSvgPath = definition
        .build(
        start: definition.moveToDrawToCommandGroups)
        .parse;

      test('can parse a path', () {
        // This is a shape path for drawing an up-arrow :)
        expect(
          parseSvgPath('M0,15,L15,15L7.5,0z').value,
          [
            [
              'M',
              [['0', ',', '15']],
              [
                [',', ['L', [['15', ',', '15']]]],
                ['L', [[['7', '.', '5'], ',', '0']]],
                'z'
              ]
            ]
          ]);
      });

      test('can parse a slightly poorly formatted path', () {
        expect(
          parseSvgPath('M1,1 ,C14,12,13,14,15,16').value,
          [
            [
              'M',
              [['1', ',', '1']],
              [[
                  [[' '], ','],
                  [
                    'C',
                    [
                      [
                        ['14', ',', '12'],
                        [',', ['13', ',', '14']],
                        [',', ['15', ',', '16']]
                      ]
                    ]
                  ]
                ]
              ]
            ]
          ]);
      });

      test('can parse a very poorly formatted path', () {
        expect(
          parseSvgPath('M1,1 , L14,12        4,3, L, 32.0 , 1  z').value,
          [
            [
              'M',
              [['1', ',', '1']],
              [
                [
                  [[' '], ',', [' ']],
                  [
                    'L',
                    [
                      ['14', ',', '12'],
                      [[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '], ['4', ',', '3']]
                    ]
                  ]
                ],
                [
                  [',', [' ']],
                  ['L', [[[',', [' ']], [['32', '.', '0'], [[' '], ',', [' ']], '1']]]]
                ],
                [[' ', ' '], 'z']
              ]
            ]
          ]);
      });

    });
  });
}
