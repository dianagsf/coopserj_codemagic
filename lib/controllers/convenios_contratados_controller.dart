import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class ConveniosContrController extends GetxController {
  ConveniosContrRepository conveniosContrRepository =
      ConveniosContrRepository();

  final _conveniosContr = <ConveniosContrModel>[].obs;

  List<ConveniosContrModel> get conveniosContr => _conveniosContr;
  set conveniosContr(value) => this._conveniosContr.assignAll(value);

  void getConveniosContr(int matricula) {
    conveniosContrRepository
        .getInfos(matricula)
        .then((data) => {this._conveniosContr.assignAll(data)});
  }
}
