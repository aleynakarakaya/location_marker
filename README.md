# Location Marker

Location tracking and marking application.

## What Do We Have

This application displays, tracks, and marks the user's location on a map as long as the user grants permission. Marking occurs automatically every 100 meters. Users can reset the markers or stop location tracking. The application also supports background operation. 

The application is developed using the Flutter programming language and supports both Android and iOS mobile platforms. For the map view, the google_maps_flutter package is used; geolocator is utilized for detecting user location and managing location permissions; geocoding is employed to display address details; and background_location is used to maintain access to the user's location in the background. 

For state management, the get package is implemented, while flutter_launcher_icons is used for changing the app logo, and flutter_native_splash is used for the native splash screen.

**Flutter SDK:** 3.27.0-1.0.pre.104
