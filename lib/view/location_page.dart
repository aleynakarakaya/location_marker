import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_marker/config/constants.dart';
import 'package:location_marker/controller/location_controller.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Obx(() {
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 95.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                    onPressed: () {
                      locationController.isTrackingEnabled.toggle();
                    },
                    label: Obx(() => Text(
                        locationController.isTrackingEnabled.value
                            ? StringConstants.locationAccessEnabled
                            : StringConstants.locationAccessDenied,
                        style: const TextStyle(color: Colors.black87)))),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  onPressed: () {
                    locationController.clearMarkers();
                  },
                  label: const Text(
                    StringConstants.clearMarkers,
                    style: TextStyle(color: Colors.black87),
                  ),
                  backgroundColor: Colors.amberAccent,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
