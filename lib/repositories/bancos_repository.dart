import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class BancosRepository {
  Future<List<BancosModel>> getBancos() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/bancos');
      return (response.data as List)
          .map((sol) => BancosModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
