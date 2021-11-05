import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class TermoLGPDRepository {
  Future<int> saveTermo(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/termoLGPD', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
