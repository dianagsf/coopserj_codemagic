import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class ConveniosContrRepository {
  Future<List<ConveniosContrModel>> getInfos(int matricula) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/conveniosContrados?matricula=$matricula');

      return (response.data as List)
          .map((sol) => ConveniosContrModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
