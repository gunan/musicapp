import 'package:flutter/material.dart';
import 'package:musicapp/main_menu/main_menu.dart';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => MainMenu(),
      },
    );
  }
}
