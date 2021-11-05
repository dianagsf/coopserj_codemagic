class ControleAnexoModel {
  int numero;
  String data;
  int matricula;
  var solic;

  ControleAnexoModel({this.numero, this.data, this.matricula, this.solic});

  ControleAnexoModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    data = json['data'];
    matricula = json['matricula'];
    solic = json['solic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['data'] = this.data;
    data['matricula'] = this.matricula;
    data['solic'] = this.solic;
    return data;
  }
}
