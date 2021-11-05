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

                //// Volta pro início
                //Get.back();
                // verifica se já assinou o termo
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
                    "LEI GERAL DE PROTEÇÃO DE DADOS PESSOAIS – LGPD",
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
                  "Através do presente instrumento, eu ${widget.nome.toUpperCase()}, inscrito (a) no CPF sob n° ${widget.cpf}, aqui denominado (a) como TITULAR, venho por meio deste, autorizar que a Cooperativa de Crédito Mútuo dos Servidores Públicos do Poder Executivo do Estado do Rio de Janeiro Ltda. – COOPSERJ , aqui denominada como CONTROLADORA, inscrita no CNPJ sob n° 02.723.075/0001-26, em razão de ser associado (a) dessa instituição, disponha dos meus dados pessoais e dados pessoais sensíveis, de acordo com os artigos 7° e 11 da Lei n° 13.709/2018, e a Resolução do Banco Central do Brasil 4.658/2018, conforme disposto neste termo:",
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
                      "CLÁUSULA PRIMEIRA - Dados Pessoais",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "O Titular autoriza a Controladora a realizar o tratamento, ou seja, a utilizar os seguintes dados pessoais, para os fins que serão relacionados na cláusula segunda:",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    buildItem("Nome completo;"),
                    buildItem(
                        "Número e imagem da Carteira de Identidade (RG);"),
                    buildItem(
                        "Número e imagem do Cadastro de Pessoas Físicas (CPF);"),
                    buildItem(
                        "Endereço completo com comprovante de residência;"),
                    buildItem("Números de telefone e endereços de e-mail;"),
                    buildItem(
                        "Banco, agência, número de contas bancárias e comprovantes de rendas (contracheques);"),
                    buildItem(
                        "Matrícula na Cooperativa para uso dos serviços da Controladora; e"),
                    buildItem(
                        "Comunicação, verbal e escrita, mantida entre o Titular e o Controlador."),
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
                      "CLÁUSULA SEGUNDA - Finalidade do Tratamento dos Dados",
                      "O Titular autoriza que a Controladora utilize os dados pessoais e dados pessoais sensíveis listados neste termo para as seguintes finalidades:",
                    ),
                    const SizedBox(height: 15),
                    buildItem(
                        "Permitir que a Controladora identifique e entre em contato com o titular, em razão de sua filiação como sócio (a) cotista e usuário(a) dos serviços;"),
                    buildItem(
                        "Para cumprimento de suas operações com a controladora e que são as especificas de uma cooperativa de crédito, tais como: capitalização de cotas partes; contratação de empréstimos; utilização de serviços conveniados; utilização de todos os serviços financeiros autorizados; acesso a dados cadastrais disponíveis em cadastros públicos e privados, prestar informações minhas a requisições externas e amparadas em normas legais etc;"),
                    buildItem(
                        "Para cumprimento, pela Controladora, de obrigações impostas por órgãos de fiscalização;"),
                    buildItem(
                        "Quando necessário para a executar um contrato em juízo ou fora dele, no qual seja parte o titular;"),
                    buildItem("A pedido do titular dos dados;"),
                    buildItem(
                        "Para o exercício regular de direitos em processo judicial, administrativo ou arbitral;"),
                    buildItem(
                        "Para a proteção da vida ou da incolumidade física do titular ou de terceiros;"),
                    buildItem(
                        "Para a tutela da saúde, caso o controlador disponha de contrato coletivo em que eu faça parte, em defesa de benefícios e outras intervenções necessárias de acesso a direitos contratuais, situação que caso seja necessário concordo em fornecer outros dados exigíveis para a contratação do serviço;"),
                    buildItem(
                        "Quando necessário para atender aos interesses legítimos do controlador ou de terceiros, exceto no caso de prevalecerem direitos e liberdades fundamentais do titular que exijam a proteção dos dados pessoais;"),
                    buildItem(
                        "Permitir que a Controladora utilize esses dados para a contratação e prestação de serviços conveniados dos inicialmente ajustados, desde que o Titular também demonstre interesse em contratar novos serviços."),
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
                      "Parágrafo Primeiro: Caso seja necessário o compartilhamento de dados com terceiros que não tenham sido relacionados nesse termo ou qualquer alteração contratual posterior, será ajustado novo termo de consentimento para este fim (§ 6° do artigo 8° e § 2° do artigo 9° da Lei n° 13.709/2018).",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Parágrafo Segundo: Em caso de alteração na finalidade, que esteja em desacordo com o consentimento original, a Controladora deverá comunicar o Titular, que poderá revogar o consentimento, conforme previsto na cláusula sexta.",
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
                  "CLÁUSULA TERCEIRA - Compartilhamento de Dados",
                  "A Controladora fica autorizada a compartilhar os dados pessoais do Titular com outros agentes de tratamento de dados, caso seja necessário para as finalidades listadas neste instrumento, desde que, sejam respeitados os princípios da boa-fé, finalidade, adequação, necessidade, livre acesso, qualidade dos dados, transparência, segurança, prevenção, não discriminação e responsabilização e prestação de contas, bem como, resguardar o sigilo bancário de dados confidenciais protegidos pela Lei Complementar 105.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CLÁUSULA QUARTA - Responsabilidade pela Segurança dos Dados",
                  "A Controladora se responsabiliza por manter medidas de segurança, técnicas e administrativas suficientes a proteger os dados pessoais do Titular e à Autoridade Nacional de Proteção de Dados (ANPD), comunicando ao Titular, caso ocorra algum incidente de segurança que possa acarretar risco ou dano relevante, conforme artigo 48 da Lei n° 13.709/2020.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CLÁUSULA QUINTA - Término do Tratamento dos Dados",
                  "À Controladora, é permitido manter e utilizar os dados pessoais do Titular durante todo o período contratualmente firmado para as finalidades relacionadas nesse termo e ainda após o término da contratação para cumprimento de obrigação legal ou impostas por órgãos de fiscalização, nos termos do artigo 16 da Lei n° 13.709/2018.",
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
                      "CLÁUSULA SEXTA - Direito de Revogação do Consentimento",
                      "O Titular poderá revogar seu consentimento, a qualquer tempo, por e-mail ou por carta escrita, conforme o artigo 8°, § 5°, da Lei n° 13.709/2020.\n\nO Titular fica ciente de que a Controladora poderá permanecer utilizando os dados para as seguintes finalidades:",
                    ),
                    const SizedBox(height: 15),
                    buildItem(
                        "Para cumprimento de obrigações decorrentes da legislação do Sistema Financeiro Nacional e de sigilo bancário;"),
                    buildItem(
                        "Para cumprimento, pela Controladora, de obrigações impostas por órgãos de fiscalização;"),
                    buildItem(
                        "Para o exercício regular de direitos em processo judicial, administrativo ou arbitral;"),
                    buildItem(
                        "Para a proteção da vida ou da incolumidade física do titular ou de terceiros;"),
                    buildItem(
                        "Para a tutela da saúde, exclusivamente, em procedimento realizado por profissionais de saúde, serviços de saúde ou autoridade sanitária;"),
                    buildItem(
                        "Quando necessário para atender aos interesses legítimos do controlador ou de terceiros, exceto no caso de prevalecerem direitos e liberdades fundamentais do titular que exijam a proteção dos dados pessoais."),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CLÁUSULA SÉTIMA - Tempo de Permanência dos Dados Recolhidos",
                  "O titular fica ciente de que a Controladora deverá permanecer com os seus dados pelo período mínimo de guarda de documentos, previstos pela legislação do Sistema Financeiro Nacional, normas reguladoras, Receita Federal do Brasil e outros órgãos governamentais.",
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: buildText(
                  "CLÁUSULA OITAVA - Vazamento de Dados ou Acessos Não Autorizados – Penalidades",
                  "As partes poderão entrar em acordo, quanto aos eventuais danos causados, caso exista o vazamento de dados pessoais ou acessos não autorizados, e caso não haja acordo, a Controladora tem ciência que estará sujeita às penalidades previstas no artigo 52 da Lei n° 13.709/2018:",
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

Widget buildItem(String text) {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(bottom: 10),
    child: Text(
      "• $text",
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
