import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

import 'package:findyourspot/services/services.dart';
import 'package:findyourspot/widgets/exports.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _mapReady = false;
  final LocationService _locationService = LocationService();
  MapStyleAnimationManager? _animationManager;
  List<Marker> _spotMarkers = [];

  
  final Map<String, String> _mapStyles = {
    'Street': 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=',
    'Satellite': 'https://api.maptiler.com/maps/satellite/{z}/{x}/{y}.jpg?key=',
    'Outdoors': 'https://api.maptiler.com/maps/outdoor-v2/{z}/{x}/{y}.png?key=',
  };

  final Map<String, IconData> mapStyleIcons = {
    'Street': Icons.map,
    'Satellite': Icons.satellite_alt,
    'Outdoors': Icons.terrain,
  };

  String _selectedMapStyle = 'Street';

  double _mapRotation = 0.0;

  @override
  void initState() {
    super.initState();
    fetchSpots();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initLocationTracking();
    });


    // Animation Setup
    _animationManager = MapStyleAnimationManager(
      vsync: this, 
      itemCount: mapStyleIcons.length,
    );

    _mapController.mapEventStream.listen((event) {
      setState(() {
        _mapRotation = _mapController.camera.rotation;
      });
    });
  }

  Future<void> fetchSpots() async {
    try {

      final markers = await SpotService.fetchSpotMarkers(context, _buildSpotDetail);

      setState(() {
        _spotMarkers = markers;
      });

    } catch (e) {

      debugPrint('Fehler beim Laden der Spots: $e');

    }
  }


  Widget _buildSpotDetail(Map spot) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            spot['title'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            spot['description'] ?? 'Keine Beschreibung',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Location Setup
  Future<void> _initLocationTracking() async {
    bool hasPermission = await _locationService.checkPermissions();
    if (!hasPermission) return;

    final initialPosition = await _locationService.getCurrentLocation();
    setState(() => _currentLocation = initialPosition);

    _locationService.getLocationStream().listen((LatLng position) {
      setState(() => _currentLocation = position);
      if (_mapReady) {
        _mapController.move(position, _mapController.camera.zoom);
      }
    });    
  }

  @override
  Widget build(BuildContext context) {
    final String apiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';
    // TODO: MapStyles global verwalten
    // late String urlTemp ='${_mapStyles[_selectedMapStyle]}$apiKey';
    

    return Scaffold(

      // AppBar Top
      appBar: AppBarMain(),

      // Body
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(

              children: [

                FlutterMap(

                  mapController: _mapController,

                  options: MapOptions(
                    initialCenter: _currentLocation!,
                    initialZoom: 15,
                    onMapReady: () => _mapReady = true,
                  ),
                  
                  children: [

                    TileLayer(
                      urlTemplate: '${_mapStyles[_selectedMapStyle]}$apiKey',
                      userAgentPackageName: 'com.example.findyourspot',
                    ),
                    
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.assistant_navigation,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),

                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        disableClusteringAtZoom: 16,
                        maxClusterRadius: 45,
                        size: const Size(40, 40),
                        markers: _spotMarkers,
                        polygonOptions: const PolygonOptions(
                          borderColor: Colors.blueAccent,
                          color: Colors.black12,
                          borderStrokeWidth: 3,
                        ),
                        builder: (context, cluster) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Text(
                              cluster.length.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),

                  ],
                ),

                

                // Floating Style Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: MapStyleButtonGroup(
                    controller: _animationManager!.controller, 
                    fadeAnimations: _animationManager!.fadeAnimations, 
                    slideAnimations: _animationManager!.slideAnimations, 
                    mapStyleIcons: mapStyleIcons, 
                    selectedMapStyle: _selectedMapStyle, 
                    onStyleSelected: (style) {
                      setState(() {
                        _selectedMapStyle = style;
                      });
                    }
                  )
                ),



                // Create Spot Button
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: CreateSpotButton(
                    location: _currentLocation!,
                    onSpotCreated: (spotData) {
                      final newMarker = SpotService.buildMarkerFromSpot(
                        context: context,
                        spot: spotData,
                        detailBuilder: _buildSpotDetail
                      );

                      setState(() {
                        // _spotMarkers.add(marker);
                        _spotMarkers = List.from(_spotMarkers)..add(newMarker);
                      });
                      _mapController.move(newMarker.point, _mapController.camera.zoom);
                    
                    },
                  ),
                ),
                


                // TODO: Search Bar
                Positioned(
                  bottom: 14,
                  left: 108,
                  right: 108,
                  child: SearchBar(
                    hintText: 'Suchen...',
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                      )
                    )
                  ),
                ),



                // Center Button
                Positioned(
                  bottom: 104,
                  right: 10,
                  child: CenterLocationButton(
                    currentLocation: _currentLocation, 
                    mapController: _mapController
                  ),
                ),



                // Northing Button
                Positioned(
                  bottom: 158,
                  right: 10,                      
                  child: NorthingButton(
                    mapController: _mapController, 
                    mapRotation: _mapRotation,
                  ),
                ),

              ],

            ),
    );
  }

  @override
  void dispose() {
    _animationManager?.dispose();
    super.dispose();
  }
}

