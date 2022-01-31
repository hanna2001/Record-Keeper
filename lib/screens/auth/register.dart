import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/palette.dart';
import '../../main.dart';
import '../home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namectrl, emailctrl, passctrl;
  bool pass = true;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namectrl = new TextEditingController();
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
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: TextField(
                    controller: namectrl,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: emailctrl,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
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
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
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
                        'Register',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: _LoadingIndicator(isLoading),
                        ),
                      ),
                      _RoundContinueButton(
                          isLoading),
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

  void registerUser() async {
    setState(() {
      isLoading = true;
    });
    var url = "https://355668.xyz/Authentication/register.php";
    var data = {
      "email": emailctrl.text,
      "name": namectrl.text,
      "pass": passctrl.text,
    };
    var res = await http.post(url, body: data);

      if (jsonDecode(res.body) == "Account already exists") {
        print('Account already exists, Please login');
        Fluttertoast.showToast(
            msg: 'Account already exists, Please login',
            toastLength: Toast.LENGTH_LONG);
      } else {
        if (jsonDecode(res.body) == "true") {
          print('Account Created');
          Fluttertoast.showToast(
              msg: "Account Created", toastLength: Toast.LENGTH_SHORT);
          List<Map<String, dynamic>> query =
              await DatabaseHelper.instance.queryAll();
          List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
          int Take = await DatabaseHelper.instance.TotalToTake();
          int Give = await DatabaseHelper.instance.TotalToGive();
          addEmailToSF(emailctrl.text);
          addPassToSF(passctrl.text);
          addNameToSF(namectrl.text);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(query2, Give, Take)));
        } else {
          Fluttertoast.showToast(
              msg: "Error, Try Again later", toastLength: Toast.LENGTH_LONG);
        }
      }
    setState(() {
      isLoading = false;
    });
  }

  Widget _RoundContinueButton(isLoading) {
    return RawMaterialButton(
      onPressed: () {
        (namectrl.text == '' || emailctrl.text == '' || passctrl.text == '') ? print('not done') : registerUser();
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
