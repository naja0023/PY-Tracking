import 'dart:async';
import 'dart:convert';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/screen/login_screen.dart';
import 'package:fluttermqttnew/modules/widgets/show_title.dart';
import 'package:fluttermqttnew/secrets.dart';
import 'package:fluttermqttnew/utillity/my_constant.dart';
import 'package:fluttermqttnew/utillity/show_progress.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:http/http.dart' as http;
// import 'package:http/http.dart';

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
  late String _name = '';
  late String _email = '';
  double? lat, lng;

  bool _picture = true;
  final _url = Uri.parse('http://10.0.2.2:35000/addlocation');

  late GoogleMapController mapController;
  late Timer _timer;
  late double p = 4.5;
  int countingtin = 0;
  late MQTTManager _manager;

  StreamSubscription<Position>? positionStream;
  bool track_button = true;
  late Position _currentPosition;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  double _originLatitude = 19.031459, _originLongitude = 99.926547;
  double _destLatitude = 19.172379, _destLongitude = 99.898241;
  double _originLatitude1 = 19.172379, _originLongitude1 = 99.898241;
  double _destLatitude1 = 19.031459, _destLongitude1 = 99.926547;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<Marker> _marker = [];

  @override
  void initState() {
    findposition();

    _getPolyline();
    finlatlng();
    _updatelocation();
    getInfo();

    int counter = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter == 1) {
          get_location();

          counter = 0;
          // timer.cancel();
        } else {
          counter++;
        }
      });
    });

    super.initState();

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
  }

  // @override
  // dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width * (50 / 100)),
          child: buildDrawer(),
        ),
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: height * (5 / 100) + 20,
          title: ShowTitle(
            title: MyConstant.appName,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: MyConstant.dark,
        ),
        body: Stack(
          children: <Widget>[
            buildMap(),
            reviewBox(width, context, height),
            zoombutton(width, height),
            trackingbutton(width, height),
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
          padding: EdgeInsets.only(
              right: width * (5 / 100), bottom: height * (3 / 100)),
          child: ClipOval(
            child: Material(
              color: Colors.orange[100], // button color
              child: InkWell(
                  splashColor: Colors.orange, // inkwell color
                  child: CircleAvatar(
                    backgroundColor: Colors.orange[200],
                    radius: 35,
                    child: track_button
                        ? Icon(
                            Icons.explore,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.my_location,
                            color: Colors.black,
                          ),
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
        padding: EdgeInsets.only(top: height * (3 / 100)),
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
              width: 275,
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      //height: height * 0.1,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: _picture
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/img5.png"),
                                      maxRadius: 35,
                                    ),
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 70,
                                    color: MyConstant.primary,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5, top: 25),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _name,
                                          style: MyConstant().h2_Stlye(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 25, top: 5),
                                  child: Row(
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                    width: 60,
                    height: 60,
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
                    width: 60,
                    height: 60,
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
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: _marker.map((e) => e).toSet(),
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    List<LatLng> polylineCoordinates1 = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY,
      PointLatLng(_originLatitude, _originLongitude),
      PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    PolylineResult result1 = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY,
      PointLatLng(_originLatitude1, _originLongitude1),
      PointLatLng(_destLatitude1, _destLongitude1),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty || result1.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      result1.points.forEach((PointLatLng point) {
        polylineCoordinates1.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print('err_poly ${result.errorMessage}');
      print('err_poly1 ${result1.errorMessage}');
    }
    _addPolyLine(polylineCoordinates);
    _addPolyLine1(polylineCoordinates1);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _addPolyLine1(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly1");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
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
      _publishMessage("lat:" +
          position.latitude.toString() +
          ":lng:" +
          position.longitude.toString());

      await GetStorage.init();
      final box = GetStorage();
      String car = box.read('carmatchid').toString();

      if (countingtin == 30) {
        try {
          http.Response response = await http.post((_url), body: {
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
      accountName: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShowTitle(
          title: _name,
          textStyle: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
      accountEmail: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShowTitle(
          title: _email,
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      currentAccountPicture: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage("images/img5.png"),
          maxRadius: 250,
        ),
      ),
    );
  }

  Container titleDrawer() {
    return Container(
      child: Card(
        color: Colors.white70,
        elevation: 5,
        child: ListTile(
          leading: Icon(Icons.logout),
          title: ShowTitle(
            title: 'logout',
            textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black45,
            ),
          ),
          onTap: () {
            _disconnect();
          },
        ),
      ),
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

  Future get_location() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://10.0.2.2:35000/query_location'));

      List data = jsonDecode(response.body);
      for (var i in data) {
        var user_lat = double.parse('${i['lat']}');
        var user_lng = double.parse('${i['lng']}');
        var user_status = int.parse('${i['status']}');
        var user_route = int.parse('${i['route']}');

        // Marker mark1 = Marker(
        //   markerId: MarkerId('5555'),
        //   position: LatLng(user_lat, user_lng),
        //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // );

        if (user_status != 0) {
          _marker.add(
            Marker(
                markerId: MarkerId('${i['request_id']}'),
                position: LatLng(user_lat, user_lng),
                icon: (user_route == 1)
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      )
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      )),
          );
        }
      }

      // print(
      //     '#${data['request_id']} ตำแหน่งผู้โดยสาร : ${data['lat']},${data['lng']}');
    } on TimeoutException catch (e) {
      print('Timeout : $e ');
    } catch (e) {
      print('ERROR : $e ');
    }
  }
}
