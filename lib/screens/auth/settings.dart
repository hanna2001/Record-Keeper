import 'package:flutter/material.dart';

import '../../main.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xfff96060),
        title: Text('Settings'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Bar(Icons.person, 'Change Password'),
          GestureDetector(
              onTap: (){
                setState(() {
                  Logout();
                });
              },
              child: Bar(Icons.vpn_key, 'Logout')),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'V 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Record Keeper',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Container Bar(IconData icon, String title) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, 9),
                blurRadius: 20,
                spreadRadius: 1)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Color(0xfff96060),
              size: 30,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: TextStyle(
                color: Color(0xfff96060),
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
