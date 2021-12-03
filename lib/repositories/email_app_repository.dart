import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class EmailAppRepository {
  Future<List<EmailAppModel>> getDadosEmailApp() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/emailAPP');
      return (response.data as List)
          .map((sol) => EmailAppModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
