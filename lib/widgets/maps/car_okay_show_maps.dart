import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class COShowMaps extends StatelessWidget {
  final LatLng? center;

  const COShowMaps({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    LatLng c = center ?? const LatLng(18.7880315, 98.98563493);
    Marker m = Marker(
      markerId: const MarkerId("_init"),
      position: LatLng(c.latitude, c.longitude),
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: c,
        zoom: 14,
      ),
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: false,
      markers: {m},
    );
  }
}
