import 'dart:math';

import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:finance/finance.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfosSolicPage extends StatefulWidget {
  final int matricula;
  final int selectedRadio;
  final String categoria;
  final String categoriaCodigo;
  final int protocolo;
  final String senha;
  final String banco;

  const InfosSolicPage({
    Key key,
    @required this.matricula,
    @required this.selectedRadio,
    @required this.categoria,
    @required this.categoriaCodigo,
    @required this.protocolo,
    @required this.senha,
    @required this.banco,
  }) : super(key: key);
  @override
  _InfosSolicPageState createState() => _InfosSolicPageState();
}

class _InfosSolicPageState extends State<InfosSolicPage> {
  SolicitacaoPostController _solicPostController = Get.find();
  ControleAppController _controleAppController = Get.find();
  CategoriasTaxasController categoriasTaxasController = Get.find();

  FormatMoney money = FormatMoney();

  MaskedTextController senhaController = MaskedTextController(mask: "000000");
  MaskedTextController tokenController = MaskedTextController(mask: "00000000");

  double valorDesconto = 0.0;
  double valorFinanciado = 0.0;
  double valorLiquido = 0.0;
  double iof = 0.0;
  double iofAdicional = 0.0;
  double taxa = 0.0;
  double cetAno = 0.0;
  DateTime dataPrimeiraPrestacao;

  final formKey = new GlobalKey<FormState>();

  //Convert money type to double
  String _convertDouble(String value) {
    String valor = value.replaceAll('.', '').replaceAll(',', '.');

    return valor;
  }

  double calculaIOF(double valorFinanciado, double taxa) {
    double iofAdicional = 0.0;
    double taxaFatorIOF =
        _controleAppController.controleAPP[0].taxaFatorIOF; // 0.0082
    double fatorIOF = taxaFatorIOF / 100;
    double valorAmortizacao = 0.0;

    int np = int.parse(_solicPostController.controllerParcelas.text);

    double juros = 0.0;

    var now = DateTime.now();

    var ultimoDiaMes;
    var dataCredito = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1)); //DIA SEGUINTE

    ultimoDiaMes = DateTime(now.year, now.month + 3, 0).day;

    dataPrimeiraPrestacao =
        DateTime(now.year, now.month + 2, ultimoDiaMes); //2 meses depois

    int dias = dataPrimeiraPrestacao.difference(dataCredito).inDays;
    var taxaJuros = taxa;

    ///2;= taxa!!
    var saldo = 0.0;
    var xiof = 0.0;
    DateTime dataVencimento = DateTime.parse(dataPrimeiraPrestacao.toString());
    int diasIOF;
    var ultimoDia;

    if (dias > 30) {
      juros = (valorFinanciado * taxaJuros / 100) / 30 * (dias - 30);
      saldo = valorFinanciado + juros;
    } else {
      saldo = valorFinanciado;
    }

    for (int i = 1; i <= np; i++) {
      diasIOF = dataVencimento.difference(dataCredito).inDays;

      if (diasIOF >= 365) diasIOF = 365;

      valorAmortizacao = Finance.ppmt(
              rate: taxa / 100, per: i, nper: np, pv: valorFinanciado) *
          -1;

      xiof = (valorAmortizacao * fatorIOF * diasIOF).toPrecision(2);

      iofAdicional = iofAdicional + xiof;

      ultimoDia =
          DateTime(dataVencimento.year, dataVencimento.month + 2, 0).day;

      dataVencimento =
          DateTime(dataVencimento.year, dataVencimento.month + 1, ultimoDia);
    }

    return iofAdicional;
  }

  calculaValores() {
    int parcelas = int.parse(_solicPostController.controllerParcelas.text);
    double taxaIOF = _controleAppController.controleAPP[0].taxaIOF; // 0.38

    List<CategoriasTaxasModel> categoriaInfos = categoriasTaxasController
        .categoriasTaxas
        .where(
            (cat) => cat.codigoCategoria.compareTo(widget.categoriaCodigo) == 0)
        .toList();

    setState(() {
      for (int i = 0; i < categoriaInfos.length; i++) {
        if (parcelas >= categoriaInfos[i].minParcela &&
            parcelas <= categoriaInfos[i].maxParcela) {
          taxa = double.parse(categoriaInfos[i].taxa.toString());
        }
      }

      /*if (widget.categoria.compareTo("NORMAL") == 0) {
        if (parcelas >= 1 && parcelas <= 4) {
          taxa = 1.00;
        }
        if (parcelas >= 5 && parcelas <= 8) {
          taxa = 1.20;
        }
        if (parcelas >= 9 && parcelas <= 12) {
          taxa = 1.30;
        }
        if (parcelas >= 13 && parcelas <= 24) {
          taxa = 1.50;
        }
        if (parcelas >= 25 && parcelas <= 36) {
          taxa = 1.80;
        }
      }

      if (widget.categoria.compareTo("CAMPANHA") == 0) {
        if (parcelas <= 6) {
          taxa = 0.89;
        }
        if (parcelas >= 7 && parcelas <= 18) {
          taxa = 0.99;
        }
        if (parcelas >= 19 && parcelas <= 60) {
          taxa = 1.60;
        }
      }*/

      print("TAXA = $taxa");

      valorFinanciado = double.parse(
          _convertDouble(_solicPostController.controllerValor.text));

      iofAdicional = calculaIOF(valorFinanciado, taxa);

      print("IOF adicional = $iofAdicional");

      iof = ((taxaIOF / 100) * valorFinanciado) + iofAdicional;

      valorDesconto = Finance.pmt(
            rate: taxa / 100,
            nper: parcelas,
            pv: (valorFinanciado + iof),
          ) *
          -1;

      print("DESCONTO = $valorDesconto");

      valorLiquido = valorFinanciado + iof;
    });
  }

  double calculaCETMes() {
    int parcelas = int.parse(_solicPostController.controllerParcelas.text);
    double valorContrato = valorLiquido;
    List<double> cetPrestacoes = [];
    double taxaIOF = _controleAppController.controleAPP[0].taxaIOF; // 0.38

    double xam = double.parse((valorContrato / parcelas).toStringAsFixed(2));
    double xpr;
    var soma;
    var xp;
    var xh;
    var xDIF;
    var xCET;

    for (int i = 1; i <= parcelas; i++) {
      xpr =
          double.parse(((valorContrato * taxa / 100) + xam).toStringAsFixed(2));

      if (i == 1) {
        xpr = xpr +
            double.parse((valorContrato * taxaIOF / 100).toStringAsFixed(2));
      }

      cetPrestacoes.add(xpr);
      valorContrato = valorContrato - xam;
    }

    for (double j = 0.0; j < 100.0; j = j + 0.01) {
      soma = 0.0;
      for (int i = 1; i <= parcelas; i++) {
        xp = pow((1 + j / 100), i);

        if (xp == 0) xp = 1;

        xh = double.parse((cetPrestacoes[i - 1] / xp).toStringAsFixed(2));

        soma = soma + xh;
      }
      if (soma != 0.0) {
        xDIF = soma - valorLiquido;

        if (xDIF < 0) {
          print("Encontrou o CET ideal");
          break;
        }
      }

      xCET = j;
      cetAno = double.parse(
          ((pow((1 + xCET / 100), 12) - 1) * 100).toStringAsFixed(2));
    }

    return xCET;
  }

  calculaCETAnual(double cetMes) {
    setState(() {
      cetAno = (pow((1 + cetMes / 100), 12) - 1) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    double cetMes = 0.0;
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'N??o foi poss??vel abrir $url';
      }
    }

    calculaValores();
    cetMes = calculaCETMes();
    calculaCETAnual(cetMes);

    print(
        "CET ANO = ${cetAno.toStringAsFixed(2)} /// ${cetMes.toStringAsFixed(2)}");

    handleCancel() {
      Get.back();
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
                    _solicPostController.saveSolicitacao(
                      widget.matricula,
                      widget.selectedRadio,
                      widget.categoria,
                      widget.protocolo,
                      tokenController.text,
                      widget.banco,
                      valorDesconto,
                      iof,
                      valorLiquido,
                      dataPrimeiraPrestacao.toString().substring(0, 23),
                    );

                    if (!Responsive.isDesktop(context)) Get.back();
                    Get.back();
                    Get.back();
                    Get.back();

                    Get.snackbar(
                      "Aguarde!",
                      "Sua solicita????o ser?? analisada pela Diretoria at?? o pr??ximo dia ??til.",
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

    /* getToken() {
      Get.dialog(
        AlertDialog(
          title: Text("Informe o token de opera????o:"),
          content: TextField(
            controller: tokenController,
            keyboardType: TextInputType.number,
            obscureText: false,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.vpn_key_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (tokenController.text.isNotEmpty) {
                    Get.back();
                    handleSolicitacao();
                  } else {
                    Get.back();

                    Get.snackbar(
                      "Informe o token!",
                      "?? necess??rio para concluir a solicita????o.",
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
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informa????es do empr??stimo",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: Responsive.isDesktop(context)
              ? EdgeInsets.symmetric(horizontal: alturaTela * 0.3)
              : EdgeInsets.zero,
          child: Column(
            children: [
              const SizedBox(height: 30),
              FittedBox(
                child: Text(
                  "Solicita????o de Empr??stimo",
                  style: TextStyle(
                    fontSize: alturaTela * 0.033, //26.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              CardInfo(
                title: "Valor L??quido",
                icon: Icons.attach_money,
                value: money.formatterMoney(valorFinanciado),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "N??mero de presta????es",
                icon: Icons.format_list_numbered_outlined,
                value: _solicPostController.controllerParcelas.text,
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "IOF",
                icon: Icons.info,
                value: money.formatterMoney(iof),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Estimativa de Desconto Mensal em Folha",
                icon: Icons.money_off,
                value: money.formatterMoney(valorDesconto),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Estimativa de Valor Financiado",
                icon: Icons.payment,
                value: money.formatterMoney(valorLiquido),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Total a pagar",
                icon: MdiIcons.cashMultiple,
                value: money.formatterMoney(double.parse((valorDesconto *
                        int.parse(_solicPostController.controllerParcelas.text))
                    .toString())),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Taxa de Juros",
                icon: MdiIcons.ticketPercentOutline,
                value: "$taxa%",
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "CET",
                icon: MdiIcons.percentOutline,
                value:
                    "${cetMes.toStringAsFixed(2)}% a.m. ${cetAno.toStringAsFixed(2)}% a.a.",
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Categoria",
                icon: Icons.format_align_left_outlined,
                value: widget.categoria,
              ),
              const SizedBox(height: 40),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      "Informe o token de opera????o:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        controller: tokenController,
                        validator: _validateToken,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _launchURL(
                    "https://portal.econsig.com.br/rjeconsig/servidor/#no-back"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                icon: Icon(Icons.vpn_key_outlined),
                label: Text('Clique aqui para gerar o token'),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(
                    "CANCELAR",
                    Colors.red,
                    handleCancel,
                    formKey,
                    widget.matricula,
                    widget.senha,
                    context,
                  ),
                  _buildButton(
                    "SOLICITAR",
                    Colors.green[300],
                    handleSolicitacao,
                    formKey,
                    widget.matricula,
                    widget.senha,
                    context,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildButton(
  String text,
  Color color,
  Function function,
  GlobalKey<FormState> formKey,
  int matricula,
  String senha,
  BuildContext context,
) {
  return Container(
    // padding: EdgeInsets.only(top: 100.0),
    child: SizedBox(
      height: 40.0,
      width: 140.0,
      child: ElevatedButton(
        onPressed: () {
          if (text.compareTo("SOLICITAR") == 0) {
            if (formKey.currentState.validate()) {
              function();
              Get.dialog(
                WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title: Text("TERMO DE PESSOA POLITICAMENTE EXPOSTA"),
                    content: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: PessoaExpostaPage(
                        matricula: matricula,
                        senha: senha,
                        solicPage: true,
                      ),
                    ),
                  ),
                ),
                barrierDismissible: false,
              );
            }
          } else {
            function();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(color: color),
          ),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        )),
      ),
    ),
  );
}

String _validateToken(String value) {
  if (value.isEmpty) return 'Infome o token para completar a solicita????o.';

  return null;
}
