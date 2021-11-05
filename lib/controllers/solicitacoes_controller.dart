import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class SolicitacoesController extends GetxController {
  SolicitacoesRepository solicitacoesRepository = SolicitacoesRepository();

  final _solicitacoes = <SolicitacaoModel>[].obs;

  List<SolicitacaoModel> get solicitacoes => _solicitacoes;
  set solicitacoes(value) => this._solicitacoes.assignAll(value);

  void getSolicitacoes(int matricula) {
    solicitacoesRepository
        .getSolicitacoes(matricula)
        .then((data) => {this._solicitacoes.assignAll(data)});
  }
}
