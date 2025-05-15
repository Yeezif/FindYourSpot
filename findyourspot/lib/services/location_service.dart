import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        return false;
      }
    }
    return true;
  }

  Stream<LatLng> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (Position position) => LatLng(position.latitude, position.longitude),
    );
  }

  Future<LatLng> getCurrentLocation() async {
    final Position pos = await Geolocator.getCurrentPosition();
    return LatLng(pos.latitude, pos.longitude);
  }
  
}
