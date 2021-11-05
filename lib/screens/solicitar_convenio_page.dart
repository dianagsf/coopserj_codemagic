import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class SolicitarConvenioPage extends StatefulWidget {
  final int matricula;
  final String senha;

  const SolicitarConvenioPage({
    Key key,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);
  @override
  _SolicitarConvenioPageState createState() => _SolicitarConvenioPageState();
}

class _SolicitarConvenioPageState extends State<SolicitarConvenioPage> {
  MaskedTextController telefoneController =
      MaskedTextController(mask: '(00) 00000-0000');

  TextEditingController emailController = TextEditingController();
  MaskedTextController senhaController = MaskedTextController(mask: "000000");

  SolicConvenioRepository solicConvenioRepository = SolicConvenioRepository();

  final formKey = new GlobalKey<FormState>();
  int protocolo;

  @override
  void initState() {
    super.initState();
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  handleSolicitacao() {
    return Get.dialog(
      AlertDialog(
        title: Text("Confirme sua senha"),
        content: TextField(
          controller: senhaController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (senhaController.text.compareTo(widget.senha) == 0) {
                  solicConvenioRepository.createSolic({
                    "numero": protocolo,
                    "matricula": widget.matricula,
                    "email": emailController.text,
                    "telefone": telefoneController.text,
                    "convenio": "CLARO", // fixo por enquanto
                    "data": DateTime.now().toString().substring(0, 19),
                  });

                  Get.back();
                  Get.back();
                  Get.back();

                  Get.snackbar(
                    "Aguarde!",
                    "Sua solicitação será analisada pela Diretoria e processada em breve.",
                    colorText: Colors.white,
                    backgroundColor: Colors.green[700],
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.back();

                  senhaController.text = "";

                  Get.snackbar(
                    "Senha incorreta!",
                    "Tente novamente.",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    padding: EdgeInsets.all(30),
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 4),
                  );
                }
              },
              child: Text("CONFIRMAR")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solicitar convênio",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(horizontal: alturaTela * 0.5)
            : EdgeInsets.symmetric(horizontal: 0.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Image.asset(
                  "images/novoConvenio.png",
                  width: alturaTela * 0.33, //300,
                  height: alturaTela * 0.33, //300,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: Responsive.isDesktop(context)
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Convênios",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton(
                      isExpanded: true,
                      value: "CLARO",
                      hint: Text("CLARO"),
                      items: [
                        DropdownMenuItem(
                          value: "CLARO",
                          child: Text("CLARO"),
                        )
                      ],
                      // categoria fixa por enquanto
                      /*onChanged: (value) {
                                        setState(() {
                                          convenio = value;
                                        });
                                      },*/
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey[350],
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Planos exclusivos com:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    buildInfoPlano(
                        "ligações, SMS, redes sociais e mobilidade urbana ilimitados"),
                    const SizedBox(height: 10),
                    buildInfoPlano(
                        "além de 5GB, 10GB ou 20GB de internet em dobro"),
                    const SizedBox(height: 10),
                    buildInfoPlano(
                        "e um aparelho de brinde esperando por você"),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Peça já o seu!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: _validateTextField,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Informe o seu e-mail",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      TextFormField(
                        controller: telefoneController,
                        validator: _validateTextField,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Informe seu telefone",
                          prefixIcon: Icon(Icons.phone_callback_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  height: alturaTela * 0.055, //45,
                  width: Responsive.isDesktop(context)
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width * 0.73,
                  margin: const EdgeInsets.only(top: 20, bottom: 20),

                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        handleSolicitacao();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "SOLICITAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: alturaTela * 0.025,
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
    );
  }
}

// VALIDA TEXTFIELD
String _validateTextField(String value) {
  if (value.isEmpty) {
    return '* Este campo é obrigatório. Informe um valor';
  }
  return null;
}

Widget buildInfoPlano(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.check, color: Colors.blueAccent),
      const SizedBox(width: 15),
      Expanded(
        child: Text(text, style: TextStyle(fontSize: 15)),
      ),
    ],
  );
}
