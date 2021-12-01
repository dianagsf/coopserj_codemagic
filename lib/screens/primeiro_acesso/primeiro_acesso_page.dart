import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/email.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class PrimeiroAcessoPage extends StatefulWidget {
  const PrimeiroAcessoPage({Key key}) : super(key: key);

  @override
  _PrimeiroAcessoPageState createState() => _PrimeiroAcessoPageState();
}

class _PrimeiroAcessoPageState extends State<PrimeiroAcessoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController nomeControlller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController dataNascController =
      MaskedTextController(mask: '00/00/0000');
  MaskedTextController telefoneController =
      MaskedTextController(mask: '(00) 00000-0000');

  EnviarEmailWebRepository enviarEmailWebRepository =
      EnviarEmailWebRepository();

  var email = Email('app@basiclinesistemas.com.br', 'Rbline@87105');

  void _sendEmail({
    String nome,
    String cpf,
    String dataNasc,
    String telefone,
    String emailAssoc,
  }) async {
    var data = formatDate(
        DateTime.now(), [dd, '/', mm, '/', yyyy, ' às ', HH, ':', nn]);
    print('MOBILLE!!');
    //TROCAR E-MAIL!!!
    //rogerio.barradas@basicline.com.br

    bool result = await email.sendMessage(
        ' O associado ${nome.toUpperCase()} está solicitando acesso ao APP. \n\n NOME DO ASSOCIADO: ${nome.toUpperCase()}\n CPF: $cpf \n DATA NASCIMENTO: $dataNasc \n TELEFONE: $telefone \n E-MAIL: $emailAssoc \n\n DATA DA SOLICITAÇÃO: $data',
        'atendimento@coopserj.coop.br',
        'APP Coopserj: SOLICITAÇÃO DE ACESSO.');

    print("resultado = $result");
  }

  void enviarEmailWeb({
    String nome,
    String cpf,
    String dataNasc,
    String telefone,
    String emailAssoc,
  }) {
    print("E-MAIL WEB !!!!!");
    var data = formatDate(
        DateTime.now(), [dd, '/', mm, '/', yyyy, ' às ', HH, ':', nn]);

    enviarEmailWebRepository.enviarEmailWeb({
      "nome": nome.toUpperCase(),
      "cpf": cpf,
      "dataNasc": dataNasc,
      "telefone": telefone,
      "emailAssoc": emailAssoc,
      "data": data,
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            padding: Responsive.isDesktop(context)
                ? EdgeInsets.symmetric(horizontal: alturaTela * 0.4)
                : EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    alignment: Alignment.centerLeft,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Image.asset(
                          'images/primeiro_acesso.png',
                          fit: BoxFit.scaleDown,
                          width: alturaTela * 0.15,
                          height: alturaTela * 0.18,
                        ),
                        Expanded(
                          child: Text(
                            'Solicitação de\nPrimeiro Acesso',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .fontSize,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: nomeControlller,
                              keyboardType: TextInputType.name,
                              validator: _validateNome,
                              decoration: InputDecoration(
                                labelText: 'Digite seu nome completo',
                                prefixIcon: Icon(MdiIcons.accountOutline),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: cpfController,
                              keyboardType: TextInputType.number,
                              validator: _validateCPF,
                              decoration: InputDecoration(
                                labelText: 'Digite seu CPF',
                                prefixIcon:
                                    Icon(MdiIcons.cardAccountDetailsOutline),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: dataNascController,
                                      keyboardType: TextInputType.number,
                                      validator: _validataNasc,
                                      decoration: InputDecoration(
                                        labelText: 'Nascimento',
                                        prefixIcon: Icon(
                                            MdiIcons.calendarAccountOutline),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      controller: telefoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: _validateTelefone,
                                      decoration: InputDecoration(
                                        labelText: 'Telefone',
                                        prefixIcon: Icon(MdiIcons.phoneOutline),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                              decoration: InputDecoration(
                                labelText: 'Digite seu e-mail',
                                prefixIcon: Icon(MdiIcons.emailOutline),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    /*  padding: Responsive.isDesktop(context)
                        ? EdgeInsets.symmetric(
                            horizontal: alturaTela * 0.40,
                            vertical: alturaTela * 0.09)
                        : EdgeInsets.symmetric(horizontal: 40, vertical: 10),*/
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            kIsWeb // verifica se tá rodando na WEB
                                ? enviarEmailWeb(
                                    nome: nomeControlller.text,
                                    cpf: cpfController.text,
                                    dataNasc: dataNascController.text,
                                    telefone: telefoneController.text,
                                    emailAssoc: emailController.text,
                                  )
                                : _sendEmail(
                                    nome: nomeControlller.text,
                                    cpf: cpfController.text,
                                    dataNasc: dataNascController.text,
                                    telefone: telefoneController.text,
                                    emailAssoc: emailController.text,
                                  );

                            Get.off(
                              EnviarEmail(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Enviar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: alturaTela * 0.03, //20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _validateNome(String value) {
  if (value.isEmpty) {
    return "Infome o Nome";
  }

  return null;
}

String _validateTelefone(String value) {
  if (value.isEmpty) {
    return "Infome o Telefone";
  }

  return null;
}

String _validateEmail(String value) {
  if (value.isEmpty) {
    return "Infome o E-mail";
  }

  return null;
}

String _validateCPF(String value) {
  if (value.isEmpty) {
    return "Infome o CPF";
  }
  if (value.length != 14) {
    return "O CPF deve conter 11 dígitos";
  }

  return null;
}

String _validataNasc(String value) {
  if (value.isEmpty) {
    return "Infome a Data";
  }
  if (value.length != 10) {
    return "Formato: dd/mm/aaaa";
  }

  return null;
}
