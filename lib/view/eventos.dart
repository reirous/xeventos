
import 'package:flutter/material.dart';
import 'package:xeventos/model/acompanhante.dart';
import 'package:xeventos/model/funcionario.dart';
import 'package:xeventos/services/crud.dart';


class Eventos extends StatefulWidget{

  @override
  _EventosPageState createState() => _EventosPageState();

}


class _EventosPageState extends State<Eventos>{

    crudMethods crudObj = new crudMethods();
    final funcionarioControler = TextEditingController();
    Acompanhante acompanhante = new Acompanhante();
    List _funcionarioList = [];

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
          //crudObj.addAcompanhante({'documento':_funcionarioList[index].reference.documentId, 'nome':newAcompanhante.nome,'parentesco':newAcompanhante.parentesco});
          newAcompanhante.add(_funcionarioList[index].reference);
        }
      );
    }

    Future<bool> addDialog(BuildContext context, int index) async{
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
    
    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text('Inserir Presença'),
          actions: <Widget>[
            IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed:(){ Navigator.pushReplacementNamed(context, '/');},
                    )
          ],
        ),
        body: Column(
            children: <Widget>[
               Container(
                padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField( 
                        controller: funcionarioControler,
                        decoration: new InputDecoration(
                          hintText: 'Nome do Funcionário'
                        ),
                        maxLength: 100 
                      )
                    ) ,
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: addParticipacao ,
                    )
                  ],
                )
              ),
              Expanded(
                flex: 2,
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
                    child: Text('Adicionar Acompanhante'),
                    onPressed: (){
                      addDialog(context, index);
                    }
                  ), 
                ] 
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
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
      //                          padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
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
