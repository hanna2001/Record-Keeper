import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/config/database_helper.dart';
import '../home.dart';


class Edit extends StatefulWidget {
  String Name;
  int id;
  String number,desc;
  int Amount,icon;
  Edit(this.id,this.Name, this.Amount,this.number,this.desc,this.icon);
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String _controller1,_controller3,_controller4;
  int amount,_controller2=0;
  List<bool> selected=[false,false,false,false,false,false,false,false];
  
  String label='food';
  int index=0;
  int selectedIndex;
  @override
  void initState() {
    amount = widget.Amount;
    setState((){
      selected[widget.icon]=true;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
               Navigator.pop(context);
              }),
          backgroundColor: Color(0xfff96060),
          title: Text('Edit'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  initialValue: widget.Name,
                  maxLength:25,
                  style: TextStyle(fontSize: 18),
                  onChanged: (value){
                    _controller1 = value;
                  },
                ),

                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),

                TextFormField(
                  initialValue: '$amount',
                  style: TextStyle(fontSize: 18),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (input) => _controller2 = num.tryParse(input),
                ),
                SizedBox(height: 20,),
                Text(
                  'Mobile No.',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  initialValue: widget.number,
                  maxLength: 10,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    _controller3 = value;
                  },
                ),
                
                Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 12,),
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
                TextFormField(
                  initialValue: widget.desc,
                  onChanged: (value){
                    _controller4 = value;
                  },
                  maxLength: 255,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 25,),
                Center(
                  child: InkWell(
                    onTap: () async {
                      int update = await DatabaseHelper.instance.update({
                        DatabaseHelper.columnId: widget.id,
                        DatabaseHelper.columnName: (_controller1 == null)? widget.Name : _controller1,
                        DatabaseHelper.columnAmount: (_controller2 == 0)? widget.Amount : _controller2,
                        DatabaseHelper.columnPhone: (_controller3 == null) ? widget.number : _controller3,
                        DatabaseHelper.columnDescription: (_controller4 == null) ? widget.desc : _controller4,
                        DatabaseHelper.columnIcon: (selectedIndex==null) ? widget.icon : selectedIndex
                      });
                      List<Map<String, dynamic>> query = await DatabaseHelper.instance.queryAll();
                      List<Map<String, dynamic>> query2 =
                        await DatabaseHelper.instance
                            .uniqueNames();
                      int Take = await DatabaseHelper.instance.TotalToTake();
                      int Give = await DatabaseHelper.instance.TotalToGive();
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Home(query2,Give,Take)));
//                    Navigator.pop(context,MaterialPageRoute(builder: (context) => Home(query,Give,Take)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Color(0xfff96060),
                      ),
                      child: SizedBox(
                        height: 50,
                        width: 100,
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: ()  {
                     Navigator.pop(context);
                    },
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
                              style: TextStyle(color: Colors.black, fontSize: 15,letterSpacing: 1),
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
    
      selected=[false,false,false,false,false,false,false,false];

  }
}
