class CategoriasModel {
  String codigo;
  String nome;

  CategoriasModel({this.codigo, this.nome});

  CategoriasModel.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    return data;
  }
}
