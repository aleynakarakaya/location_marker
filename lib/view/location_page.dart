import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_marker/config/constants.dart';
import 'package:location_marker/controller/location_controller.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (locationController.locationPermissionStatus.value ==
              LocationPermission.denied ||
          locationController.locationPermissionStatus.value ==
              LocationPermission.unableToDetermine ||
          locationController.locationPermissionStatus.value ==
              LocationPermission.deniedForever) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(StringConstants.locationWarning),
            LocationAccessToggleButton(
              onPressed: () {
                locationController.openSettings();
              },
            )
          ],
        );
      } else {
        if (locationController.currentPosition.value.latitude == 0.0 &&
            locationController.currentPosition.value.longitude == 0.0) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Stack(children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: locationController.currentPosition.value,
                zoom: 18.0,
              ),
              onMapCreated: locationController.setMapController,
              markers: Set<Marker>.of(locationController.markers),
              myLocationEnabled: true,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 95.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationAccessToggleButton(
                      onPressed: () {
                        locationController.toggleTracking();
                      },
                    ),
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
          ]);
        }
      }
    }));
  }
}

class LocationAccessToggleButton extends StatelessWidget {
  final VoidCallback onPressed;

  LocationAccessToggleButton({super.key, required this.onPressed});

  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: onPressed,
        label: Obx(() => Text(
            locationController.isTrackingEnabled.value
                ? StringConstants.locationAccessEnabled
                : StringConstants.locationAccessDenied,
            style: const TextStyle(color: Colors.black87))));
  }
}
