class SolicPendentesModel {
  int numero;
  String data;
  int matricula;
  var valor;
  int np;
  var prestacao;
  var contratos;

  SolicPendentesModel({
    this.numero,
    this.data,
    this.matricula,
    this.valor,
    this.np,
    this.prestacao,
    this.contratos,
  });

  SolicPendentesModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    data = json['data'];
    matricula = json['matricula'];
    valor = json['valor'];
    np = json['np'];
    prestacao = json['prestacao'];
    contratos = json['CONTRATOS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['valor'] = this.valor;
    data['np'] = this.np;
    data['prestacao'] = this.prestacao;
    data['CONTRATOS'] = this.contratos;
    return data;
  }
}
