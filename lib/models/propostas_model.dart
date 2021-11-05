class PropostaModel {
  int numero;
  String data;
  var valor;
  var valorcr;
  var prestacao;
  int npc;
  int npf;
  var saldoDevedor;
  var valorQuitacao;

  PropostaModel({
    this.numero,
    this.data,
    this.valor,
    this.valorcr,
    this.prestacao,
    this.npc,
    this.npf,
    this.saldoDevedor,
    this.valorQuitacao,
  });

  PropostaModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    data = json['data'];
    valor = json['valor'];
    valorcr = json['valorcr'];
    prestacao = json['prestacao'];
    npc = json['npc'];
    npf = json['npf'];
    saldoDevedor = json['saldo_devedor'];
    valorQuitacao = json['valor_quitacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['data'] = this.data;
    data['valor'] = this.valor;
    data['valorcr'] = this.valorcr;
    data['prestacao'] = this.prestacao;
    data['npc'] = this.npc;
    data['npf'] = this.npf;
    data['saldo_devedor'] = this.saldoDevedor;
    data['valor_quitacao'] = this.valorQuitacao;

    return data;
  }
}
