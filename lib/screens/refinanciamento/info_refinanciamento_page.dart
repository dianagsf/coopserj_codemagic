import 'dart:math';

import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:finance/finance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoRefinanciamentoPage extends StatefulWidget {
  final PropostaModel selectedEmp;
  final String senha;
  final int matricula;

  const InfoRefinanciamentoPage({
    Key key,
    @required this.selectedEmp,
    @required this.senha,
    @required this.matricula,
  }) : super(key: key);

  @override
  _InfoRefinanciamentoPageState createState() =>
      _InfoRefinanciamentoPageState();
}

class _InfoRefinanciamentoPageState extends State<InfoRefinanciamentoPage> {
  MaskedTextController tokenController = MaskedTextController(mask: "00000000");
  MaskedTextController senhaController = MaskedTextController(mask: "000000");

  MoneyMaskedTextController _controllerSalario =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  MaskedTextController _telController =
      MaskedTextController(mask: "(00) 00000-0000");

  TextEditingController _agenciaController = TextEditingController();
  TextEditingController _contaController = TextEditingController();

  TextEditingController numParcelasController = TextEditingController();

  ControleAppController _controleAppController = Get.find();
  BancosController bancosController = Get.find();
  BancosModel banco;

  RefinanciamentoRepository refinanciamentoRepository =
      RefinanciamentoRepository();

  final formKey = new GlobalKey<FormState>();

  FormatMoney money = FormatMoney();
  double valorFinanciado = 0.0;
  double valorDesconto = 0.0;
  double valorLiquido = 0.0;
  double valorLiquidoIOF = 0.0;
  double iof = 0.0;
  double iofAdicional = 0.0;
  double taxaJuros = 0.0;
  double cetAno = 0.0;
  double cetMes = 0.0;
  DateTime dataPrimeiraPrestacao;
  int numPrestacao;
  int prestacaoPositiva;
  int protocolo;

  @override
  void initState() {
    super.initState();

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;

    taxaJuros = _controleAppController.controleAPP[0].taxaRefin;

    numPrestacao = widget.selectedEmp.npc;

    valorFinanciado = calculaRefin(numPrestacao);
    calculaValores(numPrestacao);
    prestacaoPositiva = numPrestacao;

    if (valorLiquido < 0) {
      for (int i = numPrestacao; i <= 60; i++) {
        valorFinanciado = calculaRefin(i);
        calculaValores(i);

        if (valorLiquido > 0) {
          numPrestacao = i;
          prestacaoPositiva = i;
          break;
        }
      }
    }
    if (valorLiquido > 0) {
      cetMes = calculaCETMes();
      calculaCETAnual(cetMes);
    }
  }

  double calculaRefin(int numPrestacao) {
    double prestacaoEmp = double.parse(widget.selectedEmp.prestacao.toString());

    /// COLOCAR NA TABELA CONTROLE!!!!

    double prestacao = 0.0;
    double hj = 0.0;
    double valorFinanciado = 0.0;

    for (double i = 10; i <= 200000; i = i + 0.10) {
      prestacao = double.parse(
            Finance.pmt(
              rate: taxaJuros / 100,
              nper: numPrestacao, //widget.selectedEmp.npc,
              pv: i,
            ).toString(),
          ).toPrecision(2) *
          -1;

      if (prestacao >= prestacaoEmp) {
        hj = i;

        break;
      }
    }

    valorFinanciado = hj.toPrecision(2);

    return valorFinanciado;
  }

  // valor liquido!!!!!!!!!!!!!!!!!!!!!!!!
  double calculaIOF(
    double valorLiquidoIOF,
    double taxa,
    int numPrestacao,
  ) {
    double iofAdicional = 0.0;
    double taxaFatorIOF =
        _controleAppController.controleAPP[0].taxaFatorIOF; // 0.0082
    double fatorIOF = taxaFatorIOF / 100;
    double valorAmortizacao = 0.0;

    int np = numPrestacao; //widget.selectedEmp.npc;

    double juros = 0.0;

    var now = DateTime.now();

    var ultimoDiaMes;
    var dataCredito = DateTime(now.year, now.month, now.day)
        .add(Duration(days: 1)); //DIA SEGUINTE

    ultimoDiaMes = DateTime(now.year, now.month + 2, 0).day;

    dataPrimeiraPrestacao =
        DateTime(now.year, now.month + 1, ultimoDiaMes); // 1 mês depois

    int dias = dataPrimeiraPrestacao.difference(dataCredito).inDays;
    var taxaJuros = taxa;
    var saldo = 0.0;
    var xiof = 0.0;
    DateTime dataVencimento = DateTime.parse(dataPrimeiraPrestacao.toString());
    int diasIOF;
    var ultimoDia;

    if (dias > 30) {
      juros = (valorLiquidoIOF * taxaJuros / 100) / 30 * (dias - 30);
      saldo = valorLiquidoIOF + juros;
    } else {
      saldo = valorLiquidoIOF;
    }

    for (int i = 0; i < np; i++) {
      diasIOF = dataVencimento.difference(dataCredito).inDays;

      if (diasIOF >= 365) diasIOF = 365;

      valorAmortizacao = Finance.ppmt(
              rate: taxa / 100, per: i, nper: np, pv: valorLiquidoIOF) *
          -1;

      xiof = valorAmortizacao * fatorIOF * diasIOF;

      iofAdicional = iofAdicional + xiof;

      ultimoDia =
          DateTime(dataVencimento.year, dataVencimento.month + 2, 0).day;

      dataVencimento =
          DateTime(dataVencimento.year, dataVencimento.month + 1, ultimoDia);
    }

    return iofAdicional.toPrecision(2);
  }

  calculaValores(int numPrestacao) {
    double taxaIOF = _controleAppController.controleAPP[0].taxaIOF; // 0.38

    setState(() {
      valorLiquidoIOF = valorFinanciado -
          double.parse(widget.selectedEmp.valorQuitacao.toString());

      iofAdicional = calculaIOF(valorLiquidoIOF, taxaJuros, numPrestacao);

      print("IOF adicional = $iofAdicional");

      iof = ((taxaIOF / 100) * valorLiquidoIOF) + iofAdicional;

      valorDesconto = double.parse(widget.selectedEmp.prestacao.toString());

      valorLiquido = valorLiquidoIOF - iof;
    });
  }

  double calculaCETMes() {
    int parcelas = numPrestacao; // widget.selectedEmp.npc;
    double valorContrato = valorLiquido;
    List<double> cetPrestacoes = [];
    double taxaIOF = _controleAppController.controleAPP[0].taxaIOF; // 0.38

    print("VAOR CONTRATO = $valorLiquido");

    double xam = double.parse((valorContrato / parcelas).toStringAsFixed(2));
    double xpr;
    var soma;
    var xp;
    var xh;
    var xDIF;
    var xCET;

    for (int i = 1; i <= parcelas; i++) {
      xpr = double.parse(
          ((valorContrato * taxaJuros / 100) + xam).toStringAsFixed(2));

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
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    //Convert money type to double
    String _convertDouble(String value) {
      String valor = value.replaceAll(',', '.');
      var valorDouble = [];
      valorDouble = valor.split(".");
      if (valorDouble != null) if (valorDouble.length == 2) {
        return "${valorDouble[0]}" + "." + "${valorDouble[1]}";
      } else {
        return "${valorDouble[0]}" +
            "${valorDouble[1]}" +
            "." +
            "${valorDouble[2]}";
      }

      return "${valorDouble[0]}";
    }

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    handleMaisParcelas() {
      if (valorLiquido < 0) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Não foi possível realizar o refinanciamento deste contrato. Para mais informações, entre em contato com a Coopserj.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      } else {
        Get.dialog(
          AlertDialog(
            title: Text("Informe o número de parcelas (até 60x):"),
            content: Form(
              child: TextFormField(
                controller: numParcelasController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add_chart),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (int.parse(numParcelasController.text) > 60 ||
                        int.parse(numParcelasController.text) <
                            prestacaoPositiva) {
                      Get.dialog(
                        AlertDialog(
                          title: Text("Atenção!"),
                          content: Text(
                            "Você deve informar um número de parcelas maior do que $prestacaoPositiva e menor do 60 (máx parcelas).",
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                numParcelasController.text = '';
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        numPrestacao = int.parse(numParcelasController.text);
                        valorFinanciado = calculaRefin(numPrestacao);
                        calculaValores(numPrestacao);
                        cetMes = calculaCETMes();
                        calculaCETAnual(cetMes);
                        Get.back();
                        numParcelasController.text = '';
                      });
                    }
                  },
                  child: Text("CONFIRMAR")),
            ],
          ),
        );
      }
    }

    handleSolicitacao() {
      if (banco == null) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Você deve selecionar o banco.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      }
      if (valorLiquido < 0) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Não foi possível realizar o refinanciamento deste contrato. Para mais informações, entre em contato com a Coopserj.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      }

      if (banco != null && valorLiquido > 0) {
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
                      refinanciamentoRepository.saveRefin({
                        "numero": protocolo,
                        "data": DateTime.now().toString().substring(0, 23),
                        "matricula": widget.matricula,
                        "valor": valorFinanciado.toPrecision(2),
                        "np": numPrestacao,
                        "salario": _convertDouble(_controllerSalario.text),
                        "iof": iof.toPrecision(2),
                        "prestacao": valorDesconto.toPrecision(2),
                        "valorcr": valorLiquido.toPrecision(2),
                        "banco": "${banco.codigo} - ${banco.nome}",
                        "agencia": int.parse(_agenciaController.text),
                        "conta": int.parse(_contaController.text),
                        "telefone": _telController.text,
                        "token": tokenController.text,
                        "datavencimento":
                            dataPrimeiraPrestacao.toString().substring(0, 23),
                        "contratos": widget.selectedEmp.numero,
                      });

                      if (!Responsive.isDesktop(context)) Get.back();
                      Get.back();
                      Get.back();
                      Get.back();

                      Get.snackbar(
                        "Aguarde!",
                        "Sua solicitação será analisada pela Diretoria.",
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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informações do refinanciamento",
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Refinanciamento de Empréstimo",
                    style: TextStyle(
                      fontSize: alturaTela * 0.026, //26.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Contrato #${widget.selectedEmp.numero}",
                style: TextStyle(
                  fontSize: alturaTela * 0.02, //26.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30.0),
              CardInfo(
                title: "Valor Líquido",
                icon: Icons.attach_money,
                value: money.formatterMoney(valorLiquido),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Número de prestações",
                icon: Icons.format_list_numbered_outlined,
                value: numPrestacao
                    .toString(), //widget.selectedEmp.npc.toString(),
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
                value: money.formatterMoney(valorFinanciado),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Total a pagar",
                icon: MdiIcons.cashMultiple,
                value: money.formatterMoney(valorDesconto * numPrestacao),
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "Taxa de Juros",
                icon: MdiIcons.ticketPercentOutline,
                value: "$taxaJuros%",

                /// COLOCAR NA TABELA!!!
              ),
              const SizedBox(height: 10.0),
              Divider(height: 5.0),
              CardInfo(
                title: "CET",
                icon: MdiIcons.percentOutline,
                value:
                    "${cetMes.toStringAsFixed(2)}% a.m. ${cetAno.toStringAsFixed(2)}% a.a.",
              ),
              const SizedBox(height: 40),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text(
                        "Informe os dados a seguir para completar a solicitação:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Salário R\$',
                        _controllerSalario,
                        false,
                        validateTextField: _validateSalario,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Dados Bancários",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Obs.: Você deve ser o titular da conta para a solicitação ser realizada com sucesso.",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GetX<BancosController>(
                        builder: (_) {
                          return _.bancos.length < 1
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    DropdownButton(
                                      isExpanded: true,
                                      value: banco,
                                      hint: Text(
                                        "Selecione o banco ...",
                                      ),
                                      items: _.bancos
                                          .map(
                                            (b) => DropdownMenuItem(
                                              child: Text(
                                                  "${b.codigo} - ${b.nome}"),
                                              value: b,
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          banco = value;
                                        });
                                      },
                                    ),
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Número da Agência',
                        _agenciaController,
                        true,
                        validateTextField: _validateDados,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Número da Conta',
                        _contaController,
                        true,
                        validateTextField: _validateConta,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Informe um telefone para contato",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        validator: _validateDados,
                        controller: _telController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MdiIcons.phone,
                            size: 20,
                          ),
                          hintText: "(00) 00000-0000",
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Informe o token de operação:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: tokenController,
                        validator: _validateToken,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                    "+ PARCELAS",
                    Colors.blue,
                    handleMaisParcelas,
                    formKey,
                  ),
                  _buildButton(
                    "SOLICITAR",
                    Colors.green[300],
                    handleSolicitacao,
                    formKey,
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

// TextField do formulário
Widget _buildTextField(
    String text, TextEditingController controller, bool notMoney,
    {Function validateTextField}) {
  return TextFormField(
    validator: validateTextField,
    controller: controller,
    keyboardType: TextInputType.number,
    decoration:
        InputDecoration(prefixText: notMoney ? '' : 'R\$', labelText: text),
  );
}

Widget _buildButton(
  String text,
  Color color,
  Function function,
  GlobalKey<FormState> formKey,
) {
  return Container(
    // padding: EdgeInsets.only(top: 100.0),
    child: SizedBox(
      height: 40.0,
      width: 140.0,
      child: ElevatedButton(
        onPressed: () {
          if (text.compareTo("SOLICITAR") == 0) {
            if (formKey.currentState.validate()) function();
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

String _validateSalario(String value) {
  if (value.compareTo("0,00") == 0) {
    return '* Este campo é obrigatório. Informe um valor';
  }
  return null;
}

String _validateDados(String value) {
  if (value.isEmpty) return '* Este campo é obrigatório. Informe os dados';

  return null;
}

String _validateConta(String value) {
  if (value.isEmpty) return '* Este campo é obrigatório. Informe os dados';

  if (!value.isNumericOnly) return 'Digite apenas os números, sem o -';

  return null;
}

String _validateToken(String value) {
  if (value.isEmpty) return 'Infome o token para completar a solicitação.';

  return null;
}
