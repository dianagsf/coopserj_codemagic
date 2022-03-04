class CategoriasTaxasModel {
  var taxa;
  int minParcela;
  int maxParcela;
  String codigoCategoria;

  CategoriasTaxasModel({
    this.taxa,
    this.minParcela,
    this.maxParcela,
    this.codigoCategoria,
  });

  CategoriasTaxasModel.fromJson(Map<String, dynamic> json) {
    taxa = json['taxa'];
    minParcela = json['min_parcela'];
    maxParcela = json['max_parcela'];
    codigoCategoria = json['codigo_categoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taxa'] = this.taxa;
    data['min_parcela'] = this.minParcela;
    data['max_parcela'] = this.maxParcela;
    return data;
  }
}
