import 'package:coopserj_app/controllers/assinou_lgdp_controller.dart';
import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/screens/auth_page.dart';
import 'package:coopserj_app/screens/primeiro_acesso/primeiro_acesso_page.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class LoginPage extends StatefulWidget {
  final String versaoTabela;
  final String versaoApp;

  const LoginPage({
    Key key,
    this.versaoTabela,
    this.versaoApp,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AssinouLGDPController assinouLGDPController =
      Get.put(AssinouLGDPController());
  AssinouSCRController assinouSCRController = Get.put(AssinouSCRController());

  //GET CREDENCIAIS E-MAIL APP
  EmailAppController emailAppController = Get.put(EmailAppController());

  bool _obscureText = true;

  MaskedTextController cpfController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController senhaController = MaskedTextController(mask: '000000');

  MaskedTextController cpfSenhaController =
      MaskedTextController(mask: '000.000.000-00');
  MaskedTextController dataNascController =
      MaskedTextController(mask: '00/00/0000');

  @override
  void initState() {
    super.initState();

    //get e-mail e senha app
    emailAppController.getDadosEmailApp();

    //get matriculas que já assinaram o termo
    assinouLGDPController.getAssinatura();
    assinouSCRController.getAssinatura();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    double larguraTela = MediaQuery.of(context).size.width;

    _launchURL() async {
      const url = 'https://www.coopserj.coop.br/cadastre-se';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    _showSenha() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    return Responsive(
      mobile: _buildLoginMobile(
        context,
        alturaTela,
        larguraTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
        emailAppController,
        widget.versaoTabela,
        widget.versaoApp,
      ),
      tablet: _buildLoginMobile(
        context,
        alturaTela,
        larguraTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
        emailAppController,
        widget.versaoTabela,
        widget.versaoApp,
      ),
      desktop: _buildLoginWeb(
        alturaTela,
        _formKey,
        cpfController,
        senhaController,
        cpfSenhaController,
        dataNascController,
        _obscureText,
        assinouLGDPController,
        assinouSCRController,
        _launchURL,
        _showSenha,
        emailAppController,
      ),
    );
  }
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

String _validateSenha(String value) {
  if (value.isEmpty) {
    return "Infome a senha";
  }
  if (value.length != 6) {
    return "A senha deve conter 6 dígitos";
  }
  return null;
}

Widget buildDialog(
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  EmailAppController emailAppController,
) {
  return AlertDialog(
    title: Text("Informe o CPF e a Data de Nascimento:"),
    content: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        height: 200,
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                controller: cpfSenhaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "CPF:",
                  prefixIcon: Icon(Icons.security_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: dataNascController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: "Data de Nascimento:",
                  prefixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          print("cliquei!!!!!!!!");
          Get.to(
            SendEmail(
              cpf: cpfSenhaController.text,
              dataNasc: dataNascController.text,
              emailApp: emailAppController.emailApp[0].email,
              senhaEmailApp: emailAppController.emailApp[0].senha,
            ),
          );
        },
        child: Text("CONFIRMAR"),
      )
    ],
  );
}

Widget _buildLoginMobile(
  BuildContext context,
  double alturaTela,
  double larguraTela,
  GlobalKey<FormState> formKey,
  MaskedTextController cpfController,
  MaskedTextController senhaController,
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  bool obscureText,
  AssinouLGDPController assinouLGDPController,
  AssinouSCRController assinouSCRController,
  Function launchURL,
  Function showSenha,
  EmailAppController emailAppController,
  String versaoTabela,
  String versaoApp,
) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        width: larguraTela,
        height: alturaTela,
        // color: Colors.white,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50], Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: alturaTela * 0.1,
              left: larguraTela * 0.33,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.31, //130,
                height: alturaTela * 0.16, //130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/login.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Positioned(
              top: alturaTela * 0.3,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 32.0),
                width: MediaQuery.of(context).size.width,
                height: alturaTela,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          validator: _validateCPF,
                          keyboardType: TextInputType.number,
                          controller: cpfController,
                          decoration: InputDecoration(
                            hintText: "CPF",
                            prefixIcon: Icon(Icons.account_circle),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          obscureText: obscureText,
                          validator: _validateSenha,
                          controller: senhaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Senha",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: obscureText
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                              onPressed: showSenha,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: TextButton(
                            onPressed: () {
                              Get.dialog(
                                buildDialog(
                                  cpfSenhaController,
                                  dataNascController,
                                  emailAppController,
                                ),
                              );
                            },
                            child: Text(
                              "Esqueceu sua senha?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: alturaTela * 0.05,
                        ),
                        SizedBox(
                          height: alturaTela * 0.062,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();

                                print(
                                    "VERSÃO APP = $versaoApp // TABELA = $versaoTabela");
                                //// VERIFICA VERSÃO OU USUÁRIO DE TESTE
                                if (!kIsWeb) {
                                  if (versaoApp != null &&
                                      versaoTabela != null) {
                                    if (versaoApp.compareTo(versaoTabela) ==
                                            1 ||
                                        versaoApp.compareTo(versaoTabela) ==
                                            0) {
                                      Get.to(
                                        AuthPage(
                                          cpf: cpfController.text,
                                          senha: senhaController.text,
                                          assinaturaLGDP:
                                              assinouLGDPController.assinatura,
                                          assinaturaSCR:
                                              assinouSCRController.assinatura,
                                        ),
                                      );
                                    } else {
                                      Get.to(NovaVersaoPage());
                                    }
                                    /*if (versaoTabela.compareTo(versaoApp) !=
                                            0 &&
                                        cpfController.text
                                                .compareTo('123.456.789-09') !=
                                            0) {
                                      Get.to(NovaVersaoPage());
                                    } else {
                                      Get.to(
                                        AuthPage(
                                          cpf: cpfController.text,
                                          senha: senhaController.text,
                                          assinaturaLGDP:
                                              assinouLGDPController.assinatura,
                                          assinaturaSCR:
                                              assinouSCRController.assinatura,
                                        ),
                                      );
                                    }*/
                                  }
                                } else {
                                  Get.to(
                                    AuthPage(
                                      cpf: cpfController.text,
                                      senha: senhaController.text,
                                      assinaturaLGDP:
                                          assinouLGDPController.assinatura,
                                      assinaturaSCR:
                                          assinouSCRController.assinatura,
                                    ),
                                  );
                                }
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
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: alturaTela * 0.03, //20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            //Get.to(Cadastro());
                            launchURL();
                          },
                          child: Text(
                            "Ainda não é um associado? Cadastre-se!",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: alturaTela * 0.02, //16.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        alturaTela < 550
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: alturaTela * 0.09,
                              ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              PrimeiroAcessoPage(
                                emailApp: emailAppController.emailApp[0].email,
                                senhaEmailApp:
                                    emailAppController.emailApp[0].senha,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Primeiro acesso?',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: alturaTela * 0.02,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Clique aqui!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: alturaTela * 0.02,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLoginWeb(
  double alturaTela,
  GlobalKey<FormState> formKey,
  MaskedTextController cpfController,
  MaskedTextController senhaController,
  MaskedTextController cpfSenhaController,
  MaskedTextController dataNascController,
  bool obscureText,
  AssinouLGDPController assinouLGDPController,
  AssinouSCRController assinouSCRController,
  Function launchURL,
  Function showSenha,
  EmailAppController emailAppController,
) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF005AE6),
                image: DecorationImage(
                  image: AssetImage("images/loginWeb.jpg"),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 40),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("images/login.png"),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: _validateCPF,
                            keyboardType: TextInputType.number,
                            controller: cpfController,
                            decoration: InputDecoration(
                              hintText: "CPF",
                              prefixIcon: Icon(Icons.account_circle),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            obscureText: obscureText,
                            validator: _validateSenha,
                            controller: senhaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Senha",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: obscureText
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: showSenha,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextButton(
                              onPressed: () {
                                Get.dialog(
                                  buildDialog(cpfSenhaController,
                                      dataNascController, emailAppController),
                                );
                              },
                              child: Text(
                                "Esqueceu sua senha?",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: alturaTela * 0.15,
                          ),
                          SizedBox(
                            width: alturaTela * 0.40,
                            height: alturaTela * 0.062, //50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();

                                  Get.to(
                                    AuthPage(
                                      cpf: cpfController.text,
                                      senha: senhaController.text,
                                      assinaturaLGDP:
                                          assinouLGDPController.assinatura,
                                      assinaturaSCR:
                                          assinouSCRController.assinatura,
                                    ),
                                  );

                                  /*Get.to(
                                        AuthPage(
                                          cpf: cpfController.text,
                                          senha: senhaController.text,
                                        ),
                                      );*/
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
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: alturaTela * 0.03, //20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              //Get.to(Cadastro());
                              launchURL();
                            },
                            child: Text(
                              "Ainda não é um associado? Cadastre-se!",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: alturaTela * 0.02, //16.0,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                        PrimeiroAcessoPage(
                          emailApp: emailAppController.emailApp[0].email,
                          senhaEmailApp: emailAppController.emailApp[0].senha,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Primeiro acesso?',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: alturaTela * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Clique aqui!',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: alturaTela * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
