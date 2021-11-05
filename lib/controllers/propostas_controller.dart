import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class PropostaController extends GetxController {
  PropostaRepository propostaRepository = PropostaRepository();

  final _propostas = <PropostaModel>[].obs;

  List<PropostaModel> get propostas => _propostas;
  set propostas(value) => this._propostas.assignAll(value);

  void getPropostasUser(int matricula) {
    propostaRepository
        .getPropostas(matricula)
        .then((data) => {this._propostas.assignAll(data)});
  }
}
