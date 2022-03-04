import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefinanciarEmprestimoPage extends StatefulWidget {
  final String senha;
  final int matricula;

  const RefinanciarEmprestimoPage({
    Key key,
    @required this.senha,
    @required this.matricula,
  }) : super(key: key);

  @override
  _RefinanciarEmprestimoPageState createState() =>
      _RefinanciarEmprestimoPageState();
}

class _RefinanciarEmprestimoPageState extends State<RefinanciarEmprestimoPage> {
  PropostaController propostaController = Get.find();

  PropostaModel selectedEmp;

  handleSelectEmp(bool value, PropostaModel prop) {
    setState(() {
      if (value) {
        selectedEmp = prop;
      } else {
        selectedEmp = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    FormatMoney money = FormatMoney();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Refinanciamento de empréstimos",
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
        padding: const EdgeInsets.all(20),
        alignment: Responsive.isDesktop(context)
            ? Alignment.center
            : Alignment.centerLeft,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                alignment: Responsive.isDesktop(context)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: Text(
                  'Selecione o empréstimo que deseja refinanciar: ',
                  style: TextStyle(
                    fontSize: alturaTela * 0.025,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: Container(
                alignment: Responsive.isDesktop(context)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: _tableRefinanciamento(
                  money,
                  selectedEmp,
                  handleSelectEmp,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: alturaTela * 0.3),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 18),
                padding: Responsive.isDesktop(context)
                    ? EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.2)
                    : EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                height: alturaTela * 0.055, //45,
                width: Responsive.isDesktop(context)
                    ? MediaQuery.of(context).size.width * 0.4
                    : MediaQuery.of(context).size.width * 0.73,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedEmp != null) {
                      Get.to(
                        InfoRefinanciamentoPage(
                          selectedEmp: selectedEmp,
                          senha: widget.senha,
                          matricula: widget.matricula,
                        ),
                      );
                    } else {
                      Get.dialog(
                        AlertDialog(
                          title: Text("Atenção!"),
                          content: Text(
                            "Selecione o empréstimo que deseja refinanciar.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'OK',
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      "Solicitar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: alturaTela * 0.025,
                        fontWeight: FontWeight.w500,
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

Widget _tableRefinanciamento(
  FormatMoney money,
  PropostaModel selectedEmp,
  Function handleSelectEmp,
) {
  return GetX<PropostaController>(builder: (_) {
    return _.propostas.length < 1
        ? Text(
            "Nenhum empréstimo ativo no momento.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: true,
              columns: [
                DataColumn(
                  label: Text(
                    "Número",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Valor p/ quitação",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Data",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Valor Liberado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Prestação",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "NPC",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "NPF",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              rows: _.propostas.map((prop) {
                var data = prop.data != null
                    ? formatDate(
                        DateTime.parse(prop.data),
                        [dd, '/', mm, '/', yyyy],
                      )
                    : '-';
                var valor = prop.valorcr != null
                    ? money
                        .formatterMoney(double.parse(prop.valorcr.toString()))
                    : '-';
                var prestacao = prop.prestacao != null
                    ? money
                        .formatterMoney(double.parse(prop.prestacao.toString()))
                    : '-';

                var valQuitacao = prop.valor != null
                    ? money.formatterMoney(
                        double.parse((prop.valorQuitacao.toString())))
                    : '-';
                return DataRow(
                  selected:
                      selectedEmp != null && selectedEmp.numero == prop.numero,
                  onSelectChanged: (value) {
                    handleSelectEmp(value, prop);
                  },
                  cells: [
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          prop.numero != null ? "${prop.numero}" : '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          valQuitacao,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          data,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          valor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          prestacao,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          prop.npc != null ? "${prop.npc}" : '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          prop.npf != null ? "${prop.npf}" : '-',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
  });
}
