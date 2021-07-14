import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:fluttermqttnew/modules/core/models/MQTTAppState.dart';
import 'package:fluttermqttnew/modules/core/widgets/status_bar.dart';
import 'package:fluttermqttnew/modules/helpers/screen_route.dart';
import 'package:fluttermqttnew/modules/helpers/status_info_message_utils.dart';
import 'package:fluttermqttnew/modules/widgets/show_title.dart';
import 'package:fluttermqttnew/utillity/my_constant.dart';
import 'package:provider/provider.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);
  @override
  _loginState createState() => _loginState();
}

late Timer _timer;
late MQTTManager _manager;
var _counter = 0;

class _loginState extends State<login> {
  bool statusRedEye = true;

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
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            build_img(size),
            build_titleapp(),
            build_textForm_username(size),
            build_textForm_password(size),
            build_button(size),
            build_describtion(),
          ],
        ),
      ),
    ));
  }

  Row build_img(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size * 0.9,
          height: size * 0.7,
          child: Image.asset('images/img3.png'),
        ),
      ],
    );
  }

  Row build_titleapp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
            title: MyConstant.appName, textStyle: MyConstant().h1_Stlye()),
      ],
    );
  }

  Row build_textForm_username(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 25),
          width: size * 0.6,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter Username',
              prefixIcon: Icon(Icons.account_circle),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.dark,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row build_textForm_password(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: MyConstant.primary,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: MyConstant.primary,
                      ),
              ),
              labelText: 'Enter Password',
              prefixIcon: Icon(Icons.lock),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.dark,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row build_button(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: ElevatedButton(
            child: Text("Login"),
            style: MyConstant().MyButtonStlye(),
            onPressed: () {
              _configureAndConnect();
            },
          ),
        ),
      ],
    );
  }

  Row build_describtion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 180),
          child: ShowTitle(
            title: 'Powered by Moyanyo and his Friends.',
            textStyle: MyConstant().h3_Stlye(),
          ),
        ),
      ],
    );
  }

  ///ConectMqtt and Sucribe
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
    Navigator.of(context).pushNamed(SETTINGS_ROUTE);
  }
}
