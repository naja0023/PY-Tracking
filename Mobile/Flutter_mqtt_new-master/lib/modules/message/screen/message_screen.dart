import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:fluttermqttnew/modules/core/models/MQTTAppState.dart';
import 'package:fluttermqttnew/modules/core/widgets/status_bar.dart';
import 'package:fluttermqttnew/modules/helpers/screen_route.dart';
import 'package:fluttermqttnew/modules/helpers/status_info_message_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'dart:typed_data';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

import '../../../login.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  /////mqtt
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  final _mqttcontroller = ScrollController();
  late Timer _timer;
  late MQTTManager _manager;
  var _counter = 0;

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _configureAndConnect());
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _topicTextController.dispose();
    _mqttcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Driver'),
          centerTitle: true,
        ),
        drawer: buildDrawer(),
        body: Column(
          children: [
            _manager.currentState == null
                ? CircularProgressIndicator()
                : _buildColumn(_manager),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: LatLng(28, 30), zoom: 15),
                onMapCreated: (GoogleMapController _mapcontroller) {},
              ),
            )
          ],
        ));
  }

  Widget _buildColumn(MQTTManager manager) {
    return Column(
      children: <Widget>[
        StatusBar(
            statusMessage: prepareStateMessageFrom(
                manager.currentState.getAppConnectionState)),
        //_buildEditableColumn(manager.currentState),
      ],
    );
  }

  /* Widget _buildEditableColumn(MQTTAppState currentAppState) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          _buildScrollableTextWith(currentAppState.getHistoryText)
        ],
      ),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connectedSubscribed) {
      shouldEnable = true;
    } else if ((controller == _topicTextController &&
        (state == MQTTAppConnectionState.connected ||
            state == MQTTAppConnectionState.connectedUnSubscribed))) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
        width: 400,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black12,
        ),
        child: SingleChildScrollView(
          controller: _mqttcontroller,
          child: Text(text),
        ),
      ),
    );
  }*/

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    final String message = osPrefix + ' says: ' + text;
    _manager.publish(message);
    _messageTextController.clear();
  }

  void _configureAndConnect() {
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    int counter = 0;
    if (Platform.isAndroid) {
      osPrefix = "mynono";
    }
    _manager.initializeMQTTClient(host: "broker.emqx.io", identifier: osPrefix);
    _manager.connect();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (counter == 1) {
          _subscribe();
          counter = 0;
          timer.cancel();
        } else {
          counter++;
        }
      });
    });
  }

  void _subscribe() {
    _manager.subScribeTo("moyanyo");
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter == 0) {
          _publishMessage("hello");
          _counter = 0;
        } else {
          _counter++;
        }
      });
    });
  }

  Drawer buildDrawer() => Drawer(
        child: ListView(
          children: <Widget>[buildUserAccountsDrawerHeader(), buildListTile()],
        ),
      );
  ListTile buildListTile() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Logout'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => login());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() =>
      UserAccountsDrawerHeader(
          accountName: Text('เดี๋ยวมาทำ'),
          accountEmail: Text('ตอนนี้ง่วงแล้ว'));
}
