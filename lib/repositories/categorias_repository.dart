import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class CategoriasRepository {
  Future<List<CategoriasModel>> getCategorias() async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/categorias');
      return (response.data as List)
          .map((sol) => CategoriasModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
