import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class CategoriasTaxasController extends GetxController {
  CategoriasTaxasRepository categoriasTaxasRepository =
      CategoriasTaxasRepository();

  final _categoriasTaxas = <CategoriasTaxasModel>[].obs;

  List<CategoriasTaxasModel> get categoriasTaxas => _categoriasTaxas;
  set categoriasTaxas(value) => this._categoriasTaxas.assignAll(value);

  void getCategoriasTaxas() {
    categoriasTaxasRepository
        .getCategoriasTaxas()
        .then((data) => {this._categoriasTaxas.assignAll(data)});
  }
}
