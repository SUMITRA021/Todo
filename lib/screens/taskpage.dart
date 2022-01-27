import 'package:flutter/material.dart';
import 'package:todo/database_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/widgets.dart';

class Taskpage extends StatefulWidget {

  final Task? task;
  Taskpage({required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  DatabaseHelper _dbhelper = DatabaseHelper();

  int _taskId =0;
  String ?_taskTitle ="";
  String _taskDescription ="";


  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible =false;


  @override
  void initState()
  {
    if(widget.task != null)
      {
        //set visibility true
        _contentVisible=true;

        _taskTitle = widget.task!.title;
        _taskDescription=widget.task!.description!;
        _taskId = widget.task!.id!;
      }

    _titleFocus = FocusNode();
    _descriptionFocus= FocusNode();
    _todoFocus =FocusNode();

    super.initState();
  }

  @override
  void dispose()
  {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:EdgeInsets.only(
                       top:24.0 ,
                        bottom:6.0 ,
                      ) ,
                      child: Row(
                        children: [
                             InkWell(
                               onTap: (){
                                 Navigator.pop(context);
                               },
                               child: Padding(
                                 padding: const EdgeInsets.all(24.0),
                                 child: Image(
                                     image:AssetImage(
                                           "assets/images/back_arrow_icon.png",
                                      ) ,
                                 ),
                               ),
                             ),

                          Expanded(
                            child: TextField(
                              focusNode: _titleFocus,
                              onSubmitted:(value) async{
                                print("Field Value: $value");

                                DatabaseHelper _dbhelper = DatabaseHelper();

                                //check if the field is not empty
                                if(value != "")
                                  {
                                      //check if the task is null
                                    if(widget.task == null){


                                      Task _newTask = Task(
                                          title: value
                                      );

                                      _taskId= await _dbhelper.insertTask(_newTask);
                                      setState(() {
                                        _contentVisible=true;
                                        _taskTitle=value;
                                      });
                                      print("new task Id: $_taskId");
                                    }
                                    else
                                      {
                                       await _dbhelper.updateTaskTitle(_taskId, value);
                                       print("task updated");

                                      }
                                    _descriptionFocus.requestFocus();
                                  }
                              },
                              controller: TextEditingController()..text = _taskTitle!,
                              decoration: InputDecoration(
                                hintText: "Enter Task Title",
                                border:InputBorder.none,
                              ),
                              style:TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551),
                              ) ,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: TextField(
                          focusNode: _descriptionFocus,
                          onSubmitted:(value) async{
                            if(value != "")
                              {
                                if(_taskId!=0)
                                  {
                                     await _dbhelper.updateTaskDescription(_taskId, value);
                                     _taskDescription=value;
                                  }
                              }
                            _todoFocus.requestFocus();
                          },
                          controller: TextEditingController()..text = _taskDescription,
                          decoration:InputDecoration(
                            hintText: "Enter Description for the task...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                          ) ,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _contentVisible,
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbhelper.getTodo(_taskId),
                        builder: (context, AsyncSnapshot snapshot)
                        {
                          return Expanded(
                            child: ListView.builder(
                              itemCount:snapshot.data.length ,
                              itemBuilder:(context, index)
                              {
                                return GestureDetector(
                                  onTap: () async{
                                    //switch thetodo completeion state
                                   if(snapshot.data[index].isDone == 0)
                                     {
                                       await _dbhelper.updateTodoDone(snapshot.data[index].id,1);
                                     }
                                   else
                                     {
                                       await _dbhelper.updateTodoDone(snapshot.data[index].id,0);
                                     }
                                   setState(() {});

                                  },
                                  child: TodoWidget(
                                    text: snapshot.data[index].title,
                                    isDone: snapshot.data[index].isDone ==0 ? false :true,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),


                     Visibility(
                       visible: _contentVisible,
                       child: Padding(
                         padding: EdgeInsets.symmetric(
                           horizontal: 24.0,
                         ),
                         child: Row(
                           children: [
                             Container(
                               width: 20.0,
                               height: 20.0,
                               margin: EdgeInsets.only(
                                 right: 12.0,
                               ),
                               decoration:BoxDecoration(
                                   color: Colors.transparent,
                                   borderRadius:BorderRadius.circular(6.0),
                                   border: Border.all(
                                     color: Color(0xFF868290),
                                     width: 1.5,
                                   )
                               ) ,
                               child: Image(
                                 image: AssetImage(
                                     "assets/images/check_icon.png"
                                 ),
                               ),
                             ),
                             Expanded(
                               child: TextField(
                                 focusNode: _todoFocus,
                                 controller:TextEditingController()..text= "" ,
                                 onSubmitted:(value) async{
                                   if(value != "")
                                   {
                                     //check if the task is null
                                     if(_taskId != 0){
                                       DatabaseHelper _dbhelper = DatabaseHelper();

                                       Todo _newTodo = Todo(
                                           title: value,
                                           isDone: 0,
                                           taskId: _taskId,
                                       );
                                       await _dbhelper.insertTodo(_newTodo);
                                       setState(() {});
                                       _todoFocus.requestFocus();
                                     }
                                   }
                                 },
                                    decoration: InputDecoration(
                                      hintText: "Enter Todo item...",
                                      border: InputBorder.none,
                                    ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     )
                


                  ],
                ),
                Visibility(
                  visible:_contentVisible,
                  child: Positioned(
                    bottom:24.0,
                    right: 24.0,
                    child: GestureDetector(
                      onTap: () async{
                        if(_taskId !=0)
                          {
                            await _dbhelper.deleteTask(_taskId);
                            Navigator.pop(context);
                          }
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFFFE3577),
                        ),
                        child: Image(
                          image:AssetImage(
                            "assets/images/delete_icon.png",
                          ) ,
                        ),
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
