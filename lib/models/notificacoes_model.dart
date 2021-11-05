class NotificacoesModel {
  String titulo;
  String texto;
  String url;
  String imagemURL;
  String vigenciaInicial;
  String vigenciaFinal;
  var numero;
  int matricula;

  NotificacoesModel({
    this.titulo,
    this.texto,
    this.url,
    this.imagemURL,
    this.vigenciaInicial,
    this.vigenciaFinal,
    this.numero,
    this.matricula,
  });

  NotificacoesModel.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    texto = json['texto'];
    url = json['url'];
    imagemURL = json['imagemURL'];
    vigenciaInicial = json['vigenciaInicial'];
    vigenciaFinal = json['vigenciaFinal'];
    numero = json['numero'];
    matricula = json['matricula'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['texto'] = this.texto;
    data['url'] = this.url;
    data['imagemURL'] = this.imagemURL;
    data['vigenciaInicial'] = this.vigenciaInicial;
    data['vigenciaFinal'] = this.vigenciaFinal;
    data['numero'] = this.numero;
    data['matricula'] = this.matricula;
    return data;
  }
}
