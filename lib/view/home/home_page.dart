import 'package:defaultproject/services/database_controller.dart';
import 'package:defaultproject/view/content/content_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  final DatabaseController DbC = Get.put(DatabaseController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[900],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
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
                        itemCount: DbC.titles.value.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              Get.to(ContentPage(), arguments: [DbC.titles[index], DbC.data[index], index]);
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
                                      child: Text(DbC.titles.value[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                            fontSize: 25,
                                            color: Colors.grey[900]
                                          ),
                                          overflow: TextOverflow.ellipsis
                                      ),
                                    ),
                                    Text(DbC.data.value[index],
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
    );
  }
}