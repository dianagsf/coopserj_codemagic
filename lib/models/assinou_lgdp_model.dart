class AssinouLGDPModel {
  int matricula;

  AssinouLGDPModel({
    this.matricula,
  });

  AssinouLGDPModel.fromJson(Map<String, dynamic> json) {
    matricula = json['matricula'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['matricula'] = this.matricula;
    return data;
  }
}
