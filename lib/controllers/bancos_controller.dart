import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class BancosController extends GetxController {
  BancosRepository bancosRepository = BancosRepository();

  final _bancos = <BancosModel>[].obs;

  List<BancosModel> get bancos => _bancos;
  set bancos(value) => this._bancos.assignAll(value);

  void getBancos() {
    bancosRepository.getBancos().then((data) => {this._bancos.assignAll(data)});
  }
}
