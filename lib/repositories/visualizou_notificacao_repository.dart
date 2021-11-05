import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class VisualizouNotiRepository {
  Future<int> saveView(Map<String, dynamic> data) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.post('/viuNoitificacao', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
