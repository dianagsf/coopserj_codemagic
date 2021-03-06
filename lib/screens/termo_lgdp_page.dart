import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/home.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class TermoLGDP extends StatefulWidget {
  final String nome;
  final String cpf;
  final int matricula;
  final String senha;
  final List<AssinouSCRModel> assinaturaSCR;

  const TermoLGDP({
    Key key,
    @required this.nome,
    @required this.cpf,
    @required this.matricula,
    @required this.senha,
    @required this.assinaturaSCR,
  }) : super(key: key);

  @override
  _TermoLGDPState createState() => _TermoLGDPState();
}

class _TermoLGDPState extends State<TermoLGDP> {
  bool concordo = false;
  int protocolo;

  TermoLGPDRepository termoLGPDRepository = TermoLGPDRepository();
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
                termoLGPDRepository.saveTermo({
                  "numero": protocolo,
                  "data": DateTime.now().toString().substring(0, 23),
                  "matricula": widget.matricula,
                });

                //// Volta pro in??cio
                //Get.back();
                // verifica se j?? assinou o termo
                var assinouSCR = widget.assinaturaSCR.any(
                    (assinatura) => assinatura.matricula == widget.matricula);

                print('ASSINOU = $assinouSCR');
                if (assinouSCR) {
                  Get.offAll(
                    HomePage(
                      nome: widget.nome,
                      matricula: widget.matricula,
                      senha: widget.senha,
                      cpf: widget.cpf,
                    ),
                  );
                } else {
                  Get.offAll(
                    TermoSCR(
                      nome: widget.nome,
                      cpf: widget.cpf,
                      matricula: widget.matricula,
                      senha: widget.senha,
                    ),
                  );
                }

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

    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          "Termo - LGPD",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),*/
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
                    "LEI GERAL DE PROTE????O DE DADOS PESSOAIS ??? LGPD",
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
                  "Atrav??s do presente instrumento, eu ${widget.nome.toUpperCase()}, inscrito (a) no CPF sob n?? ${widget.cpf}, aqui denominado (a) como TITULAR, venho por meio deste, autorizar que a Cooperativa de Cr??dito M??tuo dos Servidores P??blicos do Poder Executivo do Estado do Rio de Janeiro Ltda. ??? COOPSERJ , aqui denominada como CONTROLADORA, inscrita no CNPJ sob n?? 02.723.075/0001-26, em raz??o de ser associado (a) dessa institui????o, disponha dos meus dados pessoais e dados pessoais sens??veis, de acordo com os artigos 7?? e 11 da Lei n?? 13.709/2018, e a Resolu????o do Banco Central do Brasil 4.658/2018, conforme disposto neste termo:",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CL??USULA PRIMEIRA - Dados Pessoais",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "O Titular autoriza a Controladora a realizar o tratamento, ou seja, a utilizar os seguintes dados pessoais, para os fins que ser??o relacionados na cl??usula segunda:",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    buildItem("Nome completo;"),
                    buildItem(
                        "N??mero e imagem da Carteira de Identidade (RG);"),
                    buildItem(
                        "N??mero e imagem do Cadastro de Pessoas F??sicas (CPF);"),
                    buildItem(
                        "Endere??o completo com comprovante de resid??ncia;"),
                    buildItem("N??meros de telefone e endere??os de e-mail;"),
                    buildItem(
                        "Banco, ag??ncia, n??mero de contas banc??rias e comprovantes de rendas (contracheques);"),
                    buildItem(
                        "Matr??cula na Cooperativa para uso dos servi??os da Controladora; e"),
                    buildItem(
                        "Comunica????o, verbal e escrita, mantida entre o Titular e o Controlador."),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      "CL??USULA SEGUNDA - Finalidade do Tratamento dos Dados",
                      "O Titular autoriza que a Controladora utilize os dados pessoais e dados pessoais sens??veis listados neste termo para as seguintes finalidades:",
                    ),
                    const SizedBox(height: 15),
                    buildItem(
                        "Permitir que a Controladora identifique e entre em contato com o titular, em raz??o de sua filia????o como s??cio (a) cotista e usu??rio(a) dos servi??os;"),
                    buildItem(
                        "Para cumprimento de suas opera????es com a controladora e que s??o as especificas de uma cooperativa de cr??dito, tais como: capitaliza????o de cotas partes; contrata????o de empr??stimos; utiliza????o de servi??os conveniados; utiliza????o de todos os servi??os financeiros autorizados; acesso a dados cadastrais dispon??veis em cadastros p??blicos e privados, prestar informa????es minhas a requisi????es externas e amparadas em normas legais etc;"),
                    buildItem(
                        "Para cumprimento, pela Controladora, de obriga????es impostas por ??rg??os de fiscaliza????o;"),
                    buildItem(
                        "Quando necess??rio para a executar um contrato em ju??zo ou fora dele, no qual seja parte o titular;"),
                    buildItem("A pedido do titular dos dados;"),
                    buildItem(
                        "Para o exerc??cio regular de direitos em processo judicial, administrativo ou arbitral;"),
                    buildItem(
                        "Para a prote????o da vida ou da incolumidade f??sica do titular ou de terceiros;"),
                    buildItem(
                        "Para a tutela da sa??de, caso o controlador disponha de contrato coletivo em que eu fa??a parte, em defesa de benef??cios e outras interven????es necess??rias de acesso a direitos contratuais, situa????o que caso seja necess??rio concordo em fornecer outros dados exig??veis para a contrata????o do servi??o;"),
                    buildItem(
                        "Quando necess??rio para atender aos interesses leg??timos do controlador ou de terceiros, exceto no caso de prevalecerem direitos e liberdades fundamentais do titular que exijam a prote????o dos dados pessoais;"),
                    buildItem(
                        "Permitir que a Controladora utilize esses dados para a contrata????o e presta????o de servi??os conveniados dos inicialmente ajustados, desde que o Titular tamb??m demonstre interesse em contratar novos servi??os."),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      "Par??grafo Primeiro: Caso seja necess??rio o compartilhamento de dados com terceiros que n??o tenham sido relacionados nesse termo ou qualquer altera????o contratual posterior, ser?? ajustado novo termo de consentimento para este fim (?? 6?? do artigo 8?? e ?? 2?? do artigo 9?? da Lei n?? 13.709/2018).",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Par??grafo Segundo: Em caso de altera????o na finalidade, que esteja em desacordo com o consentimento original, a Controladora dever?? comunicar o Titular, que poder?? revogar o consentimento, conforme previsto na cl??usula sexta.",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CL??USULA TERCEIRA - Compartilhamento de Dados",
                  "A Controladora fica autorizada a compartilhar os dados pessoais do Titular com outros agentes de tratamento de dados, caso seja necess??rio para as finalidades listadas neste instrumento, desde que, sejam respeitados os princ??pios da boa-f??, finalidade, adequa????o, necessidade, livre acesso, qualidade dos dados, transpar??ncia, seguran??a, preven????o, n??o discrimina????o e responsabiliza????o e presta????o de contas, bem como, resguardar o sigilo banc??rio de dados confidenciais protegidos pela Lei Complementar 105.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CL??USULA QUARTA - Responsabilidade pela Seguran??a dos Dados",
                  "A Controladora se responsabiliza por manter medidas de seguran??a, t??cnicas e administrativas suficientes a proteger os dados pessoais do Titular e ?? Autoridade Nacional de Prote????o de Dados (ANPD), comunicando ao Titular, caso ocorra algum incidente de seguran??a que possa acarretar risco ou dano relevante, conforme artigo 48 da Lei n?? 13.709/2020.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CL??USULA QUINTA - T??rmino do Tratamento dos Dados",
                  "?? Controladora, ?? permitido manter e utilizar os dados pessoais do Titular durante todo o per??odo contratualmente firmado para as finalidades relacionadas nesse termo e ainda ap??s o t??rmino da contrata????o para cumprimento de obriga????o legal ou impostas por ??rg??os de fiscaliza????o, nos termos do artigo 16 da Lei n?? 13.709/2018.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      "CL??USULA SEXTA - Direito de Revoga????o do Consentimento",
                      "O Titular poder?? revogar seu consentimento, a qualquer tempo, por e-mail ou por carta escrita, conforme o artigo 8??, ?? 5??, da Lei n?? 13.709/2020.\n\nO Titular fica ciente de que a Controladora poder?? permanecer utilizando os dados para as seguintes finalidades:",
                    ),
                    const SizedBox(height: 15),
                    buildItem(
                        "Para cumprimento de obriga????es decorrentes da legisla????o do Sistema Financeiro Nacional e de sigilo banc??rio;"),
                    buildItem(
                        "Para cumprimento, pela Controladora, de obriga????es impostas por ??rg??os de fiscaliza????o;"),
                    buildItem(
                        "Para o exerc??cio regular de direitos em processo judicial, administrativo ou arbitral;"),
                    buildItem(
                        "Para a prote????o da vida ou da incolumidade f??sica do titular ou de terceiros;"),
                    buildItem(
                        "Para a tutela da sa??de, exclusivamente, em procedimento realizado por profissionais de sa??de, servi??os de sa??de ou autoridade sanit??ria;"),
                    buildItem(
                        "Quando necess??rio para atender aos interesses leg??timos do controlador ou de terceiros, exceto no caso de prevalecerem direitos e liberdades fundamentais do titular que exijam a prote????o dos dados pessoais."),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CL??USULA S??TIMA - Tempo de Perman??ncia dos Dados Recolhidos",
                  "O titular fica ciente de que a Controladora dever?? permanecer com os seus dados pelo per??odo m??nimo de guarda de documentos, previstos pela legisla????o do Sistema Financeiro Nacional, normas reguladoras, Receita Federal do Brasil e outros ??rg??os governamentais.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CL??USULA OITAVA - Vazamento de Dados ou Acessos N??o Autorizados ??? Penalidades",
                  "As partes poder??o entrar em acordo, quanto aos eventuais danos causados, caso exista o vazamento de dados pessoais ou acessos n??o autorizados, e caso n??o haja acordo, a Controladora tem ci??ncia que estar?? sujeita ??s penalidades previstas no artigo 52 da Lei n?? 13.709/2018:",
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
                        "Declaro que li e concordo integralmente com as informa????es acima.",
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

Widget buildItem(String text) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 10),
    child: Text(
      "??? $text",
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.justify,
    ),
  );
}

Widget buildText(String title, String text) {
  return Container(
    //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          text,
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  );
}
