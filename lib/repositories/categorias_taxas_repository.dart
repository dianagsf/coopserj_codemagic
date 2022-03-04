import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class CategoriasTaxasRepository {
  Future<List<CategoriasTaxasModel>> getCategoriasTaxas() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/categorias/taxas');
      return (response.data as List)
          .map((sol) => CategoriasTaxasModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
