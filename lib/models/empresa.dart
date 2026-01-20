class Empresa {
  String? id;
  String? nome;
  String? endereco;
  String? cnpj;

  Empresa({
    this.id,
    this.nome,
    this.endereco,
    this.cnpj,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['id'] as String?,
      nome: json['nome'] as String?,
      endereco: json['endereco'] as String?,
      cnpj: json['cnpj'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cnpj': cnpj,
    };
  }
}
