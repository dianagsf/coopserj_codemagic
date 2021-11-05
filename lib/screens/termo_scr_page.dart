import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/home.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TermoSCR extends StatefulWidget {
  final String nome;
  final String cpf;
  final int matricula;
  final String senha;

  const TermoSCR({
    Key key,
    @required this.nome,
    @required this.cpf,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);

  @override
  _TermoSCRState createState() => _TermoSCRState();
}

class _TermoSCRState extends State<TermoSCR> {
  bool concordo = false;
  int protocolo;

  TermoSCRRepository termoSCRRepository = TermoSCRRepository();
  MaskedTextController senhaController = MaskedTextController(mask: "000000");

  @override
  void initState() {
    super.initState();
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  salvarTermo() {
    Get.dialog(
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
                termoSCRRepository.saveTermo({
                  "numero": protocolo,
                  "data": DateTime.now().toString().substring(0, 23),
                  "matricula": widget.matricula,
                });

                //// Volta pro início
                //Get.back();
                Get.offAll(
                  HomePage(
                    nome: widget.nome,
                    matricula: widget.matricula,
                    senha: widget.senha,
                    cpf: widget.cpf,
                  ),
                );

                /*Get.back();
                Get.back();
                Get.back();

                Get.snackbar(
                  "Realizado com sucesso!",
                  "",
                  colorText: Colors.white,
                  backgroundColor: Colors.green[700],
                  snackPosition: SnackPosition.BOTTOM,
                );*/
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
            child: Text("CONFIRMAR"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    "AUTORIZAÇÃO PARA CONSULTA AO SCR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Eu, ${widget.nome.toUpperCase()}, inscrito (a) no CPF sob n° ${widget.cpf}, autorizo a COOPSERJ a consultar os débitos e responsabilidades decorrentes de operações com características de crédito e as informações e os registros de medidas judiciais que em meu nome que constem ou venham a constar do Sistema de Informações de Crédito (SCR), gerido pelo Banco Central do Brasil - Bacen, ou dos sistemas que venham a complementá-lo ou a substituí-lo.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  "Estou ciente de que:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    _buildItem(
                        "a) o SCR tem por finalidades prover informações ao Banco Central do Brasil, para fins de monitoramento do crédito no sistema financeiro e para o exercício de suas atividades de fiscalização e propiciar o intercâmbio de informações entre instituições financeiras, conforme definido no § 1º do art. 1º da Lei Complementar nº 105, de 10 de janeiro de 2001, sobre o montante de responsabilidades de clientes em operações de crédito;"),
                    _buildItem(
                        "b) poderei ter acesso aos dados constantes em meu nome no SCR por meio do sistema Registrato do Banco Central do Brasil - Bacen;"),
                    _buildItem(
                        "c) pedidos de correções, de exclusões e de manifestações de discordância quanto às informações constantes do SCR, deverão ser dirigidas a COOPSERJ, por meio de requerimento escrito e fundamentado, ou, quando for o caso, pela respectiva decisão judicial, quando a COOPSERJ tiver sido o responsável pelo envio das informações ao SCR;"),
                    _buildItem(
                        "d) a consulta sobre qualquer informação ao SCR depende de minha prévia autorização;"),
                    _buildItem(
                        "e) o Conglomerado Banco do Brasil é obrigado a enviar para registro no SCR/Bacen as informações sobre operações de crédito, definidas pelo próprio Bacen por meio de regulamentação interna, contratadas e as serem contratadas por mim(nós);"),
                    _buildItem(
                        "f) mais informações sobre o SCR podem ser obtidas em consulta à página na Internet do Banco Central:"),
                    TextButton.icon(
                      onPressed: () => _launchURL("https://www.bcb.gov.br/"),
                      label: Text(
                        "www.bcb.gov.br",
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    Checkbox(
                      value: concordo,
                      onChanged: (value) {
                        setState(() {
                          concordo = !concordo;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        "Declaro que li e concordo integralmente com as informações acima.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: alturaTela * 0.055, //45,
                width: MediaQuery.of(context).size.width * 0.73,
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: alturaTela * 0.8)
                    : const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: concordo ? salvarTermo : null,
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
                      "ENVIAR",
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
          ],
        ),
      ),
    );
  }
}

Widget _buildItem(String text) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 20),
    child: Text(
      "$text",
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.justify,
    ),
  );
}
