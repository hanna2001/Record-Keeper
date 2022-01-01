import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../main.dart';
import 'package:http/http.dart'as http;

class Profile extends StatefulWidget {
  String name,email,companyname;
  int number;
  Profile(this.name,this.email,this.number,this.companyname);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String namectrl, emailctrl, companyname,name1, email1, companyname1;
  int number,number1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
        backgroundColor: Color(0xfff96060),
        title: Text('Profile'
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text(
                widget.email[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),),
              backgroundColor: Color(0xfff96060),
              radius: 50,
            ),
            SizedBox(height: 15,),
            TextFormField(
              onChanged: (value) {
                namectrl = value;
              },
              initialValue: widget.name.toString(),
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black54,
                  size: 25,
                ),
              ),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 15,),
            TextFormField(
              readOnly: true,
              initialValue: widget.email.toString(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black54,
                  size: 25,
                ),
                hintText: 'Registered email',
              ),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 15,),
            TextFormField(
              initialValue:  widget.number == null ? '' : widget.number
                  .toString(),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (input) => number = num.tryParse(input),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black54,
                  size: 25,
                ),
                hintText: 'Phone Number',
              ),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 15,),
            TextFormField(
              initialValue: widget.companyname == null ? '' : widget.companyname
                  .toString(),
              onChanged: (value) {
                companyname = value;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.business_center,
                  color: Colors.black54,
                  size: 25,
                ),
                hintText: 'Company/Shop Name',
              ),
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Container(height: 100,),
            Center(
              child: InkWell(
                onTap: () async {
                  (namectrl == null) ? addNameToSF(widget.name) : addNameToSF(namectrl);
                  (number == null) ? addNumberToSF(widget.number) : addNumberToSF(number);
                  (companyname == null) ? addCompanyNameToSF(widget.companyname) : addCompanyNameToSF(companyname);
                  name1 = await getName();
                  email1 = await getEmail();
                  companyname1 = await getCompanyName();
                  number1 = await getNumber();
                  bool result = await UpdateUserTable();
                  result ? Fluttertoast.showToast(msg: 'Changes saved successfully',toastLength:  Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER ): Fluttertoast.showToast(msg: 'Something Went Wrong, try again',toastLength:  Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER );;
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xfff96060),
                  ),
                  child: Text('Save',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black,
                              fontSize: 15,
                              letterSpacing: 1),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<bool> UpdateUserTable()async {
    var url = "https://355668.xyz/Authentication/update_info.php";
    var data = {
      "email": email1 == null ? '' : email1,
      "name": name1 == null ? '' : name1,
      "ShopName": companyname1 == null ? '' : companyname1,
      "number": number1.toString() == null ? '' : number1.toString(),
    };
    var res = await http.post(url, body: data);
    if(jsonDecode(res.body) == "true"){
      return true;
    }else{
      return false;
    }
  }
}

