// lib/fish.dart
import 'package:flutter/material.dart';

class Fish {
  final Color color;
  final double speed;

  Fish({required this.color, required this.speed});

  Widget buildFish() {
    // Use AnimatedPositioned or Transform to animate fish
    return AnimatedFish(
      color: color,
      speed: speed,
    );
  }
}

class AnimatedFish extends StatefulWidget {
  final Color color;
  final double speed;

  AnimatedFish({required this.color, required this.speed});

  @override
  _AnimatedFishState createState() => _AnimatedFishState();
}

class _AnimatedFishState extends State<AnimatedFish>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.speed.toInt()),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              150 * _controller.value, // move fish within container
              150 * _controller.value),
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
    );
  }
}
