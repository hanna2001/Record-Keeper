import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_ui/config/database_helper.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'home.dart';

class Add extends StatefulWidget {
  List<Map<String, dynamic>> query;
  int Take,Give;
  Add(this.query,this.Give,this.Take);
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController _controller1 = new TextEditingController();
  int _controller2;
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();
  bool toggleValue = true;
  int Take = 0, Give = 0;
  List<bool> selected=[false,false,false,false];
  int index=0;
  int selectedIndex=3;
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
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10,),
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Eg. John Doe',
                  ),
                  maxLength: 25,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  controller: _controller1,
                ),
                Text(
                  'Amount',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Eg. ₹100',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (input) =>
                  _controller2 = num.tryParse(input),
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Eg. 9999999999',
                  ),
                  controller: _controller3,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                        children: [
                          option('Food',0),
                          option('Shopping',1),
                          option('Medical',2),
                          option('Others',3),
                          // option('Vacation',4),
                          // option('Entertainment',5),
                          // option('',6),
                          // option('Food',7),
                        ],
                        ),
                      ),
                    ),
                    InkWell(
                      child: Icon(Icons.cancel,
                      ),
                      onTap: (){
                        setState(() {
                           clearAll();
                          selectedIndex=null;
                        });
                       
                      },
                    )
                  ],
                ),
                TextField(
                  decoration:  InputDecoration(fillColor: Colors.white24,
                  filled: true),
                  maxLength: 255,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  controller: _controller4,
                ),
                SizedBox(height: 15,),
                Center(
                  child: ToggleSwitch(
                    minWidth: 100.0,
                    initialLabelIndex: 0,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.black26,
                    inactiveFgColor: Colors.white,
                    labels: ['Take', 'Give'],
                    activeBgColors: [Colors.green, Color(0xfff96060)],
                    onToggle: (index) {
                      print(toggleValue);
                      if(index == 0){
                        toggleValue = true;
                      }else{
                        toggleValue = false;
                      }
                    },
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: Text(
                      'Select Take if you have to Take a money. \n Select Give if you have to give money.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: InkWell(
                    onTap: () async {
                      if(_controller1.text=='')
                      {
                          Fluttertoast.showToast(msg: 'Please enter name');
                      }
                      else if(_controller2==null)
                      {
                          Fluttertoast.showToast(msg: 'Please enter amount');
                      }
                      else{
                        int i =
                        await DatabaseHelper.instance.insert({
                          DatabaseHelper.columnName:
                          _controller1.text.trim(),
                          DatabaseHelper.columnAmount:
                          _controller2,
                          DatabaseHelper.columnPhone:
                          _controller3.text,
                          DatabaseHelper.columnCondition:
                          (toggleValue == false)
                              ? 'Give'
                              : 'Take',
                          DatabaseHelper.columnDescription: _controller4.text,
                          DatabaseHelper.columnIcon: selectedIndex
                        });
                        
                        //ORIGINAL
                        List<Map<String, dynamic>> query =
                        await DatabaseHelper.instance
                            .queryAll();

                        //TESTING 1
                        List<Map<String, dynamic>> query1 =
                        await DatabaseHelper.instance
                            .queryName("Akhilesh");
                        //print(query1.toString());

                        //TESTING 2
                        List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
                        print(query2.toString());


                        Take = await DatabaseHelper.instance.TotalToTake();
                        Give = await DatabaseHelper.instance.TotalToGive();
                        widget.Take = Take;
                        widget.Give = Give;
                        closePopup();
                        setState(() {
                          _controller1.text = '';
                          _controller3.text = '';
                          _controller2 = 0;
                          widget.query = query2;
                          toggleValue = false;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(8)),
                        color: Color(0xfff96060),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                     closePopup();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Padding option(String label,int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(color: Colors.black),
                        ),
                        selectedColor: Colors.grey,
                        selected: selected[index],
                        onSelected:(value){
                          setState(() {
                            clearAll();
                            selected[index]=!selected[index];
                            selectedIndex=index;
                          });
                        },
                      ),
    );
  }
  

  void clearAll(){
    
      selected=[false,false,false,false];

  }
  
  closePopup() async{
    List<Map<String, dynamic>> query =
        await DatabaseHelper.instance.queryAll();
    List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
     Map<dynamic,dynamic>query3 = new Map<dynamic,dynamic>();

        for(int i=0;i<query2.length;i++) {
          var x = await DatabaseHelper.instance.namedTotalToTake(query2[i]['name'].toString());
          var y = await DatabaseHelper.instance.namedTotalToGive(query2[i]['name'].toString());
          query3[query2[i]['name']] = x-y;
        }

        print(query3.toString());
    int Take1 = await DatabaseHelper.instance.TotalToTake();
    int Give1 = await DatabaseHelper.instance.TotalToGive();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> Home(query2,Give1,Take1,query3)));
  }
}


