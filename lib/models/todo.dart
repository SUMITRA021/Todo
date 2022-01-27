class Todo
{
  final int? id;
  final int? taskId;
  final String? title;
  final int? isDone;


  Todo({this.id,this.title,this.isDone,this.taskId});

  Map<String, dynamic> toMap()
  {
    return{
      'id':id,
      'taskId':taskId,
      'title':title,
      'isDone':isDone,

    };
  }

}