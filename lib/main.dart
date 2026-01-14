import 'package:flutter/material.dart';
import 'screens/concept_screen.dart';

void main() {
  runApp(const BrainyyyApp());
}

class BrainyyyApp extends StatelessWidget {
  const BrainyyyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brainyyy',
      home: const ChapterRouteScreen(),
    );
  }
}

class Stop {
  final String title;
  bool unlocked;
  bool cleared;

  Stop(this.title, this.unlocked, this.cleared);
}

class ChapterRouteScreen extends StatefulWidget {
  const ChapterRouteScreen({super.key});

  @override
  State<ChapterRouteScreen> createState() => _ChapterRouteScreenState();
}

class _ChapterRouteScreenState extends State<ChapterRouteScreen> {
  final List<Stop> stops = [
    Stop("Intro to Acids, Bases & Salts", true, false),
    Stop("Properties of Acids & Bases", false, false),
    Stop("Indicators", false, false),
    Stop("pH Scale", false, false),
    Stop("Salts & Uses", false, false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acids, Bases & Salts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: stops.length,
        itemBuilder: (context, index) {
          final stop = stops[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: stop.cleared
                  ? Colors.green
                  : stop.unlocked
                  ? Colors.orange
                  : Colors.grey,
              child: Text("${index + 1}"),
            ),
            title: Text(stop.title),
            trailing: Icon(
              stop.cleared
                  ? Icons.check_circle
                  : stop.unlocked
                  ? Icons.lock_open
                  : Icons.lock,
            ),
            onTap: stop.unlocked
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConceptScreen(
                    title: stop.title,
                  ),
                ),
              );
            }
                : null,

          );
        },
      ),
    );
  }
}
