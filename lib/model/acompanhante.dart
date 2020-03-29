import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Acompanhante {
  String nome;
  String parentesco;
  DocumentReference reference;

  Acompanhante({
    this.nome,
    this.parentesco,
    this.reference
  });

  Acompanhante copyWith({
    String nome,
    String parentesco,
    DocumentReference reference
  }) {
    return Acompanhante(
      nome: nome ?? this.nome,
      parentesco: parentesco ?? this.parentesco,
      reference: reference ?? this.reference
    );
  }

  
  Future add(DocumentReference doc)async{
    reference = await Firestore.instance.collection('Participante').
    document(doc.documentID).collection('Acompanhante').add({'nome': nome,'parentesco':parentesco});
  }

  Future del(DocumentReference doc) async{
    await Firestore.instance.collection('Participante').
    document(doc.documentID).collection('Acompanhante').document(reference.documentID).delete();
  }
  
  Future edt(DocumentReference doc) async{
    await Firestore.instance.collection('Participante').document(doc.documentID).
    collection('Acompanhante').document(reference.documentID).updateData({'nome': nome, 'parentesco': parentesco});
  }


  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'parentesco': parentesco,
      'reference': reference
    };
  }

  static Acompanhante fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Acompanhante(
      nome: map['nome'],
      parentesco: map['parentesco'],
      reference: map['reference']
    );
  }

  String toJson() => json.encode(toMap());

  static Acompanhante fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Acompanhante(nome: $nome, parentesco: $parentesco)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Acompanhante &&
      o.nome == nome &&
      o.parentesco == parentesco &&
      o.reference == reference;
  }

  @override
  int get hashCode => nome.hashCode ^ parentesco.hashCode ^ reference.hashCode;
}
