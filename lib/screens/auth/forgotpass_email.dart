//import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/change_password.dart';
//import '../../main.dart';
import '../utils/background_paint.dart';
//import '../home.dart';
import 'change_password.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
class EnterEmail extends StatefulWidget {

  @override
  _EnterEmailState createState() => _EnterEmailState();
}
class _EnterEmailState extends State<EnterEmail> with SingleTickerProviderStateMixin {

  AnimationController _controller;
   bool isLoading = false;
   String email='',sec_ans='';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Forgot Password',
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
                        onChanged: (value){
                          email=value;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter email',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black54,
                              size: 25,
                            ),
                            ),
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

  // void verify() async{
  //   setState((){
  //     isLoading = true;
  //   });
  //   String pass = await getPass();
  //   if(passctrl.text == pass){
  //     List<Map<String, dynamic>> query =
  //     await DatabaseHelper.instance.queryAll();
  //     int Take = await DatabaseHelper.instance.TotalToTake();
  //     int Give = await DatabaseHelper.instance.TotalToGive();
  //     widget.changePass?Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePass())):Navigator.push(context,
  //         MaterialPageRoute(builder: (context) => Home(query, Give, Take)));
      
  //   }else{
  //     Fluttertoast.showToast(msg: 'Incorrect Password',toastLength:  Toast.LENGTH_LONG);
  //   }
  //   setState((){
  //     isLoading = false;
  //   });
  // }

  Widget _RoundContinueButton(isLoading) {
    return RawMaterialButton(
      onPressed: ()async{
       
        if(email=='')
        {
          Fluttertoast.showToast(msg: 'Please Enter Your Email',toastLength:  Toast.LENGTH_LONG);
        }
        else{
          print("yes");
          checkEmail();
            
        }
          
          
      },
      // onPressed: ()  => (passctrl.text == '') ? Fluttertoast.showToast(msg: 'Please Enter Your password',toastLength:  Toast.LENGTH_LONG) : verify(),
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
  void checkEmail() async{
      setState(() {
      isLoading = true;
    });
    var url = "https://355668.xyz/Authentication/forgot_pass_email.php";
    var data = {
      "email": email,
      // "sec_ans":sec_ans

    };
    var res = await http.post(url, body: data);
    var body=jsonDecode(res.body);
    print(body);
    if(body['result'] == "dont have account")
        Fluttertoast.showToast(msg: 'No account Please Register',toastLength:  Toast.LENGTH_LONG);
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePass(email: email,forgot: true,)));
    }
      
    setState(() {
      isLoading = false;
    });
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