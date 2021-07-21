import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttermqttnew/modules/core/managers/MQTTManager.dart';
import 'package:fluttermqttnew/modules/core/models/MQTTAppState.dart';
import 'package:fluttermqttnew/modules/core/widgets/status_bar.dart';
import 'package:fluttermqttnew/modules/helpers/screen_route.dart';
import 'package:fluttermqttnew/modules/helpers/status_info_message_utils.dart';
import 'package:fluttermqttnew/modules/screen/map_screen.dart';
import 'package:fluttermqttnew/modules/widgets/show_title.dart';
import 'package:fluttermqttnew/utillity/my_constant.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool statusRedEye = true;
  late Timer _timer;
  late MQTTManager _manager;
  var _counter = 0;
  var _url = Uri.parse('http://10.0.2.2:35000/login');
  final TextEditingController _getUsername = TextEditingController();
  final TextEditingController _getPassword = TextEditingController();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          children: [
            build_img(width, height),
            build_titleapp(),
            build_textForm_username(width, height),
            build_textForm_password(width, height),
            build_button(width),
            build_describtion(),
          ],
        ),
      ),
    ));
  }

  Row build_img(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.9,
          height: height * 0.35,
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

  Row build_textForm_username(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: width * 0.6,
          child: TextFormField(
            controller: _getUsername,
            decoration: InputDecoration(
              labelText: 'Enter Username',
              prefixIcon: Icon(Icons.account_circle),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyConstant.dark,
                ),
                borderRadius: BorderRadius.circular(width * height * 0.00006),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(width * height * 0.00006),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row build_textForm_password(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: width * 0.6,
          child: TextFormField(
            controller: _getPassword,
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
                borderRadius: BorderRadius.circular(width * height * 0.00006),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(width * height * 0.00006),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row build_button(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: width * 0.6,
          child: ElevatedButton(
            child: Text("Login"),
            style: MyConstant().MyButtonStlye(),
            onPressed: () {
              _login();
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
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
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

    MaterialPageRoute route =
        MaterialPageRoute(builder: (value) => MapScreen());
    Navigator.pushReplacement(context, route);
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('/map', (Route<dynamic> route) => false);
    // Navigator.pushNamedAndRemoveUntil(
    //     context, '/map', ModalRoute.withName('/map'));
  }

  _login() async {
    var username = _getUsername.text;
    var password = _getPassword.text;

    try {
      http.Response response = await http.post(_url, body: {
        'username': username,
        'password': password,
      }).timeout(Duration(seconds: 4));
      var _check = response.body;

      if (response.statusCode == 200 && _check.length > 0) {
        _configureAndConnect();
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text('ล็อกอืนไม่สำเร็จ'),
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
  }
}
