import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import 'package:login_ui/main.dart';
import 'package:login_ui/screens/auth/change_password.dart';
import 'package:login_ui/screens/auth/forgotpass_email.dart';
import '../home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailctrl, passctrl;
  bool pass = true;
  bool isLoading = false;
  @override
  void initState() {
    
    super.initState();
    emailctrl = new TextEditingController();
    passctrl = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome\nBack',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextField(
                    controller: emailctrl,
                    decoration: InputDecoration(
                      hintText: 'Email',
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: passctrl,
                    obscureText: pass,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 20),
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
                            color: Colors.black54,
                            size: 25,
                          ),
                        )),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EnterEmail()));
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                        decoration: TextDecoration.underline
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
                        'Sign In',
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
    );
  }

  void LoginUser() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://355668.xyz/Authentication/login.php";
    var data = {
      "email": emailctrl.text,
      "pass": passctrl.text,
    };
    var res = await http.post(url, body: data);
    var body=jsonDecode(res.body);
    print(body);
    if (body['result'] == "dont have account") {
      print("if");
      Fluttertoast.showToast(
          msg: "Dont have Account, Please register",
          toastLength: Toast.LENGTH_LONG);
          print("Dont have Account, Please register");
    } else {
      print("else");
      if (body['result'] =="false") {
        Fluttertoast.showToast(
            msg: "Incorrect Password", toastLength: Toast.LENGTH_SHORT);
        print('Incorrect Password');
      } else {
        //TODO: CHANGES MADE
        List<Map<String, dynamic>> query =
            await DatabaseHelper.instance.queryAll();
        
        List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();

        
            
        int Take = await DatabaseHelper.instance.TotalToTake();
        int Give = await DatabaseHelper.instance.TotalToGive();

        addEmailToSF(emailctrl.text);
        addPassToSF(passctrl.text);
        addNameToSF(body['name']);
        addCompanyNameToSF(body['company']);
        addNumberToSF(body['phone']);
        
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home(query2, Give, Take)));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _RoundContinueButton(isLoading) {
    return RawMaterialButton(
      onPressed: () {
        (emailctrl.text == '' || passctrl.text == '')
            ? Fluttertoast.showToast(
            msg: 'Please Enter Email And password',
            toastLength: Toast.LENGTH_LONG)
            : LoginUser();
      },
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
