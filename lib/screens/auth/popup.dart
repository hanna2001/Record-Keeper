import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/config/database_helper.dart';

import 'home.dart';

class PopUp extends StatefulWidget {
  List<Map<String, dynamic>> query;
  int Take,Give;
  PopUp(this.query,this.Give,this.Take);
  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  TextEditingController _controller1 = new TextEditingController();
int _controller2;
TextEditingController _controller3 = new TextEditingController();
String popup = 'close';
bool toggleValue = false;
int Take = 0, Give = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
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
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      controller: _controller1,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Amount',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    TextFormField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        hintText: 'Eg. ₹100',
                      ),
                      onChanged: (input) =>
                      _controller2 = num.tryParse(input),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To Give',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: 35,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: toggleValue
                                ? Colors.green
                                : Color(0xfff96060),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration:
                                Duration(milliseconds: 1000),
                                curve: Curves.easeIn,
                                top: 1.0,
                                left: toggleValue ? 50.0 : 0.0,
                                right: toggleValue ? 0.0 : 50.0,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      toggleValue = !toggleValue;
                                      print(toggleValue);
                                    });
                                  },
                                  child: AnimatedSwitcher(
                                      duration: Duration(
                                          milliseconds: 1000),
                                      transitionBuilder:
                                          (Widget child,
                                          Animation<double>
                                          animation) {
                                        return RotationTransition(
                                          child: child,
                                          turns: animation,
                                        );
                                      },
                                      child: toggleValue
                                          ? Icon(Icons.fast_forward,
                                          color: Colors.white,
                                          size: 35)
                                          : Icon(
                                        Icons.fast_rewind,
                                        color: Colors.white,
                                        size: 35,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'To Take',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          int i =
                          await DatabaseHelper.instance.insert({
                            DatabaseHelper.columnName:
                            _controller1.text,
                            DatabaseHelper.columnAmount:
                            _controller2,
                            DatabaseHelper.columnPhone:
                            _controller3.text,
                            DatabaseHelper.columnCondition:
                            (toggleValue == false)
                                ? 'Give'
                                : 'Take',
                          });
                          List<Map<String, dynamic>> query =
                          await DatabaseHelper.instance
                              .queryAll();
                          Take = await DatabaseHelper.instance.TotalToTake();
                          Give = await DatabaseHelper.instance.TotalToGive();
                          widget.Take = Take;
                          widget.Give = Give;
                          closePopup();
                          setState(() {
                            _controller1.text = '';
                            _controller3.text = '';
                            _controller2 = 0;
                            widget.query = query;
                            toggleValue = false;
                          });
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
                      height: 9,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                           closePopup();
                          });
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
            ),
          ),
        ),
      ),
    );
  }
  closePopup()async{
    List<Map<String, dynamic>> query =
    await DatabaseHelper.instance.queryAll();
    Take = await DatabaseHelper.instance.TotalToTake();
    Give = await DatabaseHelper.instance.TotalToGive();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(query,Give,Take)));
  }
}
