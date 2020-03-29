import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xeventos/model/acompanhante.dart';
import 'package:xeventos/model/funcionario.dart';
import 'package:xeventos/services/crud.dart';


class Gerenciar extends StatefulWidget{

  @override
  _GerenciarPageState createState() => _GerenciarPageState();

}

class _GerenciarPageState extends State<Gerenciar>{

    _GerenciarPageState(){
      selectData();
    }

    crudMethods crudObj = new crudMethods();
    final funcionarioControler = TextEditingController();
    Acompanhante acompanhante = new Acompanhante();
    List _funcionarioList = [];

    Future selectData() async{
        QuerySnapshot queryFunc = await Firestore.instance.collection('Participante').getDocuments();
        QuerySnapshot queryAcomp;
        if (queryFunc != null){
          for(int i = 0; i < queryFunc.documents.length; i++ ){
              Funcionario funcionario = new Funcionario();
              funcionario.nome = queryFunc.documents[i].data['nome'];
              funcionario.reference = queryFunc.documents[i].reference;
              funcionario.acompanhante = new List<Acompanhante>();
              _funcionarioList.add(funcionario);
              queryAcomp = await Firestore.instance.collection('Participante').
              document(funcionario.reference.documentID).collection('Acompanhante').getDocuments();
              for(int j = 0; j < queryAcomp.documents.length; j++){
                Acompanhante acompanhante = new Acompanhante();
                acompanhante.nome = queryAcomp.documents[j].data['nome'];
                acompanhante.parentesco = queryAcomp.documents[j].data['parentesco'];
                acompanhante.reference = queryAcomp.documents[j].reference;
                _funcionarioList[i].acompanhante.add(acompanhante);
              }
          }
        }
      atualizaState();
    }

    void atualizaState() async{
      setState(() {
        
      });
    }

    void addParticipacao() async{
       setState(
         () {
          Funcionario newFuncionario = Funcionario();
          newFuncionario.nome = funcionarioControler.text;
          newFuncionario.acompanhante = new List<Acompanhante>();
          //DocumentReference doc = Firestore.instance.collection('Participante').add({'nome':newFuncionario.nome});
          //newFuncionario.reference = doc.documentID;
          newFuncionario.add();
          _funcionarioList.add(newFuncionario);
        }
      );
    }
 
    void addAcompanhante(int index){
       setState(
         () { 
          Navigator.of(context).pop();
          Acompanhante newAcompanhante = Acompanhante();
          newAcompanhante.nome = acompanhante.nome;
          newAcompanhante.parentesco = acompanhante.parentesco;
          _funcionarioList[index].acompanhante.add(newAcompanhante);
          newAcompanhante.add(_funcionarioList[index].reference);
        }
      );
    }

    void edtParticipacao(int index) async{
       setState(
         () {
          Navigator.of(context).pop();
          _funcionarioList[index].edt();
        }
      );
    }

    void edtAcompanhante(int indexPai, int index) async{
       setState(
         () {
          Navigator.of(context).pop();
          _funcionarioList[indexPai].acompanhante[index].edt(_funcionarioList[indexPai].reference);
          //DocumentReference doc = Firestore.instance.collection('Participante').add({'nome':newFuncionario.nome});
          //newFuncionario.reference = doc.documentID;
        }
      );
    }

    void delParticipacao(DismissDirection direction, BuildContext context, int index) {
      setState(
        () {
          String nomeRemovido = _funcionarioList[index].nome;
          _funcionarioList[index].del();
          _funcionarioList.removeAt(index);

          final snack = SnackBar(
            content: Text('\"${nomeRemovido}\" removido(a)!'),
            duration: Duration(seconds: 5),
          );
          Scaffold.of(context).showSnackBar(snack);
        }
      );
    }

    void delAcompanhante(DismissDirection direction, BuildContext context, int indexFunc, int indexAcomp) {
      setState(
        () {
          String nomeRemovido = _funcionarioList[indexFunc].acompanhante[indexAcomp].nome;
          String nomeFuncionario = _funcionarioList[indexFunc].nome;
          _funcionarioList[indexFunc].acompanhante[indexAcomp].del(_funcionarioList[indexFunc].reference);
          _funcionarioList[indexFunc].acompanhante.removeAt(indexAcomp);

          final snack = SnackBar(
            content: Text('Acompanhante \"${nomeRemovido}\" do(a) funcionario (a) \"${nomeFuncionario}\" removido(a)!'),
            duration: Duration(seconds: 5),
          );
          Scaffold.of(context).showSnackBar(snack);
        }
      );
    }
    
    Future<bool> addAcompDialog(BuildContext context, int index) async{
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Adicionar Acompanhante', style: TextStyle(fontSize: 15.0),),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Nome do Acompanhante'),
                  onChanged: (value){
                    this.acompanhante.nome = value;
                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(hintText: 'Parentesco do Acompanhante'),
                  onChanged: (value){
                    this.acompanhante.parentesco = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                textColor: Colors.blue,
                onPressed: (){
                            Navigator.of(context).pop();
                          } 
              ),
              FlatButton(
                child: Text('Inserir'),
                textColor: Colors.blue,
                onPressed: (){addAcompanhante(index);} 
              )
            ],

          );
        }
      );
    }

    Future<bool> edtAcompDialog(BuildContext context, int indexPai, int index) async{
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Editar Acompanhante', style: TextStyle(fontSize: 15.0),),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: _funcionarioList[indexPai].acompanhante[index].nome),
                  onChanged: (value){
                    _funcionarioList[indexPai].acompanhante[index].nome = value;
                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(hintText: _funcionarioList[indexPai].acompanhante[index].parentesco),
                  onChanged: (value){
                    _funcionarioList[indexPai].acompanhante[index].parentesco = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                textColor: Colors.blue,
                onPressed: (){
                            Navigator.of(context).pop();
                          } 
              ),
              FlatButton(
                child: Text('Editar'),
                textColor: Colors.blue,
                onPressed: (){edtAcompanhante(indexPai, index);} 
              )
            ],

          );
        }
      );
    }

    Future<bool> edtDialog(BuildContext context, int index) async{
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Editar inscrição', style: TextStyle(fontSize: 15.0),),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: _funcionarioList[index].nome),
                  onChanged: (value){
                    _funcionarioList[index].nome = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                textColor: Colors.blue,
                onPressed: (){
                            Navigator.of(context).pop();
                          } 
              ),
              FlatButton(
                child: Text('Editar'),
                textColor: Colors.blue,
                onPressed: (){edtParticipacao(index);} 
              )
            ],

          );
        }
      );
    }

    
    @override
    Widget build(BuildContext context){
      //selectData();
      return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Presentes'),
          actions: <Widget>[            
            IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed:(){ Navigator.pushReplacementNamed(context, '/');},
                    )
          ],
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.only(top: 10.0),
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemCount: _funcionarioList.length,
                    itemBuilder: funcionarioBuilder,  
                    shrinkWrap: true,                       
                )
              ) 
            ],
          )
      );
    }

    Widget funcionarioBuilder(context, index) {
    //Widget responsável por permitir dismiss
    int indexPai = index;
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      //A propriedade "background" representa o fundo da nossa tile, o fundo em si não possui ações
      //As ações estão no evento onDismissed
      background: Container(
        color: Colors.redAccent,
      ),
      direction: DismissDirection.startToEnd,
      child: Container(
        padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
        color: Colors.lightBlue,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_funcionarioList[index].nome),
                  ),
                  RaisedButton(
                    child: Text('Editar'),
                    onPressed: (){
                       edtDialog(context, index);
                    }
                  ), 
                  RaisedButton(
                    child: Text('Adicionar Acompanhante'),
                    onPressed: (){
                      addAcompDialog(context, index);
                    }
                  ), 
                ] 
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(1.0, 1.0, 10.0, 1.0),
                        itemCount: _funcionarioList[index].acompanhante.length,
                        itemBuilder:  (BuildContext context, int index){
                            return Dismissible(
                              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                              //A propriedade "background" representa o fundo da nossa tile, o fundo em si não possui ações
                              //As ações estão no evento onDismissed
                              background: Container(
                                color: Colors.redAccent,
                              ),
                              direction: DismissDirection.startToEnd,
                              child: Container(
                                height: 40,
                                color: Colors.cyan,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('Nome acompanhante: ' + _funcionarioList[indexPai].acompanhante[index].nome,
                                                  style: TextStyle(fontSize: 16.0)),
                                    ),            
                                    Expanded(
                                      child: Text('Parentesco:' + _funcionarioList[indexPai].acompanhante[index].parentesco,
                                                  style: TextStyle(fontSize: 16.0)),
                                    ),
                                    RaisedButton(
                                      child: Text('Editar'),
                                      onPressed: (){
                                         edtAcompDialog(context, indexPai, index);
                                      }
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (direction){
                                delAcompanhante(direction, context, indexPai, index);
                              },
                            );
                        },
                        shrinkWrap: true,                    
                    )
                  )  
                ],
              ),
            )            
          ],
        )
      ),
      onDismissed: (direction){
        delParticipacao(direction, context, index);
      },
    );
  }

}

