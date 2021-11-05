import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class ConvenioDetalhesController extends GetxController {
  ConvenioDetalhesRepository convenioDetalhesRepository =
      ConvenioDetalhesRepository();

  final _conveniosDetalhes = <ConvenioDetalhesModel>[].obs;

  List<ConvenioDetalhesModel> get conveniosDetalhes => _conveniosDetalhes;
  set conveniosDetalhes(value) => this._conveniosDetalhes.assignAll(value);

  void getConveniosDetalhes(int contrato) {
    convenioDetalhesRepository
        .getConveniosDetalhes(contrato)
        .then((data) => {this._conveniosDetalhes.assignAll(data)});
  }
}
