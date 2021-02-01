import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MusicScreen(),
      },
    );
  }
}


class Staff extends CustomPainter {
  var begin;
  var id;
  var staffDistance = 10;
  var staffLines = new List<Rect>(5);
  Staff(this.begin, this.id) {

    for (var i=0; i<5;i++) {
      var cury = begin + i*staffDistance;
      staffLines[i] = new Rect.fromPoints(Offset(0, cury), Offset(500, cury+1));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(var i = 0; i<5; i++) {
      canvas.drawRect(
        staffLines[i],
        Paint()..color = Colors.black
               ..strokeWidth = 1.5
               ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool hitTest(Offset pos) {
    var whichRect = -1;
    for (var i = 0; i< 5; i++) {
      if(staffLines[i].contains(pos)) {
        whichRect = i;
        break;
      }
    }
    print('Mouse over at staff: $id, line:$whichRect');
  }

  @override
  bool shouldRepaint(Staff oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Staff oldDelegate) => false;
}

class MusicScreen extends StatelessWidget {
  final GlobalKey staff1 = new GlobalKey();
  final GlobalKey staff2 = new GlobalKey();
  final result = BoxHitTestResult();

  @override
  Widget build(BuildContext context) {
    var height = 400;
    return Scaffold(
      appBar: AppBar(
        title: Text('MusicBook Demo'),
      ),
      body: Listener(
        onPointerDown: (PointerEvent pointerEvent) {
          handleClick(pointerEvent);
        },
        child: Column(
          children: [
            // This size has to be from origin to bottom left
            // corner for the cursor hit tests to work properly.
            // well...
            CustomPaint(
              key: staff1,
              painter: Staff(100, 1),
              size: Size(500, 150),
            ),
            CustomPaint(
              key: staff2,
              painter: Staff(150, 2),
              size: Size(500, 500),
            ),
          ]
        ),
      ),
    );
  }

    handleClick(final PointerEvent details) {
      if (isClicked(details, staff1)) {
        print('clicked staff1');
      }
      if (isClicked(details, staff2)) {
        print('clicked staff2');
      }
    }

    bool isClicked(PointerEvent details, GlobalKey key) {
      RenderBox staffBox = key.currentContext.findRenderObject();
      Offset localClick = staffBox.globalToLocal(details.position);
    //    Offset localClick = details.localPosition
      if (staffBox.hitTest(result, position: localClick)) {
        return true;
      }
      return false;
  }
}