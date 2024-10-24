// lib/fish.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Fish {
  final double speed;

  Fish({required this.speed});

  Widget buildFish() {
    return RandomlyMovingFish(speed: speed);
  }
}

class RandomlyMovingFish extends StatefulWidget {
  final double speed;

  RandomlyMovingFish({required this.speed});

  @override
  _RandomlyMovingFishState createState() => _RandomlyMovingFishState();
}

class _RandomlyMovingFishState extends State<RandomlyMovingFish> {
  Random random = Random();
  Offset targetPosition = Offset(0, 0);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _moveFish(); // Start the movement logic when fish is initialized
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _moveFish() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        // Set a new random target position within the container (300x300)
        targetPosition = Offset(
          random.nextDouble() * 280, // Random X position (slightly inside the container)
          random.nextDouble() * 280, // Random Y position
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: Offset(0, 0), // Start from the initial position
        end: targetPosition,  // Move to the new target position
      ),
      duration: Duration(seconds: (5 / widget.speed).toInt()), // Adjust duration by speed
      curve: Curves.easeInOut, // Smooth transition
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: Image.asset(
            'assets/fish.png',   // Use the fish image instead of a circle
            width: 40,           // Set the size of the fish image
            height: 40,
          ),
        );
      },
      onEnd: () {
        // Pause for a second when reaching the target, then pick a new position
        Future.delayed(Duration(seconds: 1), () {
          _moveFish(); // Call _moveFish again to choose a new random position
        });
      },
    );
  }
}
