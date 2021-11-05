class AssociadoModel {
  int matricula;
  String nome;
  String cpf;
  String nascimento;
  String email;
  String telefone;
  String senha;
  int bloqueia;

  AssociadoModel({
    this.matricula,
    this.nome,
    this.cpf,
    this.nascimento,
    this.email,
    this.telefone,
    this.senha,
    this.bloqueia,
  });

  AssociadoModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
    nome = json['nome'];
    cpf = json['cpf'];
    nascimento = json['nascimento'];
    email = json['email'];
    telefone = json['tel'];
    senha = json['senha'];
    bloqueia = json['bloqueia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['nascimento'] = this.nascimento;
    data['email'] = this.email;
    data['tel'] = this.telefone;
    data['senha'] = this.senha;
    data['bloqueia'] = this.bloqueia;
    return data;
  }
}
