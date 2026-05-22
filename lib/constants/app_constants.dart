/// Constants used throughout the Geolocator Map application
class AppConstants {
  // Location Update Interval
  /// Location is fetched every 10 seconds
  static const int locationUpdateIntervalSeconds = 10;

  // Map Settings
  /// Default zoom level when animating to user's location
  static const double defaultMapZoomLevel = 18.0;

  /// Initial zoom level for the map
  static const double initialMapZoomLevel = 15.0;

  // Marker Settings
  /// ID for the current location marker
  static const String currentLocationMarkerId = 'current_location';

  /// Title displayed in the marker info window
  static const String markerTitle = 'My current location';

  /// Number of decimal places for latitude/longitude display
  static const int coordinateDecimalPlaces = 6;

  // Polyline Settings
  /// Color of the polyline (blue)
  static const int polylineColorValue = 0xFF2196F3;

  /// Width of the polyline in pixels
  static const int polylineWidth = 5;

  /// Whether polylines use geodesic rendering
  static const bool polylineGeodesic = true;

  // Location Accuracy
  /// Desired accuracy for location fetching
  /// Options: lowest, low, medium, high, best, bestForNavigation
  static const String locationAccuracy = 'high';

  // Strings
  static const String appTitle = 'Geolocator Map Tracker';
  static const String appBarTitle = 'Geolocator Map Tracker';
  static const String fabTooltip = 'Animate to current location';
  static const String loadingMessage = 'Fetching location...';
  static const String permissionErrorMessage = 'Location permission is required';
  static const String locationErrorPrefix = 'Error getting location: ';

  // Timing
  /// How long to wait before showing loading indicator
  static const Duration loadingDelay = Duration(milliseconds: 500);

  // Animation
  /// Duration for camera animation
  static const Duration cameraAnimationDuration = Duration(milliseconds: 1000);
}
