import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class ControleAnexosRepository {
  Future<List<ControleAnexoModel>> getInfosControle() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/controleAnexos');

      return (response.data as List)
          .map((sol) => ControleAnexoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> postAnexos(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/controleAnexos', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
