import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class NotificacoesController extends GetxController {
  NotificacoesRepository notificacoesRepository = NotificacoesRepository();

  final _notificacoes = <NotificacoesModel>[].obs;

  List<NotificacoesModel> get notificacoes => _notificacoes;
  set notificacoes(value) => this._notificacoes.assignAll(value);

  void getNotificacoes(int matricula) {
    notificacoesRepository
        .getNotificacoes(matricula)
        .then((data) => {this._notificacoes.assignAll(data)});
  }
}
