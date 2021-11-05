class EmpContratadosModel {
  var desconto;
  int quantidade;
  var total;

  EmpContratadosModel({this.desconto, this.quantidade, this.total});

  EmpContratadosModel.fromJson(Map<String, dynamic> json) {
    desconto = json['desconto'];
    quantidade = json['quantidade'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['desconto'] = this.desconto;
    data['quantidade'] = this.quantidade;
    data['total'] = this.total;
    return data;
  }
}
