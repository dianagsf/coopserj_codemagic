import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class PedidoQuitacaoController extends GetxController {
  PedidoQuitacaoRepository pedidoQuitacaoRepository =
      PedidoQuitacaoRepository();

  final _pedidosQuitacao = <PedidoQuitacaoModel>[].obs;

  List<PedidoQuitacaoModel> get pedidosQuitacao => _pedidosQuitacao;
  set pedidosQuitacao(value) => this._pedidosQuitacao.assignAll(value);

  void getPedidosQuitacao() {
    pedidoQuitacaoRepository
        .getQuitacaoAnalise()
        .then((data) => {this._pedidosQuitacao.assignAll(data)});
  }
}
