import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/screens/auth/change_password.dart';
import '../../main.dart';
import '../utils/background_paint.dart';
import '../home.dart';
import 'change_password.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class ChangePass extends StatefulWidget {
  String email;
  bool forgot;
  ChangePass({this.email,this.forgot});
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  TextEditingController passctrl,cpassctrl;
  String cpass_;
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
                        // controller: cpassctrl,
                        onChanged: (val){
                          cpass_=val;
                        },
                        obscureText: cpass,
                        decoration: InputDecoration(
                            hintText: 'Confirm New Password',
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

                    Center(
              child: InkWell(
                onTap: () async {
                  String message="";
                  bool result;
                  if(passctrl.text.length<6)
                      setState(() {
                        message="Enter the password(max 6)";
                      });
                  else if(cpass_==null)
                      setState(() {
                        message="Please confirm new password";
                      });
                  else if(cpass_!=passctrl.text){
                      setState(() {
                        message="Password should match";
                      });

                  }
                  else{
                    result = await UpdateUserTable();
                    setState(() {
                      if(result){
                        message="Password updated successfull";
                        addPassToSF(cpass_);
                      }
                        
                      else
                        message="Something Went Wrong, try again";
                    });
                  }
                  Fluttertoast.showToast(msg: message,toastLength:  Toast.LENGTH_SHORT );
                  if(result){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    if(widget.forgot==null)
                      Navigator.pop(context);
                  }

                  // (namectrl == null) ? addNameToSF(widget.name) : addNameToSF(namectrl);
                  // (number == null) ? addNumberToSF(widget.number) : addNumberToSF(number);
                  // (companyname == null) ? addCompanyNameToSF(widget.companyname) : addCompanyNameToSF(companyname);
                  // name1 = await getName();
                  // email1 = await getEmail();
                  // companyname1 = await getCompanyName();
                  // number1 = await getNumber();
                  // bool result = await UpdateUserTable();
                  // result ? Fluttertoast.showToast(msg: 'Changes saved successfully',toastLength:  Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER ): Fluttertoast.showToast(msg: 'Something Went Wrong, try again',toastLength:  Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER );
                  
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xfff96060),
                  ),
                  child: Text('Change Password',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
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
  Future<bool> UpdateUserTable()async {
    var url = "https://355668.xyz/Authentication/forgot_pass.php";
    String email=await getEmail();
    var data = {
      "email" : widget.email??email,
      "pass":cpass_
    };
    var res = await http.post(url, body: data);
    if(jsonDecode(res.body) == "true"){
      return true;
    }else{
      return false;
    }
  }
}