import 'package:defaultproject/services/database_controller.dart';
import 'package:defaultproject/view/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  DatabaseController DbC = Get.find();
  var arguments = Get.arguments;
  bool unchangedTitle = true;
  bool unchangedData = true;
  String unsavedTitle = "";
  String unsavedData = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (unchangedData == true && unchangedTitle == true){
                        Get.back();
                      }
                      else{
                        showSaveChangesDialog(context, unsavedTitle, unchangedTitle, unsavedData, unchangedData, arguments[2], true);
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextField(
                onChanged: (text) {
                  unchangedTitle = false;
                  unsavedTitle = text;
                },
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Untitled',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  )
                ),
                controller: TextEditingController(text: arguments[0])
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      TextField(
                        maxLines: null, // Allows unlimited lines
                        onChanged: (text) {
                          unchangedData = false;
                          unsavedData = text;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                        controller: TextEditingController(text: arguments[1])
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> showSaveChangesDialog(BuildContext context, title, changeTitle, value, changeData, index, wasEmpty) async {
  DatabaseController DbC = Get.find();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        content: Text('Do you want to save the changes?', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              Get.off(HomePage());
            },
            child: Container(
              height: 30,
              width: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[800]
              ),
              child: Center(child: Text("Cancel", style: TextStyle(color: Colors.white))),
            ),
          ),
          GestureDetector(
            onTap: (){
              DbC.save(title, changeTitle, value, changeData, index);
              Get.off(HomePage());
            },
            child: Container(
              height: 30,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[800]
              ),
              child: Center(child: Text("Save", style: TextStyle(color: Colors.white),)),
            ),
          )
        ],
      );
    },
  );
}