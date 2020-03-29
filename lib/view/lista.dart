import 'package:flutter/material.dart';

class Lista extends StatelessWidget {
  final List<List<String>> lista;
  final int totalFunc;
  final int totalAcomp;

  Lista({Key key, @required this.lista, this.totalFunc, this.totalAcomp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Participantes"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(index.toString() + ") " + lista[index][0] +
                  (lista[index][1].length > 0 ? lista[index][1] : "" )),
                );
              },                      
            )
          ),
           
        ],
      ),
    );
  }
}