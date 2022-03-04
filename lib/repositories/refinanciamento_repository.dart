import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class RefinanciamentoRepository {
  Future<int> saveRefin(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/refin', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
