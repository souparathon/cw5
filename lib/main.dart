// lib/main.dart
import 'package:flutter/material.dart';
import 'fish.dart';
import 'database_helper.dart'; // Import the database helper

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Aquarium(),
    );
  }
}

class Aquarium extends StatefulWidget {
  @override
  _AquariumState createState() => _AquariumState();
}

class _AquariumState extends State<Aquarium> {
  List<Fish> fishList = [];
  Color selectedColor = Colors.blue;
  double selectedSpeed = 2.0;
  final dbHelper = DatabaseHelper(); // Instantiate the database helper

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Load saved settings when the app starts
  }

  // Add a new fish to the aquarium
  void _addFish() {
    if (fishList.length < 10) {
      setState(() {
        fishList.add(Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  // Save settings to SQLite
  void _saveSettings() async {
    await dbHelper.saveSettings(fishList.length, selectedSpeed, selectedColor.value);
  }

  // Load settings from SQLite
  void _loadSettings() async {
    final settings = await dbHelper.loadSettings();
    if (settings.isNotEmpty) {
      setState(() {
        selectedSpeed = settings['speed'] ?? 2.0;
        selectedColor = Color(settings['color'] ?? Colors.blue.value);
        int fishCount = settings['fishCount'] ?? 0;
        fishList = List.generate(fishCount, (index) => Fish(color: selectedColor, speed: selectedSpeed));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Virtual Aquarium")),
      body: Column(
        children: [
          // Aquarium container
          Container(
            height: 300,
            width: 300,
            color: Colors.blue[100],
            child: Stack(
              children: fishList.map((fish) => fish.buildFish()).toList(),
            ),
          ),
          // Fish customization controls
          Row(
            children: [
              ElevatedButton(
                onPressed: _addFish,
                child: Text("Add Fish"),
              ),
              ElevatedButton(
                onPressed: _saveSettings,
                child: Text("Save Settings"),
              ),
              // Speed slider
              Slider(
                value: selectedSpeed,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: "Speed ${selectedSpeed.toString()}",
                onChanged: (value) {
                  setState(() {
                    selectedSpeed = value;
                  });
                },
              ),
              // Color picker
              DropdownButton<Color>(
                value: selectedColor,
                items: <Color>[Colors.red, Colors.blue, Colors.green, Colors.yellow]
                    .map((Color color) {
                  return DropdownMenuItem<Color>(
                    value: color,
                    child: Container(width: 24, height: 24, color: color),
                  );
                }).toList(),
                onChanged: (Color? newValue) {
                  setState(() {
                    selectedColor = newValue!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
