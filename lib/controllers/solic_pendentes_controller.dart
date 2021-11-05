import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class SolicPendentesController extends GetxController {
  SolicPendentesRepository solicitacoesPendentesRepository =
      SolicPendentesRepository();

  final _solicPendentes = <SolicPendentesModel>[].obs;

  List<SolicPendentesModel> get solicPendentes => _solicPendentes;
  set solicPendentes(value) => this._solicPendentes.assignAll(value);

  void getSolicPendentes(int matricula) {
    solicitacoesPendentesRepository
        .findAll(matricula)
        .then((data) => {this._solicPendentes.assignAll(data)});
  }
}
