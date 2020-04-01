import 'package:flutter/material.dart';
import 'todoSingleTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TodoMainSingleTask extends StatefulWidget{
  final String title, description;
  int taskId;
  TodoMainSingleTask(this.title, this.description, this.taskId);
  @override
  TodoMainSingleTaskState createState()=> TodoMainSingleTaskState(this.title, this.description, this.taskId);
}

class TodoMainSingleTaskState extends State<TodoMainSingleTask>{
  String documentName;
  int totalTasks;

  deleteTask() async{
    await Firestore.instance.collection("tasks").where('id', isEqualTo: taskId).snapshots().listen((data){
//      print(data.documents[0].documentID);
      DocumentSnapshot ds = data.documents[0];
      documentName = ds.documentID;
      print(documentName);
      deleteFromFirebase();
    });
  }

  deleteFromFirebase() async{
    await Firestore.instance.collection("tasks").document(documentName).delete();
    await Firestore.instance.collection('tasksCount').document('totalCount').get().then((data){
      totalTasks = data['totalTasks'];
      totalTasks -= 1;
      print(totalTasks);
      updateTotalTasks();
    });
  }

  updateTotalTasks() async{
    print('updated $totalTasks');
    await Firestore.instance.collection('tasksCount').document('totalCount').updateData({'totalTasks': totalTasks}).then((data){
      print('DONE');
    });
    Navigator.of(context).pop();
  }
  final String title, description;
  int taskId;
  TodoMainSingleTaskState(this.title, this.description, this.taskId);
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(child: Icon(Icons.edit, color: Colors.blue,),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SingleTask(title, description, taskId)),
              );
            },),
          ),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Align(child: Text(title),
                  alignment: Alignment.centerLeft,),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black38,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(description),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.delete,
        color: Colors.white),
        onPressed: (){
          deleteTask();
        },
      ),
    );
  }
}