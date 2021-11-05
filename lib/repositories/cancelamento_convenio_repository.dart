import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class CancelamentoConvenioRepository {
  Future<int> saveSolic(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/cancelamento/convenio', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
