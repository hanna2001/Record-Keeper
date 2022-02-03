import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/screens/single_user.dart';
import 'package:login_ui/screens/utils/share.dart';
//import 'package:share/share.dart';
import 'add.dart';
import 'utils/edit.dart';
import 'more.dart';
import '../config/icon.dart';

class Home extends StatefulWidget{
  List<Map<String, dynamic>> query;
  Map<dynamic,dynamic> data;
  int Take, Give;
  Home(this.query, this.Give, this.Take,this.data);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  
  String popup = 'close';
  bool toggleValue = false;
  int Take = 0, Give = 0;
  int take1;int take2;
  namedTake(name) async => await DatabaseHelper.instance.namedTotalToGive(name);

  getNamedTotaltoGive(String name)async{

    int total = await DatabaseHelper.instance.namedTotalToGive(name);
    
    print(name+" "+total.toString());
    return total;

  }

  
  getNamedTotaltoTake(String name)async{

    int total = await DatabaseHelper.instance.namedTotalToTake(name);
    return total;

  }

    
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {

        exit(0);
        //return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xfff96060),
          title: Text('Record Keeper'),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            //STARTING TWO BOXES
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xfff96060),
              ),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //AMOUNT TO TAKE PART
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Amount to Take',
                                style: TextStyle(
                                    color: Color(0xfff96060),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '₹' + widget.Take.toString(),
                                style: TextStyle(
                                  color: Color(0xfff96060),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    //AMOUNT TO GIVE PART
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Amount to Give',
                                style: TextStyle(
                                    color: Color(0xfff96060),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '₹' + widget.Give.toString(),
                                style: TextStyle(
                                  color: Color(0xfff96060),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //TODO: EDIT FROM HERE
            Expanded(
              child: (widget.query.length == 0)
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '+',
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            'Add New Record',
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: new ListView.builder(
                        physics: BouncingScrollPhysics(),
                          itemCount: widget.query.length,
                          itemBuilder: (BuildContext context, int index){
                         
                            //print(widget.query.toString());
                            var x =getNamedTotaltoGive(widget.query[index]['name'].toString());
                            
                             
                            
                            
                            return Card(
                                  child: ListTile(
                                    onTap:()async{
                                      List<Map<String, dynamic>> query1 =  await DatabaseHelper.instance .queryName(widget.query[index]['name'].toString());
                                      int namedTake = await DatabaseHelper.instance.namedTotalToTake(widget.query[index]['name'].toString());
                                      int namedGive = await DatabaseHelper.instance.namedTotalToGive(widget.query[index]['name'].toString());
                                      
                                      Navigator.push(context, 
                                      MaterialPageRoute(builder: (context)=>SingleUser(query: query1,name:widget.query[index]['name'].toString(),Take: namedTake, Give: namedGive)));
                                    },
                                    
                                    title: Text(widget.query[index]['name'].toString()),
                                    trailing: Text(
                                      widget.data[widget.query[index]['name'].toString()
                                      ].abs().toString(), style: TextStyle(
                                        color: widget.data[widget.query[index]['name']]>0? Colors.green : Colors.red,
                                      )
                                    ),
                                    
                                  )
                                
                              );
                            

                            
                            /* return taskWidget(
                                (widget.query[index]['condition'] == 'Give')
                                    ? Color(0xfff96060)
                                    : Colors.green,
                                widget.query[index]['name'],
                                widget.query[index]['amount'],
                                widget.query[index]['_id'],
                                widget.query[index]['number'],
                                widget.query[index]['condition'],
                                widget.query[index]['description'],
                                widget.query[index]['icon']);*/ 
                          }) ,
                    ),
            ),
            //BOTTOM NAVIGATION BAR HERE
            Container(
              height: 120,
              child: Stack(
                children: [
                  //HOME AND MORE BUTTON
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xff292e4e),
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: "you Are already at Home",
                                  toastLength: Toast.LENGTH_SHORT);
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => More()));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.view_module,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'More',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //ADD BUTTON
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: openPopup,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xfff96060),
                                      Colors.red
                                    ]),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 50, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Add',
                          style:
                              TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  openPopup() async {
    List<Map<String, dynamic>> query = await DatabaseHelper.instance.queryAll();
    
    int Take1 = await DatabaseHelper.instance.TotalToTake();
    int Give1 = await DatabaseHelper.instance.TotalToGive();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Add(query, Give1, Take1)));
  }

  Slidable taskWidget(Color color, String name, int amount, int id,
      String number, String condition, String desc, int icon) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1)
        ]),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${iconNumber[(icon)]}  $condition ₹$amount',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50,
              width: 5,
              color: color,
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: 'Edit',
          color: Colors.white,
          icon: Icons.edit,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Edit(id, name, amount, number, desc, icon)));
          },
        ),
        IconSlideAction(
          caption: 'Delete',
          color: color,
          icon: Icons.delete,
          onTap: () {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Confirm Delete"),
                content: Text("You want to Delete record of $name"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      int i = await DatabaseHelper.instance.delete(id);
                      print(i);
                      List<Map<String, dynamic>> query =
                          await DatabaseHelper.instance.queryAll();
                      setState(() {
                        widget.query = query;
                      });
                      Take = await DatabaseHelper.instance.TotalToTake();
                      Give = await DatabaseHelper.instance.TotalToGive();
                      widget.Take = Take;
                      widget.Give = Give;
                      setState(() {});
                      Navigator.of(ctx).pop();
                    },
                    color: Color(0xfff96060),
                    padding: EdgeInsets.all(12.0),
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.white,
          icon: Icons.share,
          onTap: () {
            if (condition == 'Take') {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Reminder('! Reminder ! \n$name you have to Give me ₹$amount Rupees for $desc.',false)));
//              Share.share(
//                  "! *Reminder* ! \n$name you have to Give me ₹$amount Rupees");
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Reminder('! Reminder ! \n$name you have to Take Rupees ₹$amount from me which you had Paid for $desc.',false)));
//              Share.share(
//                  "! *Reminder* ! \n$name you have to Take Rupees ₹$amount from me");
            }
          },
        ),
      ],
    );
  }
}
