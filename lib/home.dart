import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytodo/todoSingleTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'todoTaskScreen.dart';
import 'package:connectivity/connectivity.dart';
//import 'todoContainer.dart';
class TodoHome extends StatefulWidget{
  @override
  TodoHomeState createState() => TodoHomeState();
}

class TodoHomeState extends State<TodoHome>{

//  var connectionStatus = 'Unknown';

  bool status = false;

  var connectivity;


  StreamSubscription<ConnectivityResult> subscription;


  String title, description, containerdesc;
  String tit, desc, t, d;
  int taskId, newTaskId;

  @override
  void initState(){
    super.initState();
    connectivity = new Connectivity();

    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      print('connecty $result');
      if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
        setState((){
          status = true;
        });
      }
      else{
        setState(() {
          status = false;
        });
      }
    });
  }


  @override
  void dispose(){
    super.dispose();
    connectivity.dispose();
    subscription.cancel();
  }


  Widget todoContainer(String title, String desc){
    if(desc.length > 25){
      containerdesc = desc.substring(0, 10) + "...";
    }
    else{
      containerdesc = desc;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Align(child: Text(title, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20.0,
                ),), alignment: Alignment.topLeft,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10.0,),
                child: Align(child: Text(containerdesc, style: TextStyle(

                  fontSize: 17.0,
                ),), alignment: Alignment.centerLeft,),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 120,
          width: 100,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(

      ),
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              curve: Curves.ease,
              child: Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: FlutterLogo(size: 30.0,),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('My Tasks', style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushNamed('/home');
              },
              title: Text('Home', style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              )),
              leading: Icon(Icons.home),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('My Tasks', style: TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              )),
            ),
          ],
        ),

      ),
//      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.black38,
        child: status ? Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0,),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: Firestore.instance.collection("tasks").snapshots(),
                  builder: (BuildContext context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: Container(child: CircularProgressIndicator()));
                    }
                    return ListView.builder(
                      
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int i){
                        title = snapshot.data.documents[i]['title'];
                        description = snapshot.data.documents[i]['description'];
                        return GestureDetector(
                          onTap: (){
                            tit = snapshot.data.documents[i]['title'];
                            desc = snapshot.data.documents[i]['description'];
                            taskId = snapshot.data.documents[i]['id'];

                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => TodoMainSingleTask(tit, desc, taskId)
                                )
                            );
                          },
                          child: Container(

                            child: todoContainer(title, description),
                          ),
                        );
                      },
                    );
                  }
              ),
            ),
          ],
        ) : Center(child: Image.network('https://cdn.dribbble.com/users/3364725/screenshots/6720353/no__2x.png')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: (){
          print(t);
          print(d);
          print('task $taskId');
//          Navigator.pushNamed(context, '/addTask');
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SingleTask(t, d, newTaskId),
          ));

        },
      ),
    );
  }
}