import 'package:flutter/material.dart';
import 'package:fluttermqttnew/modules/screen/map_screen.dart';
import 'package:fluttermqttnew/utillity/my_constant.dart';

class profileScreen extends StatelessWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          MyConstant.dark,
                          MyConstant.primary,
                          MyConstant.light,
                        ])),
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                              ),
                              maxRadius: 80,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Kunawut Artwong",
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: .0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "จำนวนรีวิว",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: MyConstant.dark,
                                                fontSize: 21.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "5200",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: MyConstant.primary,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "คะแนนเฉลี่ย",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: MyConstant.dark,
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "28.5K",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: MyConstant.primary,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "เริ่มใช้งานเมื่อ",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: MyConstant.dark,
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "1300",
                                              style: TextStyle(
                                                fontSize: 19,
                                                color: MyConstant.primary,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "ข้อมูลส่วนตัว",
                          style: TextStyle(
                            color: MyConstant.dark,
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'ชื่อ Kunawut นามสุกล Artwong\n'
                          'เบอร์โทรศัพท์ 099-xxx-xxxx\n'
                          'E-mail Hon@kunawut.hub\n'
                          'เลขทะเบียนรถ 1กข 9999 พะเยา\n'
                          'ความจุที่นั่ง 15 ที่นั่ง\n',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              letterSpacing: 1.0,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Container(
                    width: 300.00,
                    child: RaisedButton(
                        onPressed: () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (value) => MapScreen());
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        elevation: 0.0,
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  MyConstant.dark,
                                  MyConstant.primary,
                                ]),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "กลับหน้าหลัก",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
