import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConveniosTable extends StatefulWidget {
  @override
  _ConveniosTableState createState() => _ConveniosTableState();
}

class _ConveniosTableState extends State<ConveniosTable> {
  ConveniosController conveniosController = Get.find();

  FormatMoney money = FormatMoney();

  @override
  Widget build(BuildContext context) {
    return GetX<ConveniosController>(
      builder: (_) {
        return _.convenios.length < 1
            ? Text(
                "Nenhum convênio ativo no momento.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
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
                        "Data início",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Nome Convênio",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Valor Mensal",
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
                        "Prestação",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Saldo Devedor",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Mais Detalhes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                  rows: _.convenios.map((conv) {
                    var dataInicio = conv.dataInicio != null
                        ? formatDate(
                            DateTime.parse(conv.dataInicio),
                            [dd, '/', mm, '/', yyyy],
                          )
                        : '-';
                    var valorMensal = conv.valor != null
                        ? money
                            .formatterMoney(double.parse(conv.valor.toString()))
                        : '-';
                    var prestacao = conv.prestacao != null
                        ? money.formatterMoney(
                            double.parse(conv.prestacao.toString()))
                        : '-';

                    var devedor = conv.devedor != null
                        ? money.formatterMoney(
                            double.parse(conv.devedor.toString()))
                        : '-';

                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              conv.numero != null ? "${conv.numero}" : '-',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$dataInicio",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              conv.nome == null
                                  ? '-'
                                  : conv.nome.contains('RENEG')
                                      ? "RENEGOCIAÇÃO"
                                      : "${conv.nome}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              valorMensal,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              conv.npc != null
                                  ? conv.npc.toString().compareTo("999") == 0
                                      ? "fixo"
                                      : "${conv.npc}"
                                  : '-',
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
                              devedor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Get.to(ConveniosDetalhes(convenio: conv));
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
      },
    );
  }
}
