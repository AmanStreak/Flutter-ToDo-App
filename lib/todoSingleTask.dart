import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'databaseHelper.dart';
class SingleTask extends StatefulWidget{
  String title, description;
  int taskId;
  SingleTask(

      this.title,
      this.description,
      this.taskId);
  @override
  SingleTaskState createState() => SingleTaskState(this.title, this.description, this.taskId);
}

class SingleTaskState extends State<SingleTask>{
  String t, d, taskDocument;
  List docsx = [];
  int taskId;
  SingleTaskState(
      this.t,
      this.d,
      this.taskId
      );

  final _formkey = GlobalKey<FormState>();
  String title, description;
  int id;
  int totalTasks;

  final titleControl = TextEditingController();
  final descControl = TextEditingController();


  void saveForm() async{
    print(title);
    print(taskId);
    if(_formkey.currentState.validate()){
      _formkey.currentState.save();
//      titleControl.clear();
      if(taskId != null){
        pushToFirebase();
      }
      else{
        getTaskCount();
      }
//      descControl.clear();

      print(description);
    }
  }

  getTaskCount() async{
    await Firestore.instance.collection("tasksCount").document("totalCount").get().then((data){
      if(data.exists){
        totalTasks = data['totalTasks'];
        debugPrint("get $totalTasks");
        totalTasks += 1;
      }
      else{
        totalTasks = 1;
      }
    }).whenComplete((){
      pushToFirebase();
    });

  }

  Future pushToFirebase() async{
    print("hey $taskId");
    if(taskId == null){
      debugPrint('CREATE');
      id = DateTime.now().millisecondsSinceEpoch;
      TodoDatabase db = TodoDatabase(this.title, this.description, this.id);
//    if(totalTasks == 0){
//      totalTasks = 1;
//      debugPrint("if $totalTasks");
//    }
//    else{
//      totalTasks += 1;
//      debugPrint("else $totalTasks");
//    }
      await Firestore.instance.collection("tasks").document(id.toString()).setData(db.todoMap()).whenComplete((){
        print("when Done");
      }).then((data){
        print("then done");
      });
      debugPrint("amam $totalTasks");
      await Firestore.instance.collection("tasksCount").document("totalCount").setData({'totalTasks': totalTasks});
    }
    else{
      debugPrint('EDIT');
      print("EDIT");
      await Firestore.instance.collection("tasks").where('id', isEqualTo: taskId).snapshots().listen((data) {
        debugPrint('DOIT');
        DocumentSnapshot ds = data.documents[0];
        taskDocument = ds.documentID;
        updateFirebaseData();
//        print(taskDocument.runtimeType);
      });
    }
  }

  updateFirebaseData() async{
    debugPrint('uptodate');
    debugPrint('taskdoc $taskDocument');
    await Firestore.instance.collection("tasks").document(taskDocument).updateData({'title': title, 'description': description}).then((data){
      print('taskkkkupdated');
    });
  }


  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(

        body: SingleChildScrollView(
          child: Container(

            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: MyClip(),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("TASKS",

                      style: TextStyle(
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white,
                      )),
                    ),
                    color: Colors.blue,
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
//              padding:
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            initialValue: t,
//                        controller: titleControl,
                            validator: (input){
                              if(input.isEmpty){
                                return "Enter title";
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                              labelText: "Title",
                              prefixIcon: Icon(Icons.title),
                            ),
                            onSaved: (input) => title = input,
                          ),
                          TextFormField(
                            initialValue: d,
//                        controller: descControl,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Description",

                              prefixIcon: Icon(Icons.description),
                            ),
                            onSaved: (input) => description = input,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 70),
                          ),
                          GestureDetector(
                            onTap: (){
                              saveForm();
                            },
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.blue,

                                ),
                                padding: EdgeInsets.only(top: 10, bottom: 10, left: 28, right: 28),
                                child: Text("SUBMIT", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  letterSpacing: 2.0,
                                )),
                              ),
                            ),
                          ),
                        ],
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
}

class MyClip extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.quadraticBezierTo(size.width/4, size.height - 70, size.width/2, size.height - 30);
    path.quadraticBezierTo(size.width * 0.75, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}