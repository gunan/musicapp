import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../globals.dart';

class StaffWithMouse extends StatefulWidget {
  final int id;

  const StaffWithMouse({Key key, @required this.id}) : super(key: key);

  _StaffWithMouseState createState() => _StaffWithMouseState(this.id);
}

class _StaffWithMouseState extends State<StaffWithMouse> {
  bool isCursorInside = false;
  Offset cursorLocation = new Offset(0.0, 0.0);
  int id;

  _StaffWithMouseState(this.id);

  void _onEnter(PointerEvent details) {
    setState(() {
      this.isCursorInside = true;
    });
  }

  void _onExit(PointerEvent details) {
    setState(() {
      this.isCursorInside = false;
    });
  }

  void _onUpdate(PointerEvent details) {
    setState(() {
      this.cursorLocation = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    var staffOffset = STAFF_TOP_MARGIN + this.id * STAFF_HEIGHT;

    return MouseRegion(
      child: CustomPaint(
        painter: Staff(
          id: this.id,
          cursorInside: this.isCursorInside,
          cursorLocation: this.cursorLocation,
        ),
        size: Size(STAFF_END, staffOffset + STAFF_HEIGHT),
      ),
      onEnter: _onEnter,
      onExit: _onExit,
      onHover: _onUpdate,
    );
  }
}

class Staff extends CustomPainter {
  var begin;
  var id;
  var staffLines = new List<Rect>(STAFF_LINE_COUNT);
  var staffLineCenters = new List<double>(STAFF_LINE_COUNT);
  var staffSpaces = new List<Rect>(STAFF_LINE_COUNT + 1);
  var staffSpaceCenters = new List<double>(STAFF_LINE_COUNT + 1);
  var whichRect = -1;
  var ovalXOffset;

  bool cursorInside = false;
  Offset cursorLocation = new Offset(0.0, 0.0);
  Staff({this.id, this.cursorInside, this.cursorLocation}) {
    this.begin = STAFF_DISTANCE;
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

  bool _checkOval() {
    if (this.cursorInside) {
      this.whichRect = -1;
      var pos = this.cursorLocation;
      for (var i = 0; i < STAFF_LINE_COUNT; i++) {
        if (staffLines[i].contains(pos)) {
          this.whichRect = i;
          this.ovalXOffset = pos.dx;
          return true;
        }
      }
      for (var i = 0; i < STAFF_LINE_COUNT + 1; i++) {
        if (staffSpaces[i].contains(pos)) {
          this.whichRect = 5 + i;
          this.ovalXOffset = pos.dx;
          return true;
        }
      }
    }
    return false;
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
    if (_checkOval()) {
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
  bool hitTest(Offset position) => true;

  @override
  bool shouldRepaint(Staff oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(Staff oldDelegate) => false;

  @override
  SemanticsBuilderCallback get semanticsBuilder => null;
}
