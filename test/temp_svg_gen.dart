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
    "M10.1 21.4c.4 0 .8-.2 1-.5A44.7 44.7 0 0 1 67 7a1.2 1.2 0 1 0 1-2.3A46.8 46.8 0 0 0 9.2 19.4a1.2 1.2 0 0 0 1 2M93.6 38v-.2A47 47 0 0 0 74.4 8.6a1.2 1.2 0 0 0-1.4 2 44.6 44.6 0 0 1 18.2 27.8v.2c.7 3.1 1 6.4.9 9.6a1.2 1.2 0 1 0 2.5 0c0-3.4-.3-6.9-1-10.3M3.8 58l-.4-1.9a44.7 44.7 0 0 1 4-29.2 1.2 1.2 0 0 0-2.2-1.1A47.1 47.1 0 0 0 .9 56.6l.1.2.4 1.8a1.2 1.2 0 0 0 2.4-.5M48.5 47a1.2 1.2 0 1 0-2.4.5A50 50 0 0 1 34.5 91a1.2 1.2 0 1 0 1.8 1.7A53.6 53.6 0 0 0 48.5 47M39.9 73c-.7-.2-1.4.1-1.6.8a44.8 44.8 0 0 1-9.7 15 1.2 1.2 0 1 0 1.7 1.8c4.5-4.6 8-10 10.3-16 .2-.5 0-1.3-.7-1.5M54.4 47l-.2-1.1a7 7 0 0 0-8.3-5.5 7 7 0 0 0-5.5 8.3l.2 1.2c1 5.7 1 11.4-.3 17a1.2 1.2 0 1 0 2.5.5 47 47 0 0 0 0-19.2v-.6a4.5 4.5 0 0 1 8.8-1.6l.1.4A56.3 56.3 0 0 1 41 92.2a1.2 1.2 0 1 0 2 1.6A58.8 58.8 0 0 0 54.3 47M37.7 52a1.2 1.2 0 1 0-2.5.3 39.1 39.1 0 0 1-12 33.8 1.2 1.2 0 1 0 1.7 1.8 41.6 41.6 0 0 0 12.8-36M59.8 44.8a12.7 12.7 0 0 0-15-10c-5 1-9 4.9-10 9.9a1.2 1.2 0 1 0 2.4.5 10.3 10.3 0 0 1 20-.4l.2.5c.8 4 1.2 8 1.2 12.1 0 .7.6 1.3 1.2 1.3.7 0 1.3-.6 1.3-1.3 0-3.9-.4-7.8-1.1-11.6l-.2-1zM59.6 63.5c-.7-.1-1.3.4-1.4 1a62.3 62.3 0 0 1-10.5 28.1 1.2 1.2 0 0 0 2 1.4c6-8.7 9.8-18.8 11-29.1 0-.7-.4-1.3-1.1-1.4M31.6 50.5l-.2-1a16 16 0 0 1 12.7-18c1.5-.2 3-.3 4.4-.2a1.2 1.2 0 0 0 .2-2.5A18.6 18.6 0 0 0 29.1 51l.3 1.1a33.3 33.3 0 0 1-11.1 30.6 1.2 1.2 0 1 0 1.6 2 36 36 0 0 0 11.7-34.2M65.6 44.7l-.2-1c-1-5.4-4.4-10-9.1-12.6a1.2 1.2 0 1 0-1.2 2.2c4 2.2 6.8 6 7.8 10.3l.1.5c3.3 16.4.5 33.3-8 47.7a1.2 1.2 0 1 0 2.2 1.3 70.2 70.2 0 0 0 8.4-48.4M24.5 68.4a1.2 1.2 0 0 0-2.3-1A27.8 27.8 0 0 1 13.9 79a1.2 1.2 0 1 0 1.6 1.9c4-3.3 7.1-7.6 9-12.4M71.6 69.9a75.8 75.8 0 0 0-.4-26.8l-.1-.6a24.1 24.1 0 0 0-28.6-19 24.1 24.1 0 0 0-19 28.6l.2 1.2c.4 2.4.5 4.8.2 7.2a1.2 1.2 0 0 0 2.5.2c.3-3 .2-6-.4-9.1l-.3-1.1A21.6 21.6 0 0 1 43 25.9a21.6 21.6 0 0 1 25.6 16.8v.3c1.8 8.8 2 17.7.5 26.5a1.2 1.2 0 1 0 2.5.4M69.1 75.6c-.6-.1-1.3.3-1.5 1-1.2 4.4-2.9 8.9-5 13.1a1.2 1.2 0 0 0 2.3 1.1c2.1-4.4 3.9-9 5.1-13.6.2-.7-.2-1.4-.9-1.6M76.6 40.8c-.9-4-2.6-7.8-5-11.2a1.2 1.2 0 1 0-2 1.5c2.3 3.2 3.9 6.8 4.7 10.7v.4a79 79 0 0 1-3.7 43.6 1.2 1.2 0 1 0 2.4.9 81.6 81.6 0 0 0 3.7-45.3v-.6zM41.3 17.9a30 30 0 0 0-6.6 2.1 1.2 1.2 0 0 0 1 2.3 27.6 27.6 0 0 1 29 3.7 1.2 1.2 0 0 0 1.6-2 30 30 0 0 0-25-6.1M20.3 52.7l-.2-1a27.5 27.5 0 0 1 9.8-25.8 1.2 1.2 0 0 0-1.5-2 30 30 0 0 0-10.6 29.3l.2 1a21.7 21.7 0 0 1-7.9 20.3 1.2 1.2 0 1 0 1.6 2 24.2 24.2 0 0 0 8.6-23.8M14.7 53.9l-.2-1.1c-.3-1.4-.4-2.8-.5-4.2a1.2 1.2 0 0 0-2.5.1c.1 2 .3 3.8.7 5.7l.2.7a16 16 0 0 1-5.5 14.7 1.2 1.2 0 0 0 1.6 1.9 18.6 18.6 0 0 0 6.2-17.8M80 40.7v.6l.7 3.8a1.2 1.2 0 1 0 2.5-.3 91 91 0 0 0-.8-4.6l-.2-.9a35.5 35.5 0 0 0-42-27A35.6 35.6 0 0 0 12 41.1a1.2 1.2 0 0 0 2.5.4 33.2 33.2 0 0 1 65.4-.9M82.6 51c-.7 0-1.2.6-1.2 1.3.6 9.1-.3 18.2-2.6 27.1a1.2 1.2 0 1 0 2.4.6 87 87 0 0 0 2.7-27.9c0-.7-.6-1.2-1.3-1.2M9 55l-.1-.7A38.8 38.8 0 0 1 39.6 9c4.3-.8 8.6-1 13-.4a1.2 1.2 0 0 0 .2-2.5A41.4 41.4 0 0 0 6.6 55.5v.4c.6 3.1-.4 6.3-2.6 8.6A1.2 1.2 0 1 0 6 66.2c2.8-3 4-7.2 3.1-11.2M87.8 38A41.6 41.6 0 0 0 59.8 7.6a1.2 1.2 0 0 0-.7 2.4 39.1 39.1 0 0 1 26.3 29.5l.2.8c1.8 9.4 2.2 19 1 28.4a1.2 1.2 0 1 0 2.4.3c1.3-10 .9-20-1.1-30l-.2-1.2z"
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

          String radius = r1 == r2 ? "new Radius.circular($r1)" : "new Radius.elliptical($r1, $r2)";

          print('$name.${relative
            ? 'relativeArcToPoint'
            : 'arcToPoint'}(new Offset($x, $y), radius: $radius, rotation: $angle, largeArc: $isLargeArc, clockwise: $isSweep);');
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
