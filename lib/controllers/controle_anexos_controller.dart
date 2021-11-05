import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class ControleAnexosController extends GetxController {
  ControleAnexosRepository controleAnexosRepository =
      ControleAnexosRepository();

  final _controleAnexos = <ControleAnexoModel>[].obs;

  List<ControleAnexoModel> get controleAnexos => _controleAnexos;
  set controleAnexos(value) => this._controleAnexos.assignAll(value);

  void getControleInfos() {
    controleAnexosRepository
        .getInfosControle()
        .then((data) => {this._controleAnexos.assignAll(data)});
  }
}
