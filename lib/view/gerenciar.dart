import 'package:flutter/material.dart';


class Gerenciar extends StatelessWidget{

    @override
    Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color.fromRGBO(51, 102, 255, 1.0),Color.fromRGBO(255, 245, 250, 1.0)]
            )
          ),
        ),
      );
    }
}