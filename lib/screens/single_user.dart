import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:login_ui/config/icon.dart';
import 'package:login_ui/screens/utils/edit.dart';
import 'package:login_ui/screens/utils/share.dart';

class SingleUser extends StatefulWidget {
  List<Map<String, dynamic>> query;
  String name;
  SingleUser({ Key key, this.query, this.name }): super(key: key);

  @override
  _SingleUserState createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text(widget.name),),
      body: (widget.query.length == 0)
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
                      setState(() {
                        widget.query = query;
                      });
                      /* Take = await DatabaseHelper.instance.TotalToTake();
                      Give = await DatabaseHelper.instance.TotalToGive();
                      widget.Take = Take;
                      widget.Give = Give; */
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