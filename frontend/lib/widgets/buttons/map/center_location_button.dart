import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CenterLocationButton extends StatefulWidget {

  final LatLng? currentLocation;
  final MapController mapController;

  const CenterLocationButton({

    super.key,
    required this.currentLocation,
    required this.mapController,

  });

  @override
  _CenterLocationButtonState createState() => _CenterLocationButtonState();

}

class _CenterLocationButtonState extends State<CenterLocationButton> with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<LatLng> _LatLngAnimation;
  late Animation<double> _zoomAnimation;
  late LatLng _currentCenter;
  late double _currentZoom;

  @override
  void initState() {
    super.initState();

    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMove || event is MapEventMoveEnd) {
        setState(() {
          _currentCenter = event.camera.center;
          _currentZoom = event.camera.zoom;
        });
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),  
    );

  }

  @override
  void dispose() {
    _controller.removeListener(_handleAnimation);
    _controller.dispose();
    super.dispose();
  }

  void _flyTo(LatLng targetLocation, double targetZoom) {

    _controller.reset();

    final cameraCenter = _currentCenter;
    final cameraZoom = _currentZoom;

    _LatLngAnimation = LatLngTween(
      begin: cameraCenter,
      end: targetLocation,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeOut)
    );

    _zoomAnimation = Tween<double>(
      begin: cameraZoom,
      end: targetZoom,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeOut)
    );

    // Remove previous listeners, if any
    _controller.removeListener(_handleAnimation);

    // Add listener now
    _controller.addListener(_handleAnimation);

    _controller.forward(from: 0.0);
  }

  void _handleAnimation() {
    final latLng = _LatLngAnimation.value;
    final zoom = _zoomAnimation.value;
    widget.mapController.move(latLng, zoom);
  }


  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      heroTag: 'center_location_button',
      mini: true,
      onPressed: () {
        if (widget.currentLocation != null) {
          if (widget.currentLocation != widget.mapController.camera.center) {
            _flyTo(widget.currentLocation!, 15.0);
          }
        }
      },
      child: const Icon(Icons.my_location_rounded)
    );

  }

}

class LatLngTween extends Tween<LatLng> {

  LatLngTween({
    required LatLng begin,
    required LatLng end
  }) : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t, 
      begin!.longitude + (end!.longitude - begin!.longitude) * t
    );
  }

}