import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class AssinouLGDPRepository {
  Future<List<AssinouLGDPModel>> getAssinatura() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/assinaturaLGDP');
      return (response.data as List)
          .map((sol) => AssinouLGDPModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
