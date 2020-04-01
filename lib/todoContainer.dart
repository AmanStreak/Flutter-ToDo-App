import 'package:flutter/material.dart';

class TodoContainer extends StatefulWidget{
  @override
  TodoContainerState createState() => TodoContainerState();
}

class TodoContainerState extends State<TodoContainer>{


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        
        child: Card(

          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 150,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}