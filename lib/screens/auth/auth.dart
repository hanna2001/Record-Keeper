//This page controls the transition between sign in and register and its UI
import 'package:flutter/material.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/register.dart';
import '../utils/background_paint.dart';
import 'SignIn.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool toggle = true;
  bool pass = true;
  bool isLoading = true;
  bool connect = true;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: true,
        body: Stack(
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: BackgroundPainter(
              animation: _controller.view,
            ),
          ),
        ),

        //MAIN WIDGETS 
        toggle == true ? SignIn() : Register(),
        toggle == true
            ? Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                onPressed: () {
                  _controller.forward(from: 0);
                  setState(() {
                    toggle = !toggle;
                  });
                },
                child: Text(
                  'Don\'t Have an Account? Register',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Palette.darkBlue,
                      fontSize: 15),
                ),
              ),
            )
            : Align(
          alignment: Alignment.bottomCenter,
              child: FlatButton(
                onPressed: () {
                  _controller.reverse(from: 4);
                  setState(() {
                    toggle = !toggle;
                  });
                },
                child: Text(
                  'Already Have an account? SignIn',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Palette.darkBlue,
                      fontSize: 15,
                  ),
                ),
              ),
            ),
      ],
    ));
  }
}
