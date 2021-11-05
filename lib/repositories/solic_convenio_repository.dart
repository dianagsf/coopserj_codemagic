import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class SolicConvenioRepository {
  Future<int> createSolic(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/solicitar/convenio', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
