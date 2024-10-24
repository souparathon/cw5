// lib/fish.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Fish {
  final Color color;
  final double speed; // Speed is now more related to how quickly it moves to the target

  Fish({required this.color, required this.speed});

  Widget buildFish() {
    return RandomlyMovingFish(
      color: color,
      speed: speed,
    );
  }
}

class RandomlyMovingFish extends StatefulWidget {
  final Color color;
  final double speed;

  RandomlyMovingFish({required this.color, required this.speed});

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
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
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
