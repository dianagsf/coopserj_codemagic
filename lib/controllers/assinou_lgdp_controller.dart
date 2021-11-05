import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class AssinouLGDPController extends GetxController {
  AssinouLGDPRepository assinouLGDPRepository = AssinouLGDPRepository();

  final _assinatura = <AssinouLGDPModel>[].obs;

  List<AssinouLGDPModel> get assinatura => _assinatura;
  set assinatura(value) => this._assinatura.assignAll(value);

  void getAssinatura() {
    assinouLGDPRepository.getAssinatura().then(
          (data) => {this._assinatura.assignAll(data)},
        );
  }
}
