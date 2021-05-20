import 'package:flutter/material.dart';
import 'package:musicapp/old_music_screen/music_screen.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Gunhan\'s super menu';

    return MaterialApp(
        title: title,
        home: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: GridView.extent(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                maxCrossAxisExtent: 150,
                children: [
                  GestureDetector(
                      child: Card(
                        color: Colors.tealAccent,
                        shadowColor: Colors.teal,
                        elevation: 5,
                        child: Text('Old stuff'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MusicScreen()),
                        );
                      }),
                  Card(child: Text('New stuff')),
                ])));
  }
}
