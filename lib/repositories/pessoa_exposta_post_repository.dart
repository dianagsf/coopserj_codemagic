import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class PessoaExpostaPostRepository {
  Future<int> saveInfo(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/pessoaExposta', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
