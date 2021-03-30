import 'package:flutter/material.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/pin.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth.dart';

class Splash extends StatefulWidget {
  bool check;
  Splash(this.check);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      backgroundColor: Palette.darkBlue,
      image: Image.asset('asset/image/logo.jpg'),
      loaderColor: Colors.white,
      loadingText: Text('#MadeWithLove ❤ Kohil.Studio',style: TextStyle(fontFamily: "Oregano",color: Colors.white,fontSize: 25,),),
      photoSize: 50,
      navigateAfterSeconds: widget.check ? Pin():AuthScreen(),
    );
  }
}
