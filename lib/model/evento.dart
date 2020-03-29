import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Evento {
  String titulo;
  String descricao;
  Timestamp dataHora;
  String local;

  
  Evento({
    this.titulo,
    this.descricao,
    this.dataHora,
    this.local,
  });

  Evento copyWith({
    String titulo,
    String descricao,
    Timestamp dataHora,
    String local,
  }) {
    return Evento(
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      dataHora: dataHora ?? this.dataHora,
      local: local ?? this.local,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'dataHora': dataHora,
      'local': local,
    };
  }

  static Evento fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Evento(
      titulo: map['titulo'],
      descricao: map['descricao'],
      dataHora: map['dataHora'],
      local: map['local'],
    );
  }

  String toJson() => json.encode(toMap());

  static Evento fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'Evento(titulo: $titulo, descricao: $descricao, dataHora: $dataHora, local: $local)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Evento &&
      o.titulo == titulo &&
      o.descricao == descricao &&
      o.dataHora == dataHora &&
      o.local == local;
  }

  @override
  int get hashCode {
    return titulo.hashCode ^
      descricao.hashCode ^
      dataHora.hashCode ^
      local.hashCode;
  }
}
