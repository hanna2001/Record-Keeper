import 'package:flutter/material.dart';
import 'package:login_ui/screens/more/about_us.dart';
import 'package:login_ui/screens/more/help.dart';
import 'package:login_ui/screens/more/profile.dart';
import 'package:login_ui/screens/more/settings.dart';
import 'package:login_ui/screens/utils/share.dart';
import '../main.dart';



class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        }),
        backgroundColor: Color(0xfff96060),
        title: Text('Record Keeper'
        ),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ListView(
              children: [
                GestureDetector(onTap: () async {
                  String Name = await getName();
                  String email = await getEmail();
                  String companyname = await getCompanyName();
                  int number = await getNumber();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(Name,email,number,companyname)));},child: Bar(Icons.person, 'Profile')),
                GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));},child: Bar(Icons.settings, 'Settings')),
                GestureDetector(
                    onTap: (){
                      setState(() {
                        Logout();
                      });
                    },
                    child: Bar(Icons.vpn_key, 'Logout')),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
                    },
                    child: Bar(Icons.info_outline, 'About Us')),
                //TODO: Add help and support page
                GestureDetector(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Help()));},
                  child: Bar(Icons.help_outline, 'Help & Support')),
                GestureDetector(
                  child: Bar(
                    Icons.share, 'Invite Friends'
                    ),
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Reminder('Hey check out this app!!',true)));

                  },
                  ),
                SizedBox(height: 20,),
                Center(child: Text('V 1.0.0',style: TextStyle(color: Colors.grey,fontSize:13),),),
                SizedBox(height: 10,),
                Center(child: Text('Record Keeper',style: TextStyle(color: Colors.grey,fontSize:16),),),
              ],
            ),
          ]
        ),
      ),
    );
  }
  Container Bar(IconData icon, String title){
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1
          )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon,color: Color(0xfff96060),size: 30,),
            Text(title,
            style: TextStyle(
              color: Color(0xfff96060),
              fontSize: 20,
            ),
            ),
            Icon(Icons.arrow_forward_ios,
            color: Color(0xfff96060),
            )
          ],
        ),
      ),
    );
  }
}
