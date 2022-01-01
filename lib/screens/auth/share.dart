import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Reminder extends StatefulWidget {
  String defaultMsg;
  bool invite;
  Reminder(this.defaultMsg,this.invite);
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  String customMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
        }),
        backgroundColor: Color(0xfff96060),
        title: Text('Add'
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text(
              widget.invite?'Invite a friend':'Customize your Message',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              initialValue: widget.defaultMsg,
              maxLength: 255,
              maxLines: 3,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              onChanged: (value){
                customMsg = value;
              },
            ),
            SizedBox(height: 20,),
            Center(
              child: InkWell(
                onTap: () async {
                  (customMsg == null) ? Share.share(widget.defaultMsg) : Share.share(customMsg);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 85, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xfff96060),
                  ),
                  child: Text('Share',
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
}
