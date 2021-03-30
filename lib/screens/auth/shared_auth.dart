import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import '../../main.dart';
import '../background_paint.dart';
import 'home.dart';

class SharedAuth extends StatefulWidget {
  String name;
  SharedAuth(this.name);
  @override
  _SharedAuthState createState() => _SharedAuthState();
}

class _SharedAuthState extends State<SharedAuth>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController passctrl;
  bool pass = true;
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
                    'Welcome\nBack\n'+widget.name.toString(),
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
                            hintText: 'Password',
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
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Verify',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Palette.darkBlue,
                              fontSize: 24,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: _LoadingIndicator(isLoading),
                            ),
                          ),
                          _RoundContinueButton(isLoading),
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

  void verify() async{
    setState((){
      isLoading = true;
    });
    String pass = await getPass();
    if(passctrl.text == pass){
      List<Map<String, dynamic>> query =
      await DatabaseHelper.instance.queryAll();
      int Take = await DatabaseHelper.instance.TotalToTake();
      int Give = await DatabaseHelper.instance.TotalToGive();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home(query, Give, Take)));
    }else{
      Fluttertoast.showToast(msg: 'Incorrect Password',toastLength:  Toast.LENGTH_LONG);
    }
    setState((){
      isLoading = false;
    });
  }

  Widget _RoundContinueButton(isLoading) {
    return RawMaterialButton(
      onPressed: () => (passctrl.text == '') ? Fluttertoast.showToast(msg: 'Please Enter Your password',toastLength:  Toast.LENGTH_LONG) : verify(),
      elevation: 0.0,
      fillColor: Palette.darkBlue,
      splashColor: Palette.darkOrange,
      padding: const EdgeInsets.all(22.0),
      shape: const CircleBorder(),
      child: const Icon(
        FontAwesomeIcons.longArrowAltRight,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }

  Widget _LoadingIndicator(bool isLoading) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Visibility(
        visible: isLoading,
        child: const LinearProgressIndicator(
          backgroundColor: Palette.darkBlue,
        ),
      ),
    );
  }
}
