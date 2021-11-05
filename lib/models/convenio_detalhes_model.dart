class ConvenioDetalhesModel {
  int contrato;
  int parcela;
  String vencimento;
  String situacao;
  var valor;
  String dataPag;

  ConvenioDetalhesModel(
      {this.contrato,
      this.parcela,
      this.vencimento,
      this.situacao,
      this.valor,
      this.dataPag});

  ConvenioDetalhesModel.fromJson(Map<String, dynamic> json) {
    contrato = json['CONTRATO'];
    parcela = json['PARCELA'];
    vencimento = json['VENCIMENTO'];
    situacao = json['SITUACAO'];
    valor = json['VALOR'];
    dataPag = json['DATAPAG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CONTRATO'] = this.contrato;
    data['PARCELA'] = this.parcela;
    data['VENCIMENTO'] = this.vencimento;
    data['SITUACAO'] = this.situacao;
    data['VALOR'] = this.valor;
    data['DATAPAG'] = this.dataPag;
    return data;
  }
}
