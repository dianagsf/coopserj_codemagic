import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class EmpContratadosController extends GetxController {
  EmpContratadosRepository repositoryEmpContratados =
      EmpContratadosRepository();

  final _empContratados = <EmpContratadosModel>[].obs;

  List<EmpContratadosModel> get empContratados => _empContratados;
  set empContratados(value) => this._empContratados.assignAll(value);

  void getEmpContratados(int matricula) {
    repositoryEmpContratados
        .getInfos(matricula)
        .then((data) => {this._empContratados.assignAll(data)});
  }
}
