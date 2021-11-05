import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SolicitacoesRepository {
  Future<List<SolicitacaoModel>> getSolicitacoes(int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.get('/solicitacoes?matricula=$matricula');
      return (response.data as List)
          .map((sol) => SolicitacaoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
