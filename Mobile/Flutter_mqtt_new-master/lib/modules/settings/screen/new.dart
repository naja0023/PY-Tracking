import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:fluttermqttnew/modules/core/models/MQTTAppState.dart';
import 'package:fluttermqttnew/modules/core/widgets/status_bar.dart';
import 'package:fluttermqttnew/modules/helpers/status_info_message_utils.dart';
import 'package:provider/provider.dart';

class Benz extends StatefulWidget {
  const Benz({Key? key}) : super(key: key);

  @override
  _BenzState createState() => _BenzState();
}

late MQTTManager _manager;

class _BenzState extends State<Benz> {
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _configureAndConnect());
    // WidgetsBinding.instance.addPostFrameCallback(()=> _configureAndConnect(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) => configureAndConnect(context));
  }

  @override
  Widget build(BuildContext context) {
    _manager = Provider.of<MQTTManager>(context);
    return Scaffold(
        body: Column(
      children: [
        Text("data"),
        RaisedButton(
          child: Text("data"),
          onPressed: () {
            Navigator.of(context).pushNamed("/");
          },
        )
      ],
    ));
  }
}

void _configureAndConnect() {
  // TODO: Use UUID
  String osPrefix = 'Flutter_iOS';

  _manager.initializeMQTTClient(host: "broker.emqx.io", identifier: osPrefix);
  _manager.connect();
}
