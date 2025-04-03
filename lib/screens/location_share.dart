import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_share_app/src/controllers/signout.dart';
import 'package:location_share_app/src/services/auth.dart';
import 'package:location_share_app/src/services/location.dart';
import 'package:location_share_app/src/utils/spacing.dart';

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
  StreamSubscription<Position>? _positionStream;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    Get.put(SignoutController());
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
    final user = AuthService().currentUser;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      await LocationService().updateLocation(user!.uid, position);

      if (_newGoogleMapController != null) {
        _newGoogleMapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    });

    _updateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position? position = await Geolocator.getCurrentPosition();
      await LocationService().updateLocation(user!.uid, position);
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
      appBar: AppBar(
        title: Text("Location share"),
        actions: [
          GetBuilder<SignoutController>(
            builder: (signoutController) {
              return InkWell(
                onTap: () {
                  signoutController.signiout();
                },
                child: Text(
                  signoutController.isLoading.value ? 'Loading...' : 'Signout',
                ),
              );
            },
          ),
          kWidthSizedBox,
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
          final user = AuthService().currentUser;

          // Extract markers from Firestore snapshot
          final docs = snapshot.data?.docs ?? [];
          _markers.clear();

          for (var index in List.generate(docs.length, (index) => index)) {
            var data = docs[index].data() as Map<String, dynamic>;
            if (data.containsKey('latitude') && data.containsKey('longitude')) {
              LatLng position = LatLng(data['latitude'], data['longitude']);
              _markers.add(
                Marker(
                  markerId: MarkerId(docs[index].id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: docs[index].id == user!.uid ? "You" : "User: $index",
                  ),
                ),
              );
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
            polylines: {},
            padding: const EdgeInsets.only(bottom: 50),
            compassEnabled: true,
            mapToolbarEnabled: true,
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            tiltGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
          );
        },
      ),
    );
  }
}
