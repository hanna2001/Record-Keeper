import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatelessWidget {
  const Help({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    openwhatsapp() async {
      //TODO:Update Number
      var whatsapp = "+919144040888";
      var whatsappURl_android =
          "whatsapp://send?phone=" + whatsapp + "&text=hello";
      var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappURL_ios)) {
          await launch(whatappURL_ios, forceSafariVC: false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunch(whatsappURl_android)) {
          await launch(whatsappURl_android);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("whatsapp no installed")));
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("Help and Support"),
            backgroundColor: Color(0xfff96060)),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.message, color: Color(0xfff96060)),
                onTap: () {
                  openwhatsapp();
                },
                title: Text("Help on WhatsApp"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.call, color: Color(0xfff96060)),
                onTap: () async {
                  //TODO : Update Number
                  String url = 'tel:' + "8793997821";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
                title: Text("Call us"),
              ),
            ),
          )

          //TODO: add FAQ
        ]));
  }
}
