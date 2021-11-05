import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/custom_dio.dart';
import 'package:dio/dio.dart';

class AssociadoRepository {
  Future<List<AssociadoModel>> login(String cpf, String senha) async {
    var dio = CustomDio().instance;
    try {
      var response = await dio.get('/login?cpf=$cpf&senha=$senha');

      return (response.data as List)
          .map((sol) => AssociadoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<List<AssociadoModel>> getInfosAssocSenha(
      String cpf, String dataNasc) async {
    var dio = CustomDio().instance;
    try {
      var response =
          await dio.get('/associadoInfo/?cpf=$cpf&dataNasc=$dataNasc');
      return (response.data as List)
          .map((sol) => AssociadoModel.fromJson(sol))
          .toList();
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> postEmail(Map<String, dynamic> data, int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.put('/assoc/email/$matricula', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }

  Future<int> postTelefone(Map<String, dynamic> data, int matricula) async {
    var dio = CustomDio().instance;

    try {
      var response = await dio.put('/assoc/telefone/$matricula', data: data);
      return response.statusCode;
    } on DioError catch (e) {
      throw (e.message);
    }
  }
}
