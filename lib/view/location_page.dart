import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_marker/controller/location_controller.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (locationController.currentPosition.value.latitude == 0.0 &&
            locationController.currentPosition.value.longitude == 0.0) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: locationController.currentPosition.value,
              zoom: 18.0,
            ),
            onMapCreated: locationController.setMapController,
            markers: Set<Marker>.of(locationController.markers),
            myLocationEnabled: true,
          );
        }
      }),
    );
  }
}
