import 'package:svg/svg.dart';
import 'package:test/test.dart';

void main() {
  group('whee', () {
    test('can parse stuff', () {
      doParse();
    });
  });
}

void doParse() {
  var pathStrings = [
    "M25.93 59.08A19.96 19.96 0 0 0 40 64.56c5.44 0 10.17-1.84 14.07-5.48A2.1 2.1 0 0 0 51.2 56 15.76 15.76 0 0 1 40 60.35c-4.38 0-8.08-1.44-11.2-4.35a2.1 2.1 0 0 0-2.87 3.08zM4.11 21.94v-8.91a8.77 8.77 0 0 1 8.92-8.92h8.91a2.06 2.06 0 1 0 0-4.11h-8.91C5.73 0 0 5.72 0 13.03v8.91a2.06 2.06 0 1 0 4.11 0zM75.89 21.94v-8.91a8.77 8.77 0 0 0-8.92-8.92h-8.91a2.06 2.06 0 1 1 0-4.11h8.91C74.27 0 80 5.72 80 13.03v8.91a2.06 2.06 0 1 1-4.11 0zM4.11 58.06v8.91a8.77 8.77 0 0 0 8.92 8.92h8.91a2.06 2.06 0 0 1 0 4.11h-8.91C5.73 80 0 74.28 0 66.97v-8.91a2.06 2.06 0 1 1 4.11 0zM75.89 58.06v8.91a8.77 8.77 0 0 1-8.92 8.92h-8.91a2.06 2.06 0 0 0 0 4.11h8.91C74.27 80 80 74.28 80 66.97v-8.91a2.06 2.06 0 1 0-4.11 0zM40 30.18V44.9c0 .95-.46 1.4-1.4 1.4h-1.4a2.1 2.1 0 1 0 0 4.22h1.4a5.41 5.41 0 0 0 5.61-5.62V30.18a2.1 2.1 0 1 0-4.21 0zM54.74 30.21v5.72c0 1.18.9 2.14 2 2.14s2-.96 2-2.14v-5.72c0-1.18-.9-2.14-2-2.14s-2 .96-2 2.14zM21.75 30.21v5.72c0 1.18.9 2.14 2 2.14s2-.96 2-2.14v-5.72c0-1.18-.9-2.14-2-2.14s-2 .96-2 2.14z"
  ];

  int i = 0;
  for (var pathString in pathStrings) {
//    print('Parsing path: $pathString');
    print('');
    String pathName = "path$i";
    var parsedPath = parseSvgPath(pathString);
//    print('Path $pathName = new Path();');
    doParse2(parsedPath, "path");
    print('');
    print('');
    i++;
  }
}

void doParse2(pathdef, String name) {
//  var pathdef =
//  const <SvgPathSegment> [
//    const SvgPathMoveSegment(206.83, 4.77),
//    const SvgPathLineSegment(null, 167),
//    const SvgPathLineSegment(47.14, null, isRelative: true),
//    const SvgPathClose(),
//    const SvgPathLineSegment(47.14, null, isRelative: true),
//    const SvgPathLineSegment(null, -46.45, isRelative: true),
//    const SvgPathLineSegment(23.33, null, isRelative: true),
//    const SvgPathCurveCubicSegment(57.88, -57.9, 31.98, 0, 57.88, -25.93, isRelative: true),
//    const SvgPathCurveCubicSegment(-57.88, -57.88, 0, -31.96, -25.9, -57.88, isRelative: true),
//    const SvgPathLineSegment(-70.47, null, isRelative: true),
//    const SvgPathClose(),
//    const SvgPathMoveSegment(46.9, 36.86, isRelative: true),
//    const SvgPathLineSegment(15.44, null, isRelative: true),
//    const SvgPathCurveCubicSegment(19.88, 19.9, 10.98, 0, 19.88, 8.92, isRelative: true),
//    const SvgPathCurveCubicSegment(-19.88, 19.87, 0, 10.97, -8.9, 19.87, isRelative: true),
//    const SvgPathLineSegment(-15.44, 0.03, isRelative: true),
//    const SvgPathLineSegment(null, -39.8, isRelative: true),
//    const SvgPathClose()];

  double cur_x = 0.0;
  double cur_y = 0.0;
  double prev_x;
  double prev_y;

  SvgPathSegment prev_segment;

  for (SvgPathSegment segment in pathdef) {
    if (segment is SvgPathPositionSegment) {
      bool relative = segment.isRelative;

      double x;
      double y;

//      print('cur: $cur_x, $cur_y; prev: $prev_x, $prev_y');

      // dealing with line segment first as it can be horizontal or vertical (null x/y)
      if (segment is SvgPathLineSegment) {
        if (relative) {
          x = segment.isVertical ? 0.0 : segment.x.toDouble();
          y = segment.isHorizontal ? 0.0 : segment.y.toDouble();

          print('$name.relativeLineTo($x, $y);');
        } else {
          x = segment.isVertical ? cur_x : segment.x.toDouble();
          y = segment.isHorizontal ? cur_y : segment.y.toDouble();

          print('$name.lineTo($x, $y);');
        }
      } else {
        x = segment.x.toDouble();
        y = segment.y.toDouble();

        if (segment is SvgPathMoveSegment) {
          if (relative) {
            print('$name.relativeMoveTo($x, $y);');
          } else {
            print('$name.moveTo($x, $y);');
          }
        } else if (segment is SvgPathLineSegment) {
          if (relative) {
            if (segment.isVertical) x = 0.0;
            if (segment.isHorizontal) y = 0.0;

            print('$name.relativeLineTo($x, $y);');
          } else {
            if (segment.isVertical) x = cur_x;
            if (segment.isHorizontal) y = cur_y;

            print('$name.lineTo($x, $y);');
          }
        } else if (segment is SvgPathCurveQuadraticSegment) {
          double x1, y1;
          if (segment.isSmooth) {
            if (prev_segment is SvgPathCurveQuadraticSegment) {
              double x1_prev_abs, y1_prev_abs;

              if (prev_segment.isRelative) {
                // get absolute position of point
                x1_prev_abs = prev_x + prev_segment.x1.toDouble();
                y1_prev_abs = prev_y + prev_segment.y1.toDouble();
              } else {
                // absolute already, we're good
                x1_prev_abs = prev_segment.x1.toDouble();
                y1_prev_abs = prev_segment.y1.toDouble();
              }

              //get relative to current & flip
              double x1_rel = -(cur_x - x1_prev_abs);
              double y1_rel = -(cur_y - y1_prev_abs);

              if (segment.isRelative) {
                // already have relative
                x1 = x1_rel;
                y1 = y1_rel;
              } else {
                // make absolute
                x1 = cur_x + x1_rel;
                y1 = cur_y + y1_rel;
              }
            } else {
              if (segment.isRelative) {
                x1 = 0.0;
                y1 = 0.0;
              } else {
                x1 = cur_x;
                y1 = cur_y;
              }
            }
          } else {
            x1 = segment.x1.toDouble();
            y1 = segment.y1.toDouble();
          }

          if (relative) {
            print('$name.relativeQuadraticBezierTo($x1, $y1, $x, $y);');
          } else {
            print('$name.quadraticBezierTo($x1, $y1, $x, $y);');
          }
        } else if (segment is SvgPathCurveCubicSegment) {
          double x1, y1, x2 = segment.x2.toDouble(), y2 = segment.y2.toDouble();
          if (segment.isSmooth) {
            if (prev_segment is SvgPathCurveCubicSegment) {
              double x2_prev_abs, y2_prev_abs;

              if (prev_segment.isRelative) {
                // get absolute position of point
                x2_prev_abs = prev_x + prev_segment.x2.toDouble();
                y2_prev_abs = prev_y + prev_segment.y2.toDouble();
              } else {
                // absolute already, we're good
                x2_prev_abs = prev_segment.x2.toDouble();
                y2_prev_abs = prev_segment.y2.toDouble();
              }

              double x1_rel = cur_x - x2_prev_abs;
              double y1_rel = cur_y - y2_prev_abs;

              if (segment.isRelative) {
                // already have relative
                x1 = x1_rel;
                y1 = y1_rel;
              } else {
                // make absolute
                x1 = cur_x + x1_rel;
                y1 = cur_y + y1_rel;
              }
            } else {
              if (segment.isRelative) {
                x1 = 0.0;
                y1 = 0.0;
              } else {
                x1 = cur_x;
                y1 = cur_y;
              }
            }
          } else {
            x1 = segment.x1.toDouble();
            y1 = segment.y1.toDouble();
          }

          if (relative) {
            print('$name.relativeCubicTo($x1, $y1, $x2, $y2, $x, $y);');
          } else {
            print('$name.cubicTo($x1, $y1, $x2, $y2, $x, $y);');
          }
        } else if (segment is SvgPathArcSegment) {
          num angle = segment.angle;
          bool isLargeArc = segment.isLargeArc;
          bool isSweep = segment.isSweep;
          num r1 = segment.r1;
          num r2 = segment.r2;

          print('$name.${relative
            ? 'relativeArcToPoint'
            : 'arcToPoint'}(new Offset($x, $y), radius: new Radius.elliptical($r1, $r2), rotation: $angle, largeArc: $isLargeArc, clockwise: $isSweep);');
        }
      }
      prev_x = cur_x;
      prev_y = cur_y;

      if (relative) {
        cur_x += x;
        cur_y += y;
      } else {
        cur_x = x;
        cur_y = y;
      }
    } else if (segment is SvgPathClose) {
      print('$name.close();');
    }

    prev_segment = segment;
  }
}
