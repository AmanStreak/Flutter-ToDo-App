import 'package:flutter/material.dart';
import 'package:mytodo/home.dart';
import 'package:mytodo/todoSingleTask.dart';
import 'todoTaskScreen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: TodoHome(),
    ),
//      routes: {
//        '/addTask': (context) => SingleTask(),
//      },
    routes: {
        '/home': (context) => TodoHome(),
    },
    );
  }
}