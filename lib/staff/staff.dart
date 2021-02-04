import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../globals.dart';

class Staff extends ChangeNotifier implements CustomPainter {
  var begin;
  var id;
  var staffLines = new List<Rect>(STAFF_LINE_COUNT);
  var staffLineCenters = new List<double>(STAFF_LINE_COUNT);
  var staffSpaces = new List<Rect>(STAFF_LINE_COUNT + 1);
  var staffSpaceCenters = new List<double>(STAFF_LINE_COUNT + 1);
  var whichRect = -1;
  var ovalXOffset;
  Staff(b, this.id) {
    this.begin = b + STAFF_DISTANCE;
    for (var i = 0; i < STAFF_LINE_COUNT; i++) {
      var cury = begin + i * STAFF_DISTANCE;
      staffLines[i] = new Rect.fromPoints(Offset(STAFF_LEFT_MARGIN, cury),
          Offset(STAFF_END, cury + STAFF_LINE_THICKNESS));
      staffLineCenters[i] = cury + STAFF_LINE_THICKNESS / 2;
    }
    var spaceStart = begin - (STAFF_DISTANCE / 2.0);
    var spaceHalfHeight = (STAFF_DISTANCE - STAFF_LINE_THICKNESS) / 2.0;
    for (var i = 0; i < STAFF_LINE_COUNT + 1; i++) {
      var rectCenter = spaceStart + i * STAFF_DISTANCE;
      staffSpaceCenters[i] = rectCenter;
      staffSpaces[i] = new Rect.fromPoints(
        Offset(STAFF_LEFT_MARGIN, rectCenter + spaceHalfHeight),
        Offset(STAFF_END, rectCenter - spaceHalfHeight),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < STAFF_LINE_COUNT; i++) {
      canvas.drawRect(
          staffLines[i],
          Paint()
            ..color = Colors.black
            ..strokeWidth = 1.5
            ..style = PaintingStyle.fill);
    }
    if (this.whichRect != -1) {
      var noteTop;
      if (this.whichRect < 5) {
        noteTop = this.staffLineCenters[this.whichRect] - SCORE_OVAL_HEIGHT / 2;
      } else {
        noteTop = this.staffSpaceCenters[this.whichRect - 5] +
            1 -
            SCORE_OVAL_HEIGHT / 2;
      }

      var noteBottom = noteTop + SCORE_OVAL_HEIGHT;
      Rect note = new Rect.fromPoints(
        Offset(this.ovalXOffset - SCORE_OVAL_WIDTH / 2, noteTop),
        Offset(this.ovalXOffset + SCORE_OVAL_WIDTH / 2, noteBottom),
      );
      canvas.drawOval(
          note,
          Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool hitTest(Offset pos) {
    this.whichRect = -1;
    for (var i = 0; i < STAFF_LINE_COUNT; i++) {
      if (staffLines[i].contains(pos)) {
        this.whichRect = i;
        this.ovalXOffset = pos.dx;
        this.notifyListeners();
        return true;
      }
    }
    for (var i = 0; i < STAFF_LINE_COUNT + 1; i++) {
      if (staffSpaces[i].contains(pos)) {
        this.whichRect = 5 + i;
        this.ovalXOffset = pos.dx;
        this.notifyListeners();
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldRepaint(Staff oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(Staff oldDelegate) => false;

  @override
  SemanticsBuilderCallback get semanticsBuilder => null;
}