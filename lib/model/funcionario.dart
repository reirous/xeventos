import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:xeventos/model/acompanhante.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Funcionario {
  String nome;
  List<Acompanhante> acompanhante;
  DocumentReference reference;

  Funcionario({
    this.nome,
    this.acompanhante,
    this.reference
  });

  Future add() async{
    reference = await Firestore.instance.collection('Participante').add({'nome': nome});
  }

  Future del() async{
    await Firestore.instance.collection('Participante').document(reference.documentID).delete();
  }

  Future edt() async{
    await Firestore.instance.collection('Participante').document(reference.documentID).updateData({'nome': nome});
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'acompanhante': List<dynamic>.from(acompanhante.map((x) => x.toMap())),
    };
  }

  static Funcionario fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Funcionario(
      nome: map['nome'],
      acompanhante: List<Acompanhante>.from(map['acompanhante']?.map((x) => Acompanhante.fromMap(x))),
    );
  }

  @override
  String toString() => 'Funcionario(nome: $nome, acompanhante: $acompanhante)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Funcionario &&
      o.nome == nome &&
      listEquals(o.acompanhante, acompanhante);
  }

  @override
  int get hashCode => nome.hashCode ^ acompanhante.hashCode;
}
