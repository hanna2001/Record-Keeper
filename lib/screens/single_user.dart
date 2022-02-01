import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/icon.dart';
import 'package:login_ui/screens/home.dart';
import 'package:login_ui/screens/utils/edit.dart';
import 'package:login_ui/screens/utils/share.dart';

class SingleUser extends StatefulWidget {
  List<Map<String, dynamic>> query;
  String name; int Take,Give;
  SingleUser({ Key key, this.query, this.name, this.Take, this.Give}): super(key: key);

  @override
  _SingleUserState createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  int Take; int Give;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: Color(0xfff96060),
        leading:  IconButton(icon: Icon(Icons.arrow_back), 
        onPressed: ()async{
          Take = await DatabaseHelper.instance.TotalToTake();
          Give = await DatabaseHelper.instance.TotalToGive();
          widget.Take = Take;
          widget.Give = Give;
          List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(query2,Give,Take)));
        }
      ),
        title: Text(widget.name),
      ),
      body: (widget.query.length == 0)
          ? Center(
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '!',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'All records of User Deleted',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
          )
          : Column(
            children: [

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


              Container(
                  child: new ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                      itemCount: widget.query.length,
                      itemBuilder: (BuildContext context, int index) {
                           
                         return taskWidget(
                            (widget.query[index]['condition'] == 'Give')
                                ? Color(0xfff96060)
                                : Colors.green,
                            widget.query[index]['name'],
                            widget.query[index]['amount'],
                            widget.query[index]['_id'],
                            widget.query[index]['number'],
                            widget.query[index]['condition'],
                            widget.query[index]['description'],
                            widget.query[index]['icon']); 
                      }) ,
                ),
            ],
          )

    );
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
                      List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .queryName(widget.name);
                      setState(() {
                        widget.query = query2;
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