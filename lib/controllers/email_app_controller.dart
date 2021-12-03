import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:get/get.dart';

class EmailAppController extends GetxController {
  EmailAppRepository emailAppRepository = EmailAppRepository();

  final _emailApp = <EmailAppModel>[].obs;

  List<EmailAppModel> get emailApp => _emailApp;
  set emailApp(value) => this._emailApp.assignAll(value);

  void getDadosEmailApp() {
    emailAppRepository
        .getDadosEmailApp()
        .then((data) => {this._emailApp.assignAll(data)});
  }
}
