import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/screen/login_screen.dart';

import '../../responsive.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: login(),
        tablet: login(),
      ),
    );
  }
}
