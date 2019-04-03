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
  moveToDrawToCommandGroups() => super.moveToDrawToCommandGroups().map((result) {
    return new List.unmodifiable((result as List).expand((x) => x));
  });

  @override
  moveToDrawToCommandGroup() => super.moveToDrawToCommandGroup().map((result) {
    if(result.length == 2) {
      return (result as List).expand((x) => x);
    } else {
      return result.sublist(1).expand((x) => x);
    }
  });



  @override
  drawToCommands() => super.drawToCommands().map((result) {
    return new List.unmodifiable((result as List).expand((x) => x));
  });

//  @override
//  drawToCommand() => super.drawToCommand().map((result) {
//    return result[0];
//  });

  @override
  wcDrawToCommand() => super.wcDrawToCommand().map((result) {
    if(result[0] == null && result.length == 2) {
      return result[1];
    } else {
      return result;
    }
  });

  @override
  closePath() => super.closePath().map((_) => const [const SvgPathClose()]);

  @override
  moveTo() => super.moveTo().map((List result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable((result[1] as List).cast<Point>().map((Point p) => new SvgPathMoveSegment(p.x, p.y, isRelative: relative)));
  });

  @override
  lineTo() => super.lineTo().map((List result) {
    bool relative = !firstIsUpper(result);
    return new List.unmodifiable(result[1].map((Point p) => new SvgPathLineSegment(p.x, p.y, isRelative: relative)));
  });

  @override
  horizontalLineTo() => super.horizontalLineTo().map((List result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable((result[1] as List).cast<num>().map((num n) => new SvgPathLineSegment(n, null, isRelative: relative)));
  });

  @override
  verticalLineTo() => super.verticalLineTo().map((List result) {
    bool relative = !firstIsUpper(result);
    return new List.unmodifiable((result[1] as List).cast<num>().map((num n) => new SvgPathLineSegment(null, n, isRelative: relative)));
  });

  @override
  quadraticBezierLineTo() => super.quadraticBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable(result[1].map((List<Point> l) {
      Point control = l[0];
      Point endpoint = l[1];
      return new SvgPathCurveQuadraticSegment(endpoint.x, endpoint.y, control.x, control.y, isRelative: relative);
    }));
  });

  @override
  cubicBezierLineTo() => super.cubicBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable((result[1] as List).cast<List>().map((List l) => l.cast<Point>()).map((List<Point> l) {
      Point control1 = l[0];
      Point control2 = l[1];
      Point endpoint = l[2];
      return new SvgPathCurveCubicSegment(endpoint.x, endpoint.y, control1.x, control1.y, control2.x, control2.y, isRelative: relative);
    }));
  });

  @override
  smoothQuadraticBezierLineTo() => super.smoothQuadraticBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable(result[1].map((Point p) {
      return new SvgPathCurveQuadraticSegment.smooth(p.x, p.y, isRelative: relative);
    }));

  });

  @override
  smoothCubicBezierLineTo() => super.smoothCubicBezierLineTo().map((result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable((result[1] as List).cast<List>().map((l) => l.cast<Point>()).map((List<Point> l) {
      Point control2 = l[0];
      Point endpoint = l[1];
      return new SvgPathCurveCubicSegment.smooth(endpoint.x, endpoint.y, control2.x, control2.y, isRelative: relative);
    }));
  });

  @override
  arcToArguments() => super.arcToArguments().map((result) {
    return new List.unmodifiable(result.where((x) => x != null));
  });

  @override
  arcTo() => super.arcTo().map((result) {
    bool relative = !firstIsUpper(result);

    return new List.unmodifiable((result[1] as List).cast<List>().map((List l) {
      Point radius = l[0];
      num rotation = l[1];
      bool largeArc = l[2];
      bool sweep = l[3];
      Point endpoint = l[4];
      return new SvgPathArcSegment(endpoint.x, endpoint.y, radius.x, radius.y, rotation.toDouble(), isRelative: relative, isLargeArc: largeArc, isSweep: sweep);
    }));
  });

  @override
  wcCoordinate() {
    return super.wcCoordinate().map((result) {
      if(result is num) {
        return result;
      } else {
        return result[1];
      }
    });
  }

  @override
  wcCoordinatePair() {
    return super.wcCoordinatePair().map((result) {
      if(result is Point) {
        return result;
      } else {
        return result[1];
      }
    });
  }

  @override
  coordinatePair() => super.coordinatePair().map((List<dynamic> result) {
    List<num> nums = result.cast();
    return new Point(nums[0], nums[2]);
  });

  @override
  flag() => super.flag().map((result) {
    return result[0] == '1';
  });

  @override
  number() => super.number().map((result) {
    if(result is List) {
      final sign = result[0];
      num number = result[1];
      if (sign == '-') {
        number = -number;
      }
      return number;
    } else {
      return result;
    }
  });

  @override
  commaWhitespace() => super.commaWhitespace().map((_) => null);

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
