library svg.src.parser;

import 'dart:math';

import 'package:svg/src/command.dart';
import 'package:svg/src/grammar.dart';
import 'package:quiver/iterables.dart';

class SvgParserDefinition extends SvgGrammarDefinition {
  const SvgParserDefinition();

  isUpper(String result) {
    String firstChar = result.substring(0,1);
    return firstChar == firstChar.toUpperCase();
  }

  firstIsUpper(List list) {
    if(list[0] is String) {
      return isUpper(list[0] as String);
    }
    return null;
  }

  @override
  svgPath() => super.svgPath().map((Iterable r) => r.toList(growable: false));

  @override
  moveToDrawToCommandGroup() => super.moveToDrawToCommandGroup().map((result) {
    result = result.where((r) => r != null);
    return concat(result);
  });

  @override
  drawToCommands() => super.drawToCommands().map((result) {
    return concat(result.where((r) => r != null).map((r) => r is Iterable ? r : [r]));
  });

  @override
  closePath() => super.closePath().map((_) => const [const SvgPathClose()]);

  @override
  moveTo() => super.moveTo().map((List result) {
    // Single move.
    if (result[2] is Point) {
      Point point = result[2];
      return [new SvgPathMoveSegment(point.x, point.y)];
    }

    // Multiple move.
    if (result[2] is Iterable) {
      return (result[2] as Iterable).where((e) => e is Point).map((Point p) {
        return new SvgPathMoveSegment(p.x, p.y);
      });
    }
  });

  @override
  lineTo() => super.lineTo().map((List result) {
    bool relative = !firstIsUpper(result);

    // Multiple lines.
    var list = new List<SvgPathLineSegment>();
    var third = result[2];

    while (!(third is Point)) {
      List iterResult = third as List;
      Point point = iterResult[0];
      list.add(new SvgPathLineSegment(point.x, point.y, isRelative: relative));
      third = iterResult[2];
    }

    Point point = third as Point;
    list.add(new SvgPathLineSegment(point.x, point.y, isRelative: relative));

    return new List.unmodifiable(list);
  });

  @override
  horizontalLineTo() => super.horizontalLineTo().map((List result) {
    bool relative = !firstIsUpper(result);

    var list = new List<SvgPathLineSegment>();
    var third = result[2];

    while(third is List) {
      List iterResult = third as List;
      num number = iterResult[0];
      list.add(new SvgPathLineSegment(number, null, isRelative: relative));
      third = iterResult[2];
    }

    num number = third as num;
    list.add(new SvgPathLineSegment(number, null, isRelative: relative));
    return new List.unmodifiable(list);
  });

  @override
  verticalLineTo() => super.verticalLineTo().map((List result) {
    bool relative = !firstIsUpper(result);

    var list = new List<SvgPathLineSegment>();
    var third = result[2];

    while(!(third is num)) {
      List iterResult = third as List;
      num number = iterResult[0];
      list.add(new SvgPathLineSegment(null, number, isRelative: relative));
      third = iterResult[2];
    }

    num number = third as num;
    list.add(new SvgPathLineSegment(null, number, isRelative: relative));
    return new List.unmodifiable(list);
  });

  @override
  quadraticBezierLineTo() => super.quadraticBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);
    List curveData = result[2];
    var list = new List<SvgPathCurveQuadraticSegment>();

    for(;;) {
      Point control = curveData[0];
      Point endpoint = curveData[2];
      list.add(new SvgPathCurveQuadraticSegment(endpoint.x, endpoint.y, control.x, control.y, isRelative: relative));

      if(curveData.length == 3) break;

      curveData = curveData[4];
    }

    return new List.unmodifiable(list);
  });

  @override
  cubicBezierLineTo() => super.cubicBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);
    List curveData = result[2];
    var list = new List<SvgPathCurveCubicSegment>();

    for(;;) {
      Point control1 = curveData[0];
      Point control2 = curveData[2];
      Point endpoint = curveData[4];
      list.add(new SvgPathCurveCubicSegment(endpoint.x, endpoint.y, control1.x, control1.y, control2.x, control2.y, isRelative: relative));

      if(curveData.length == 5) break;

      curveData = curveData[6];
    }

    return new List.unmodifiable(list);
  });


  @override
  coordinatePair() => super.coordinatePair().map((result) {
    return new Point(result[0], result[2]);
  });

  @override
  number() => super.number().map((result) {
    final sign = result[0];
    num number = result[1];
    if (sign == '-') {
      number = -number;
    }
    return number;
  });

  @override
  commaWhitespace() => super.commaWhitespace().map((_) => null);

  @override
  commaOrWhitespace() => super.commaOrWhitespace().map((_) => null);

  @override
  integerConstant() => super.integerConstant().flatten().map(int.parse);

  @override
  floatingPointConstant() {
    return super.floatingPointConstant().flatten().map(double.parse);
  }

  @override
  fractionalConstant() {
    return super.fractionalConstant().flatten().map(double.parse);
  }
}
