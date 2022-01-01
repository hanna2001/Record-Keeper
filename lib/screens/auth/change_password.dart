import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/change_password.dart';
import '../../main.dart';
import '../background_paint.dart';
import 'home.dart';
import 'change_password.dart';

class ChangePass extends StatefulWidget {

  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController passctrl,cpassctrl;
  bool pass = true,cpass=true;
  bool isLoading = false;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    passctrl = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: BackgroundPainter(
              animation: _controller.view,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter new Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextField(
                        controller: passctrl,
                        obscureText: pass,
                        decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.black54,
                              size: 25,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pass = !pass;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 25,
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextField(
                        controller: cpassctrl,
                        obscureText: cpass,
                        decoration: InputDecoration(
                            hintText: ' Confirm New Password',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.black54,
                              size: 25,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  cpass = !cpass;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.black,
                                size: 25,
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Password',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Palette.darkBlue,
                              fontSize: 24,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              // child: _LoadingIndicator(isLoading),
                            ),
                          ),
                          // _RoundContinueButton(isLoading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}