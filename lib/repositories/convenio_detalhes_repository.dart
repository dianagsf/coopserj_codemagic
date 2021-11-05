import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class ConvenioDetalhesRepository {
  Future<List<ConvenioDetalhesModel>> getConveniosDetalhes(int contrato) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/convenios/detalhes?contrato=$contrato');
      return (response.data as List)
          .map((sol) => ConvenioDetalhesModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
