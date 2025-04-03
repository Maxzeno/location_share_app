import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_share_app/src/controllers/signout.dart';
import 'package:location_share_app/src/services/location.dart';
import 'package:location_share_app/src/utils/colors.dart';
import 'package:location_share_app/src/utils/map.dart';

class LocationShareScreen extends StatefulWidget {
  const LocationShareScreen({super.key});

  static const routeName = '/location-share';

  @override
  State<LocationShareScreen> createState() => _LocationShareScreenState();
}

class _LocationShareScreenState extends State<LocationShareScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;
  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [];
  StreamSubscription<Position>? _positionStream;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    Get.put(SignoutController());
    startTracking();
    _startLocationUpdates();
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!_googleMapController.isCompleted) {
      _googleMapController.complete(controller);
    }
    _newGoogleMapController = controller;
  }

  void _startLocationUpdates() async {
    bool permissionGranted =
        await LocationService().requestLocationPermission();
    if (!permissionGranted) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      String userId = "user_123"; // Replace with FirebaseAuth user ID
      await LocationService().updateLocation(userId, position);

      if (_newGoogleMapController != null) {
        _newGoogleMapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    });

    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position? position = await Geolocator.getCurrentPosition();
      String userId = "user_123"; // Replace with FirebaseAuth user ID
      await LocationService().updateLocation(userId, position);
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
    return Scaffold(
      appBar: AppBar(title: Text("Location share")),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: LocationService().getLocationUpdates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No active users"));
              }

              // Extract markers from Firestore snapshot
              _markers.clear();
              _polylineCoordinates.clear();
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                if (data.containsKey('latitude') &&
                    data.containsKey('longitude')) {
                  LatLng position = LatLng(data['latitude'], data['longitude']);
                  _markers.add(
                    Marker(
                      markerId: MarkerId(doc.id),
                      position: position,
                      infoWindow: InfoWindow(title: "User: ${doc.id}"),
                    ),
                  );
                  _polylineCoordinates.add(position);
                }
              }

              return GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target:
                      _markers.isNotEmpty
                          ? _markers.first.position
                          : const LatLng(0.0, 0.0),
                  zoom: 14,
                ),
                markers: _markers,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("Available Users"),
                    points: _polylineCoordinates,
                    color: kMainRed,
                    width: 4,
                  ),
                },
                padding: const EdgeInsets.only(bottom: 50),
                compassEnabled: true,
                mapToolbarEnabled: true,
                minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                tiltGesturesEnabled: true,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
              );
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GetBuilder<SignoutController>(
              builder: (signoutController) {
                return InkWell(
                  onTap: () {
                    signoutController.signiout();
                  },
                  child: Text(
                    signoutController.isLoading.value ? 'Loading' : 'Signout',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
