import 'package:defaultproject/services/database_controller.dart';
import 'package:defaultproject/view/content/content_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class HomePage extends StatelessWidget {
  final DatabaseController DbC = Get.put(DatabaseController());

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      dismissOnCapturedTaps: true,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[900],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SearchFormField(),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: Obx(()=> Container(
                        child: GridView.builder(
                          shrinkWrap: true,

                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: DbC.filtredTitles.value.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Get.to(ContentPage(), arguments: [DbC.filtredTitles[index], DbC.filtredData[index], index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[500],
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(DbC.filtredTitles.value[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.grey[900]
                                            ),
                                            overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      Text(DbC.filtredData.value[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey[700]
                                        ),
                                        overflow: TextOverflow.ellipsis,)
                                    ],
                                  ),


                                ),
                              ),
                            );
                          },
                        ),
                      ))
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: (){
                Get.to(ContentPage(), arguments: ["", "", -1]);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  CupertinoIcons.plus,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _SearchFormField() {
  DatabaseController _controller = Get.find();
  return Container(
    height: 36.0,
    margin: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(
        color: Colors.grey, // Set the color of the border
        width: 1.2, // Set the width of the border
      ),
    ),
    child: TextFormField(
      onChanged: _controller.getSearchText,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      ),
      style: TextStyle(color: Colors.grey), // Set the text color of the TextFormField
    ),
  );
}