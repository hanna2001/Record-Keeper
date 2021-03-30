import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/screens/auth/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  bool check = false;
  check = await CheckLogin();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'avenir',
        ),
//        home: check == false ? Login():Pin(),
      home: Splash(check),
  ));
}

addEmailToSF(var email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
}
addPassToSF(var pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('pass', pass);
}
addNameToSF(var name) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('Name', name);
}
addCompanyNameToSF(var companyname) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('companyName', companyname);
}
addNumberToSF(var number) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('Number', number);
}
Future<String> getName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('Name');
}
Future<String> getCompanyName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('companyName');
}
Future<int> getNumber() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('Number');
}
Future<String> getPass() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('pass');
}
Future<String> getEmail() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}
Future<bool> CheckLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString('email') ?? null;
  if(email == null) {
    return false;
  }else{
    return true;
  }
}

Logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('email');
  prefs.remove('pass');
  prefs.remove('Number');
  prefs.remove('companyName');
  exit(0);
}