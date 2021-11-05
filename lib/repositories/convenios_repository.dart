import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class ConvenioRepository {
  Future<List<ConvenioModel>> getConvenios(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/convenios/?matricula=$matricula');
      return (response.data as List)
          .map((sol) => ConvenioModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
