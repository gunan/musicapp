import 'package:flutter/material.dart';
import 'package:musicapp/old_music_screen/music_screen.dart';

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
