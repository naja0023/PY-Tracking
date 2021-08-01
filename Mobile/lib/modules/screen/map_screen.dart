import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/screen/login_screen.dart';
import 'package:fluttermqttnew/secrets.dart';
import 'package:fluttermqttnew/utillity/my_constant.dart';
import 'package:fluttermqttnew/utillity/show_progress.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
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
  late double p = 4.5;
  int countingtin = 0;
  late MQTTManager _manager;
  final _url = Uri.parse('http://10.0.2.2:35000/addlocation');
  StreamSubscription<Position>? positionStream;
  bool track_button = true;
  late Position _currentPosition;

  late String _name;
  late String _email;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  double _originLatitude = 19.031459, _originLongitude = 99.926547;
  double _destLatitude = 19.172379, _destLongitude = 99.898241;

  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getInfo();
    findposition();

    super.initState();
    _getPolyline();
    finlatlng();
    _updatelocation();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('err_poly ${result.errorMessage}');
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: MyConstant.primary,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
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
      accountName: Text(_name),
      accountEmail: Text(_email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage("images/img5.png"),
      ),
    );
  }

  ListTile titleDrawer() {
    return ListTile(
      leading: Icon(Icons.logout),
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

  void getInfo() async {
    await GetStorage.init();
    final box = GetStorage();
    _name = box.read('name').toString();
    _email = box.read('email').toString();
  }
}
