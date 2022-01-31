import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
// ignore: unused_import
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/shared_auth.dart';

import '../../main.dart';
import '../utils/background_paint.dart';
import 'auth.dart';
import '../home.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  LocalAuthentication localAuthentication = LocalAuthentication();
  bool canAuth = false;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _controller.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()async{
        bool check = await bioAuth();
        // bool check = false;
        List<Map<String, dynamic>> query = await DatabaseHelper.instance.queryAll();
        List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
        int Take = await DatabaseHelper.instance.TotalToTake();
        int Give = await DatabaseHelper.instance.TotalToGive();
        String name = await getName();
        setState(() {
          check ? Navigator.push(context, MaterialPageRoute(builder: (context) => Home(query2,Give,Take))) : Navigator.push(context, MaterialPageRoute(builder: (context) => SharedAuth(name,false)));
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(
                  animation: _controller.view,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(children: [
                Expanded(
                  flex: 4,
                  child:Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome\nBack',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 40,
                          child: Center(
                              child:Text(
                                'Get Started',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25,
                                    fontFamily: 'Merienda'),
                              ),),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> bioAuth() async {
    List<BiometricType> list = List();
    try {
      list = await localAuthentication.getAvailableBiometrics();
      print("no..."+list[0].toString());
      bool auth = false;
      if (list.length > 0) {
        if (list.contains(BiometricType.fingerprint)) {
          auth = await localAuthentication.authenticateWithBiometrics(
              localizedReason: 'Please Enter Your Fingerprint to unlock',
              useErrorDialogs: true,
              stickyAuth: true);
          print(auth);
          return auth;
        }else if (list.contains(BiometricType.face)) {
          auth = await localAuthentication.authenticateWithBiometrics(
              localizedReason: 'Please Enter Your Face ID to unlock',
              useErrorDialogs: true,
              stickyAuth: true);
          print(auth);
          return auth;
        }else if (list.contains(BiometricType.iris)) {
          auth = await localAuthentication.authenticateWithBiometrics(
              localizedReason: 'Please Enter Your Iris ID to unlock',
              useErrorDialogs: true,
              stickyAuth: true);
          print(auth);
          return auth;
        }else{
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("------------"+e.toString());
      return false;
       Fluttertoast.showToast(
         msg: 'Please add a Bio-metric lock',
         toastLength: Toast.LENGTH_LONG
         );
    }
  }
}
