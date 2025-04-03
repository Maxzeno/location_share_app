import 'package:geolocator/geolocator.dart';
import 'package:location_share_app/src/services/auth.dart';
import 'package:location_share_app/src/services/location.dart';

void startTracking() async {
  final locationService = LocationService();
  final authService = AuthService();

  bool permissionGranted = await locationService.requestLocationPermission();
  if (permissionGranted && authService.currentUser != null) {
    Position? position = await locationService.getCurrentLocation();
    if (position != null) {
      locationService.updateLocation(authService.currentUser!.uid, position);
    }
  }
}
