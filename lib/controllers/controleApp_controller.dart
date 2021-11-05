import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class ControleAppController extends GetxController {
  ControleRepository controleRepository = ControleRepository();

  final _controleAPP = <ControleModel>[].obs;

  List<ControleModel> get controleAPP => _controleAPP;
  set controleAPP(value) => this._controleAPP.assignAll(value);

  void getControleInfos() {
    controleRepository
        .getInfosControle()
        .then((data) => {this._controleAPP.assignAll(data)});
  }
}
