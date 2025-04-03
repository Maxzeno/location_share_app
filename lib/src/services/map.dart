import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch real-time locations
  Stream<List<Marker>> getUserMarkers() {
    return _firestore.collection('locations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(data['latitude'], data['longitude']),
          infoWindow: InfoWindow(title: "User: ${doc.id}"),
        );
      }).toList();
    });
  }
}
