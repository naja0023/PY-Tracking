import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  Location _location;
  Location get Location => _location;
  LatLng get locationPosition => _locationPosition;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initalization() {}

  getUserLocation() async {
    bool _serviceEnable;
    PermissionStatus _permissionGranted;

    _serviceEnable = await location.serviceEnable();
    if (!_serviceEnable) {
      _serviceEnable = await Location.requesService();
      if (!_serviceEnable) {
        return;
      }
    }
    _permissionGranted = await Location.hasPermission();
    if (_permissionGranted == PermissionStatus) {
      _permissionGranted = await Location.requesService();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    Location.onLocationChanged.listen(LocationData currentLocation{
       _locationPosition = LatLng(currentLocation.latitude, currentLocation.longitude,);

       print(_LocationPosition);
       notifyListeners();
    });

  }
}
