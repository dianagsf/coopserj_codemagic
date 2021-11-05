import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class ConveniosController extends GetxController {
  ConvenioRepository convenioRepository = ConvenioRepository();

  final _convenios = <ConvenioModel>[].obs;

  List<ConvenioModel> get convenios => _convenios;
  set convenios(value) => this._convenios.assignAll(value);

  void getConvenios(int matricula) {
    convenioRepository
        .getConvenios(matricula)
        .then((data) => {this._convenios.assignAll(data)});
  }
}
