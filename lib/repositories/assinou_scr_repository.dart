import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class AssinouSCRRepository {
  Future<List<AssinouSCRModel>> getAssinatura() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/assinaturaSCR');
      return (response.data as List)
          .map((sol) => AssinouSCRModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
