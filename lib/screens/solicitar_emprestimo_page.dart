import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SolicitarEmprestimoPage extends StatefulWidget {
  final int matricula;
  final String senha;

  const SolicitarEmprestimoPage({
    Key key,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);
  @override
  _SolicitarEmprestimoPageState createState() =>
      _SolicitarEmprestimoPageState();
}

class _SolicitarEmprestimoPageState extends State<SolicitarEmprestimoPage> {
  SolicitacaoPostController _solicPostController =
      Get.put(SolicitacaoPostController());
  CategoriasController categoriasController = Get.find();
  BancosController bancosController = Get.find();

  FormatMoney money = FormatMoney();
  final formKey = new GlobalKey<FormState>();

  int protocolo;
  int selectedRadio;

  /*List<String> categorias = [
    "a. NORMAL",
    "b. ANIVERSÁRIO",
    "c. BOLETA",
    "d. COOP RENEGOCIA",
  ];*/

  CategoriasModel categoria;
  BancosModel banco;

  @override
  void initState() {
    super.initState();
    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Solicitação de empréstimos",
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
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              //CARD RESUMO EMPRÉSTIMOS CONTRATADOS
              Container(
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(horizontal: alturaTela * 0.3)
                    : EdgeInsets.zero,
                child: Card(
                  elevation: 2,
                  child: CardEmprestimos(matricula: widget.matricula),
                ),
              ),
              /*const SizedBox(height: 20),
              TableRegulamentoCredito(),*/
              const SizedBox(height: 40),
              Text(
                "Solicitação #${protocolo.toString()}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: Responsive.isDesktop(context)
                      ? EdgeInsets.symmetric(horizontal: alturaTela * 0.5)
                      : const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        'Solicitação R\$ (VALOR LÍQUIDO PRETENDIDO)',
                        _solicPostController.controllerValor,
                        false,
                        validateTextField: _validateTextField,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Quantidade de parcelas',
                        _solicPostController.controllerParcelas,
                        true,
                        validateTextField: (value) =>
                            _validateParcelas(value, categoria),
                      ),
                      /*Text(
                        "* permitido até 60 parcelas",
                        style: TextStyle(
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                            fontSize: 15.0),
                      ),*/
                      const SizedBox(height: 25),
                      Text(
                        'Modalidade',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      GetX<CategoriasController>(
                        builder: (_) {
                          return _.categorias.length < 1
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: [
                                    DropdownButton(
                                      isExpanded: true,
                                      value: categoria,
                                      hint: Text(
                                        "Selecione a modalidade do empréstimo ...",
                                      ),
                                      items: _.categorias
                                          .map(
                                            (c) => DropdownMenuItem(
                                                child: Text(
                                                    "${c.codigo}. ${c.nome}"),
                                                value: c),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          categoria = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    categoria != null
                                        ? tableModalidade(categoria.nome)
                                        : SizedBox.shrink(),
                                  ],
                                );
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Salário R\$',
                        _solicPostController.controllerSalario,
                        false,
                        validateTextField: _validateTextField,
                      ),
                      const SizedBox(height: 20),
                      /*_buildTextField(
                        'Líquido (Contra-Cheque) R\$',
                        _solicPostController.controllerLiquido,
                        false,
                        validateTextField: _validateTextField,
                      ),*/
                      const SizedBox(height: 45),
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
                      /*TextFormField(
                        validator: _validateDados,
                        controller: _solicPostController.bancoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nome do Banco",
                        ),
                      ),*/
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Número da Agência',
                        _solicPostController.agenciaController,
                        true,
                        validateTextField: _validateDados,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Número da Conta',
                        _solicPostController.contaController,
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
                        controller: _solicPostController.telController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MdiIcons.phone,
                            size: 20,
                          ),
                          hintText: "(00) 00000-0000",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 45),
              Container(
                height: alturaTela * 0.055, //45,
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.73,

                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      Get.to(
                        InfosSolicPage(
                          matricula: widget.matricula,
                          selectedRadio: selectedRadio,
                          categoria: categoria.nome,
                          protocolo: protocolo,
                          senha: widget.senha,
                          banco: "${banco.codigo} - ${banco.nome}",
                        ),
                      );
                      //_handleSolicitar();
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
            ],
          ),
        ),
      ),
    );
  }
}

Widget tableModalidade(String categoria) {
  return Column(
    children: [
      Text(
        "Taxas modalidade ${categoria.toLowerCase()}",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                "Taxa",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Container(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "Prazo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          rows: categoria.compareTo("NORMAL") == 0
              ? [
                  _buildRowTableCredito(
                    '1,00%',
                    '01 a 04 meses',
                  ),
                  _buildRowTableCredito(
                    '1,20%',
                    '05 a 08 meses',
                  ),
                  _buildRowTableCredito(
                    '1,30%',
                    '09 a 12 meses',
                  ),
                  _buildRowTableCredito(
                    '1,50%',
                    '13 a 24 meses',
                  ),
                  _buildRowTableCredito(
                    '1,80%',
                    '25 a 36 meses',
                  ),
                ]
              : [
                  _buildRowTableCredito(
                    '0,89%',
                    'até 6 parcelas',
                  ),
                  _buildRowTableCredito(
                    '0,99%',
                    'de 7 a 18 parcelas',
                  ),
                  _buildRowTableCredito(
                    '1,60%',
                    'de 19 a 60 parcelas',
                  ),
                ],
        ),
      ),
    ],
  );
}

/*class TableRegulamentoCredito extends StatelessWidget {
  const TableRegulamentoCredito({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ExpansionTile(
        title: Text(
          "Escolha a Modalidade de Empréstimo",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    "Taxa",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      "Prazo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
              rows: [
                _buildRowTableCredito(
                  '0,89%',
                  'até 6 parcelas',
                ),
                _buildRowTableCredito(
                  '0,99%',
                  'de 7 a 12 parcelas',
                ),
                _buildRowTableCredito(
                  '1,60%',
                  'de 13 a 60 parcelas',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/

DataRow _buildRowTableCredito(
  String taxa,
  String prazo,
) {
  return DataRow(
    cells: [
      DataCell(
        Container(
          alignment: Alignment.center,
          child: Text(
            taxa,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataCell(
        Container(
          alignment: Alignment.center,
          child: Text(
            prazo,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}

// VALIDA TEXTFIELD
String _validateTextField(String value) {
  if (value.compareTo("0,00") == 0) {
    return '* Este campo é obrigatório. Informe um valor';
  }
  return null;
}

String _validateParcelas(String value, CategoriasModel categoria) {
  if (value.isEmpty) return '* Este campo é obrigatório. Informe um valor';
  if (categoria.nome.compareTo("CAMPANHA") == 0 && int.parse(value) > 60) {
    return 'O número máximo de parcelas permitido é 60';
  }
  if (categoria.nome.compareTo("NORMAL") == 0 && int.parse(value) > 36) {
    return 'O número máximo de parcelas permitido é 36';
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
