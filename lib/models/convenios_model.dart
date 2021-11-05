class ConvenioModel {
  int numero;
  var valor;
  String nome;
  String dataInicio;
  int npc;
  var prestacao;
  var devedor;

  ConvenioModel({
    this.numero,
    this.valor,
    this.nome,
    this.dataInicio,
    this.npc,
    this.prestacao,
    this.devedor,
  });

  ConvenioModel.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    valor = json['valor'];
    nome = json['nome'];
    dataInicio = json['datainicio'];
    npc = json['npc'];
    prestacao = json['PRESTACAO'];
    devedor = json['devedor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['valor'] = this.valor;
    data['nome'] = this.nome;
    data['datainicio'] = this.dataInicio;
    data['npc'] = this.npc;
    data['PRESTACAO'] = this.prestacao;
    data['devedor'] = this.devedor;
    return data;
  }
}
