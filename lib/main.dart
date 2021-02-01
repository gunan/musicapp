import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MusicApp());

// GLOBALS

const STAFF_TOP_MARGIN = 100.0;
const STAFF_LEFT_MARGIN = 100.0;
const STAFF_WIDTH = 800.0;
const STAFF_DISTANCE = 10.0;

const STAFF_LINE_COUNT = 5;
const STAFF_COUNT_IN_PAGE = 5;

// Computed globals
const STAFF_END = STAFF_WIDTH + STAFF_DISTANCE;
const STAFF_HEIGHT = 1 * STAFF_DISTANCE;

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
  var staffLines = new List<Rect>(STAFF_LINE_COUNT);
  Staff(this.begin, this.id) {
    for (var i=0; i<STAFF_LINE_COUNT;i++) {
      var cury = begin + i*STAFF_DISTANCE;
      staffLines[i] = new Rect.fromPoints(
        Offset(STAFF_LEFT_MARGIN, cury),
        Offset(STAFF_END, cury+3));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(var i = 0; i<STAFF_LINE_COUNT; i++) {
      canvas.drawRect(
        staffLines[i],
        Paint()..color = Colors.black
               ..strokeWidth = 1.5
               ..style = PaintingStyle.fill);
    }
  }

  @override
  bool hitTest(Offset pos) {
    var whichRect = -1;
    for (var i = 0; i< STAFF_LINE_COUNT; i++) {
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

class MusicScreen extends StatefulWidget {
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  var staffkeys = <GlobalKey>[];
  final result = BoxHitTestResult();
  var children = <Widget>[
      new SizedBox(height: 50,),
  ];

  @override
  _MusicScreenState() {
    for (int i=0; i<STAFF_COUNT_IN_PAGE; i++ ) {
      GlobalKey key = new GlobalKey();
      staffkeys.add(key);
      var staffOffset = STAFF_TOP_MARGIN + i * STAFF_HEIGHT;
      this.children.add(CustomPaint(
        key: key,
        painter: Staff(0, i),
        size: Size(STAFF_END, staffOffset + STAFF_HEIGHT),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MusicBook Demo'),
      ),
      body: Listener(
        onPointerDown: (PointerEvent pointerEvent) {
          handleClick(pointerEvent);
        },
        child: Column(
          children: this.children,
        ),
      ),
    );
  }

    handleClick(final PointerEvent details) {
      for (int i=0; i<STAFF_COUNT_IN_PAGE; i++) {
        if (isClicked(details, staffkeys[i])) {
          print('clicked staff number: $i');
        }
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