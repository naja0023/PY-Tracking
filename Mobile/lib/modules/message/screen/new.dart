import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:fluttermqttnew/modules/core/models/MQTTAppState.dart';
import 'package:fluttermqttnew/modules/core/widgets/status_bar.dart';
import 'package:fluttermqttnew/modules/helpers/screen_route.dart';
import 'package:fluttermqttnew/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';

class Benz extends StatefulWidget {
  const Benz({Key? key}) : super(key: key);

  @override
  _BenzState createState() => _BenzState();
}

late Timer _timer;
late MQTTManager _manager;
var _counter = 0;

class _BenzState extends State<Benz> {
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance!
        // .addPostFrameCallback((_) => _configureAndConnect());
    // WidgetsBinding.instance.addPostFrameCallback(()=> _configureAndConnect(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) => configureAndConnect(context));
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        body: SafeArea(
          child: Column(
      children: [
          Text("Login "),
          RaisedButton(
            child: Text("Login"),
            onPressed: () {
              _configureAndConnect();
              

            },
          )
      ],
    ),
        ));
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
        if (counter == 3) {
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
    Navigator.of(context).pushNamed(SETTINGS_ROUTE);
  }
}
