import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/screen/login_screen.dart';
import 'package:fluttermqttnew/modules/widgets/show_title.dart';
import 'package:fluttermqttnew/secrets.dart'; // Stores the Google Maps API Key
import 'package:fluttermqttnew/utillity/my_constant.dart';
import 'package:fluttermqttnew/utillity/show_progress.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  double? lat, lng;

  late GoogleMapController mapController;
  late Timer _timer;
  var _counter = 0;
  late double p = 4.5;
  int countingtin = 0;
  late MQTTManager _manager;
  final _url = Uri.parse('http://10.0.2.2:35000/addlocation');
  StreamSubscription<Position>? positionStream;
  bool track_button = true;
  late Position _currentPosition;
  String _currentAddress = '';

  late String _name;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  Set<Marker> markers = {};
  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    findposition();
    finlatlng();

    getName();
    _updatelocation();

    super.initState();
    // _configureAndConnect();
    // WidgetsBinding.instance!
    //     .addPostFrameCallback((_) => _configureAndConnect());
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.dark,
          title: Row(children: [
            SizedBox(
              width: width * 0.21,
            ),
            Text(MyConstant.appName),
          ]),
        ),
        drawer: buildDrawer(),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            buildMap(),
            zoombutton(width, height),
            trackingbutton(width, height),
            reviewBox(width, context, height),
          ],
        ),
      ),
    );
  }

  SafeArea trackingbutton(double width, double height) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 25, bottom: 25),
          child: ClipOval(
            child: Material(
              color: Colors.orange[100], // button color
              child: InkWell(
                  splashColor: Colors.orange, // inkwell color
                  child: SizedBox(
                    width: width * 0.15,
                    height: height * 0.08,
                    child: track_button
                        ? Icon(Icons.explore)
                        : Icon(Icons.my_location),
                  ),
                  onTap: () {
                    setState(() {
                      track_button ? _cameratrack() : _uncameratrack();
                      track_button = !track_button;
                    });
                  }),
            ),
          ),
        ),
      ),
    );
  }

  SafeArea reviewBox(double width, BuildContext context, double height) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(width * height * 0.01),
                ),
              ),
              width: width * 0.6,
              height: height * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: width * height * 0.00018,
                              color: MyConstant.primary,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    _name,
                                    style: MyConstant().h2_Stlye(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // SizedBox(
                                  //   height: height * 0.015,
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.star_border,
                                          color: Colors.grey),

                                      ///2 ดาว
                                      Icon(Icons.star_border,
                                          color: Colors.grey),

                                      ///3 ดาว
                                      Icon(Icons.star_border,
                                          color: Colors.grey),

                                      ///4 ดาว
                                      Icon(Icons.star_border,
                                          color: Colors.grey),

                                      ///5 ดาว
                                      Icon(Icons.star_border,
                                          color: Colors.grey),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     _name,
                  //     style: MyConstant().h2_Stlye(),
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  calculateStar() {}

  SafeArea zoombutton(double width, double height) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: width * 0.12,
                    height: height * 0.06,
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            ClipOval(
              child: Material(
                color: Colors.blue.shade100, // button color
                child: InkWell(
                  splashColor: Colors.blue, // inkwell color
                  child: SizedBox(
                    width: width * 0.12,
                    height: height * 0.06,
                    child: Icon(Icons.remove),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMap() {
    return Container(
      child: lat == null
          ? Center(child: ShowProgress())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 15,
              ),
              markers: Set<Marker>.from(markers),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }

  Future<Null> finlatlng() async {
    Position? _position = await findposition();
    setState(() {
      lat = _position?.latitude;
      lng = _position?.longitude;
    });
  }

  Future<Position?> findposition() async {
    Position _position;
    try {
      _position = await Geolocator.getCurrentPosition();
      return _position;
    } catch (e) {
      return null;
    }
  }

  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      // );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    final String message = osPrefix + ' says: ' + text;
    _manager.publish(message);
    // _messageTextController.clear();
  }

  // ignore: unused_element
  void _updatelocation() {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
            .listen((Position position) async {
      _currentPosition = position;
      _publishMessage("latitude :" +
          position.latitude.toString() +
          " longtitude : " +
          position.longitude.toString());

      await GetStorage.init();
      final box = GetStorage();
      String car = box.read('carmatchid').toString();
      if (countingtin == 30) {
        try {
          http.Response response = await http.post(_url, body: {
            'carmatch': car,
            'lat': position.latitude.toString(),
            'lng': position.longitude.toString(),
          }).timeout(Duration(seconds: 4));
          var _check = response.body;

          if (response.statusCode == 200) {
            print('Upload to database $_currentPosition');
            countingtin = 0;
          } else {
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Server error'),
            );
            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } on TimeoutException catch (e) {
          print('Timeout : $e ');
        } catch (e) {
          print('ERROR : $e ');
        }
      } else {
        print('CURRENT LOCATION $_currentPosition');
        print('counting $countingtin');
        countingtin++;
      }
    });
  }

  void _cameratrack() {
    positionStream =
        Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best)
            .listen((Position position) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
    });
  }

  void _uncameratrack() {
    positionStream?.cancel();
  }

  void _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Container(
        //color: MyConstant.light,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            headerDrawer(),
            titleDrawer(),
          ],
        ),
      ),
    );
  }

  UserAccountsDrawerHeader headerDrawer() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: MyConstant.dark,
      ),
      accountName: Text('เดี๋ยวมาทำ'),
      accountEmail: Text('ตอนนี้ง่วงแล้ว'),
    );
  }

  ListTile titleDrawer() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Logout'),
      onTap: () {
        _disconnect();
      },
    );
  }

  void _disconnect() {
    int counter = 0;
    _manager.disconnect();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        if (counter == 1) {
          //Navigator.pushReplacementNamed(context, '/login');
          counter = 0;
          timer.cancel();

          ///----------
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/login', (Route<dynamic> route) => false);
          ///----------
          // Navigator.pop(context);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => login());
          Navigator.pushReplacement(context, route);
        } else {
          counter++;
        }
      });
    });
  }

  void getName() async {
    await GetStorage.init();
    final box = GetStorage();
    _name = box.read('name').toString();
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
}
