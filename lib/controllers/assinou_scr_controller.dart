import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class AssinouSCRController extends GetxController {
  AssinouSCRRepository assinouSCRRepository = AssinouSCRRepository();

  final _assinatura = <AssinouSCRModel>[].obs;

  List<AssinouSCRModel> get assinatura => _assinatura;
  set assinatura(value) => this._assinatura.assignAll(value);

  void getAssinatura() {
    assinouSCRRepository.getAssinatura().then(
          (data) => {this._assinatura.assignAll(data)},
        );
  }
}
