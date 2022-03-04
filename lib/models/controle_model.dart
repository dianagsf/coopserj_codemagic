class ControleModel {
  int iNTEGRACAO;
  String vERSAO;
  double taxaIOF;
  double taxaFatorIOF;
  double taxaRefin;

  ControleModel({
    this.iNTEGRACAO,
    this.vERSAO,
    this.taxaIOF,
    this.taxaFatorIOF,
    this.taxaRefin,
  });

  ControleModel.fromJson(Map<String, dynamic> json) {
    iNTEGRACAO = json['INTEGRACAO'];
    vERSAO = json['VERSAO'];
    taxaIOF = json['TAXA_IOF'];
    taxaFatorIOF = json['FATOR_IOF'];
    taxaRefin = json['TAXA_REFIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['INTEGRACAO'] = this.iNTEGRACAO;
    data['VERSAO'] = this.vERSAO;
    data['TAXA_IOF'] = this.taxaIOF;
    data['FATOR_IOF'] = this.taxaFatorIOF;
    data['TAXA_REFIN'] = this.taxaRefin;
    return data;
  }
}
