
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/screens/taskpage.dart';
import 'package:todo/widgets.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

   DatabaseHelper _dbHelper =DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding:EdgeInsets.symmetric(
            horizontal: 24.0,
          ) ,
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Container(
                    margin:EdgeInsets.only(
                      bottom: 32.0,
                      top:32.0,
                    ),
                    child: Image(
                        image:AssetImage(
                          'assets/images/logo.png'
                        ),
                    ),
                  ),
                  Expanded(
                      child: FutureBuilder(
                          future: _dbHelper.getTasks(),
                          builder: (context,AsyncSnapshot<List<Task>>snapshot)=>
                             ScrollConfiguration(
                               behavior: NoGlowBehaviour(),
                               child: ListView.builder(
                                  itemCount:  snapshot.hasData ? snapshot.data!.length : 0,
                                  itemBuilder:(context,index)=> GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=>Taskpage(
                                            task: snapshot.data![index],
                                          )
                                          ),
                                      ).then((value)
                                      {
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCardWidgets(
                                        title: snapshot.data![index].title,
                                        desc: snapshot.data![index].description,
                                      ),
                                  ),

                            ),
                             ),

                      ),
                  )
                ],
              ),
              Positioned(
                bottom:24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Taskpage(task:null,)
                    )).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFF7349FE),Color(0xFF643FDE)],
                        begin: Alignment(0.0,-1.0),
                        end: Alignment(0.0,1.0),
                      ),
                    ),
                    child: Image(
                      image:AssetImage(
                        "assets/images/add_icon.png",
                      ) ,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
