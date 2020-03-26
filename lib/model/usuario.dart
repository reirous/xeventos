
class Usuario {
  final String usuario;
  final String senha;
  Usuario({
    this.usuario,
    this.senha,
  });



  Usuario copyWith({
    String usuario,
    String senha,
  }) {
    return Usuario(
      usuario: usuario ?? this.usuario,
      senha: senha ?? this.senha,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'senha': senha,
    };
  }

  static Usuario fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Usuario(
      usuario: map['usuario'],
      senha: map['senha'],
    );
  } 

  @override
  String toString() => 'Usuario(usuario: $usuario, senha: $senha)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Usuario &&
      o.usuario == usuario &&
      o.senha == senha;
  }

  @override
  int get hashCode => usuario.hashCode ^ senha.hashCode;
}
