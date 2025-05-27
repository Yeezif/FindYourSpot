import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;


class NorthingButton extends StatefulWidget {

  final MapController mapController;
  final double mapRotation;

  const NorthingButton({

    super.key,
    required this.mapController,
    required this.mapRotation,

  });

  @override
  _NorthingButtonState createState() => _NorthingButtonState();

}

class _NorthingButtonState extends State<NorthingButton> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),  
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToNorth() {

    _controller.reset();

    _rotationAnimation = Tween<double>(
      begin: widget.mapRotation,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        widget.mapController.rotate(_rotationAnimation.value);
      });

    _controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    
    return FloatingActionButton(
      heroTag: 'northing_button',
      mini: true,
      onPressed: _animateToNorth,
      
      child: Transform.rotate(
        angle: widget.mapRotation * (math.pi / 180), // conversion to radians
        child: const Icon(Icons.navigation_rounded)
      )
    );

  }

}
