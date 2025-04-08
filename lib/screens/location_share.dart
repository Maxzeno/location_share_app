import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_share_app/src/controllers/signout.dart';
import 'package:location_share_app/src/services/auth.dart';
import 'package:location_share_app/src/services/location.dart';

class LocationShareScreen extends StatefulWidget {
  const LocationShareScreen({super.key});
  static const routeName = '/location-share';

  @override
  State<LocationShareScreen> createState() => _LocationShareScreenState();
}

class _LocationShareScreenState extends State<LocationShareScreen> {
  GoogleMapController? _newGoogleMapController;
  final Set<Marker> _markers = {};
  StreamSubscription<Position>? _positionStream;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    Get.put(SignoutController());
    _startLocationUpdates();
  }

  void _onMapCreated(GoogleMapController controller) {
    _newGoogleMapController = controller;
  }

  void _startLocationUpdates() async {
    if (!await LocationService().requestLocationPermission()) return;

    final user = AuthService().currentUser;
    if (user == null) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      await LocationService().updateLocation(user.uid, position);
      _newGoogleMapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    });

    _updateTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final position = await Geolocator.getCurrentPosition();
      await LocationService().updateLocation(user.uid, position);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Location share"),
        actions: [
          GetBuilder<SignoutController>(
            builder: (signoutController) {
              return InkWell(
                onTap: signoutController.signiout,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      signoutController.isLoading.value
                          ? 'Loading...'
                          : 'Signout',
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: LocationService().getLocationUpdates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          _markers.clear();
          final docs = snapshot.data?.docs ?? [];

          for (var i = 0; i < docs.length; i++) {
            final data = docs[i].data() as Map<String, dynamic>;
            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              final position = LatLng(data['latitude'], data['longitude']);
              _markers.add(
                Marker(
                  markerId: MarkerId(docs[i].id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: docs[i].id == user?.uid ? "You" : "User $i",
                  ),
                ),
              );
            }
          }

          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target:
                  _markers.isNotEmpty
                      ? _markers.first.position
                      : const LatLng(0.0, 0.0),
              zoom: 14,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
            padding: const EdgeInsets.only(bottom: 50),
          );
        },
      ),
    );
  }
}
