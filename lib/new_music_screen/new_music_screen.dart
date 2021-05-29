import 'package:flutter/material.dart';
import 'package:musicapp/globals.dart';
import 'package:sheet_music/sheet_music.dart';

class NewMusicScreen extends StatefulWidget {
  _NewMusicScreenState createState() => _NewMusicScreenState();
}

class _NewMusicScreenState extends State<NewMusicScreen> {
  @override
  _NewMusicScreenState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MusicBook Demo'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40.0),
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black38),
          borderRadius: const BorderRadius.all(const Radius.circular(8)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SheetMusic(
                  scale: "C Major",
                  pitch: "A5",
                  trebleClef: true,
                ),
                SheetMusic(
                  scale: "C Major",
                  pitch: "A2",
                  trebleClef: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
