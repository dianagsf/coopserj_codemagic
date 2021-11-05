import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class CategoriasController extends GetxController {
  CategoriasRepository categoriasRepository = CategoriasRepository();

  final _categorias = <CategoriasModel>[].obs;

  List<CategoriasModel> get categorias => _categorias;
  set categorias(value) => this._categorias.assignAll(value);

  void getCategorias() {
    categoriasRepository
        .getCategorias()
        .then((data) => {this._categorias.assignAll(data)});
  }
}
