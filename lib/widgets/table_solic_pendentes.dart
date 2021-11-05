import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TableSolicPendentes extends StatefulWidget {
  final int matricula;
  const TableSolicPendentes({
    Key key,
    @required this.matricula,
  }) : super(key: key);

  @override
  _TableSolicPendentesState createState() => _TableSolicPendentesState();
}

class _TableSolicPendentesState extends State<TableSolicPendentes> {
  final SolicPendentesController solicPendentesController = Get.find();

  FormatMoney money = FormatMoney();

  @override
  Widget build(BuildContext context) {
    return GetX<SolicPendentesController>(
      initState: (state) {
        solicPendentesController.getSolicPendentes(widget.matricula);
      },
      builder: (_) {
        return _.solicPendentes.length < 1
            ? Text(
                "Nenhuma solicitação no momento.",
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
                      label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 15),
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
                      label: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Valor",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "NP",
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
                      label: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: _.solicPendentes.map((sol) {
                    var data = sol.data != null
                        ? formatDate(
                            DateTime.parse(sol.data),
                            [dd, '/', mm, '/', yyyy],
                          )
                        : '-';

                    var valor = sol.valor != null
                        ? money
                            .formatterMoney(double.parse(sol.valor.toString()))
                        : '-';

                    var prestacao = sol.prestacao != null
                        ? money.formatterMoney(
                            double.parse(sol.prestacao.toString()))
                        : '-';

                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$data",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$valor",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              sol.np != null ? "${sol.np}" : '-',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "$prestacao",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "em análise",
                              textAlign: TextAlign.center,
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
