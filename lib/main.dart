import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'staff/staff.dart';
import 'globals.dart';

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

class MusicScreen extends StatefulWidget {
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  var staffkeys = <GlobalKey>[];
  final result = BoxHitTestResult();
  var children = <Widget>[
    new SizedBox(
      height: 50,
    ),
  ];

  @override
  _MusicScreenState() {
    for (int i = 0; i < STAFF_COUNT_IN_PAGE; i++) {
      GlobalKey key = new GlobalKey();
      staffkeys.add(key);
      var staffOffset = STAFF_TOP_MARGIN + i * STAFF_HEIGHT;
      this.children.add(new StaffWithMouse(key: key, id: i));
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
    for (int i = 0; i < STAFF_COUNT_IN_PAGE; i++) {
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
