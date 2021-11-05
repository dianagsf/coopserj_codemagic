import 'dart:async';

import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/home.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  final String cpf;
  final String senha;
  final List<AssinouLGDPModel> assinaturaLGDP;
  final List<AssinouSCRModel> assinaturaSCR;

  const AuthPage({
    Key key,
    @required this.cpf,
    @required this.senha,
    @required this.assinaturaLGDP,
    @required this.assinaturaSCR,
  }) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<List<AssociadoModel>> loginAuth;
  AssociadoRepository _associadoRepository;

  final ControleAppController controleAppController =
      Get.put(ControleAppController());

  AssinouLGDPController assinouLGDPController = Get.find();

  String convertCPF() {
    String cpf = widget.cpf.replaceAll('.', '').replaceAll('-', '');
    return cpf;
  }

  @override
  void initState() {
    super.initState();

    var cpfConvert = convertCPF();

    _associadoRepository = AssociadoRepository();
    loginAuth = _associadoRepository.login(cpfConvert, widget.senha);

    controleAppController.getControleInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loginAuth,
        builder: (BuildContext context,
            AsyncSnapshot<List<AssociadoModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Image.asset(
                  "images/logo.png",
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              );
              break;
            default:
              if (snapshot.hasError) {
                print("Error: ${snapshot.error}");
                return _showAlertDialog(context);
              } else {
                if (snapshot.data.isEmpty) {
                  print("Error: ${snapshot.error}");
                  return _showAlertDialog(context);
                } else {
                  return GetX<ControleAppController>(
                    builder: (_) {
                      // verifica se já assinou o termo
                      var assinouLGDP = widget.assinaturaLGDP.any(
                          (assinatura) =>
                              assinatura.matricula ==
                              snapshot.data[0].matricula);

                      print('ASSINOU = $assinouLGDP');

                      /// VERIFICA SE A INTEGRAÇÃO ESTÁ SENDO FEITA!!!
                      return _.controleAPP.length < 1
                          ? Container(
                              color: Colors.white,
                              child: CircularProgressIndicator(),
                            )
                          : _.controleAPP[0].iNTEGRACAO != 1
                              ? snapshot.data[0].bloqueia != 1
                                  ? assinouLGDP
                                      ? HomePage(
                                          nome: snapshot.data[0].nome,
                                          matricula: snapshot.data[0].matricula,
                                          email: snapshot.data[0].email,
                                          telefone: snapshot.data[0].telefone,
                                          senha: snapshot.data[0].senha,
                                          cpf: snapshot.data[0].cpf,
                                        )
                                      : TermoLGDP(
                                          nome: snapshot.data[0].nome,
                                          matricula: snapshot.data[0].matricula,
                                          senha: snapshot.data[0].senha,
                                          cpf: snapshot.data[0].cpf,
                                          assinaturaSCR: widget.assinaturaSCR,
                                        )
                                  : ManutencaoPage()
                              : ManutencaoPage();
                    },
                  );
                }
              }
          }
        },
      ),
    );
  }
}

Widget _showAlertDialog(BuildContext context) {
  return Center(
    child: AlertDialog(
      title: Text("Não foi possível realizar o login"),
      content: Text("Confira seus dados e tente novamente."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
