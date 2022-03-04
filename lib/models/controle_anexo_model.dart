class ControleAnexoModel {
  int numero;
  String data;
  int matricula;
  var solic;
  String tipo;

  ControleAnexoModel({
    this.numero,
    this.data,
    this.matricula,
    this.solic,
    this.tipo,
  });

  ControleAnexoModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    data = json['data'];
    matricula = json['matricula'];
    solic = json['solic'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['solic'] = this.solic;
    data['tipo'] = this.tipo;
    return data;
  }
}
