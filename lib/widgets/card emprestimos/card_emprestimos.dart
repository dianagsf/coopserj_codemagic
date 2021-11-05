import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardEmprestimos extends StatefulWidget {
  final int matricula;

  const CardEmprestimos({
    Key key,
    @required this.matricula,
  }) : super(key: key);

  @override
  _CardEmprestimosState createState() => _CardEmprestimosState();
}

class _CardEmprestimosState extends State<CardEmprestimos> {
  EmpContratadosController empContratadosController = Get.find();

  FormatMoney money = FormatMoney();

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GetX<EmpContratadosController>(
      builder: (_) {
        return _.empContratados.length < 1
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    width: constraints.maxWidth,
                    height: alturaTela * 0.27,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          width: 6.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          "Empréstimos Contratados",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: alturaTela * 0.03, //24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildCardEmprestimo(
                              _.empContratados[0].total != null
                                  ? money.formatterMoney(double.parse(
                                      _.empContratados[0].total.toString()))
                                  : '0',
                              'Total Contr.',
                              alturaTela,
                              context,
                              false,
                              Colors.white,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.024),
                            buildCardEmprestimo(
                              _.empContratados[0].desconto != null
                                  ? money.formatterMoney(double.parse(
                                      _.empContratados[0].desconto.toString()))
                                  : '0',
                              'Desc. Total',
                              alturaTela,
                              context,
                              false,
                              Colors.white,
                            ),
                            Expanded(
                              child: Container(
                                width: 85,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _.empContratados[0].quantidade != null
                                              ? _.empContratados[0].quantidade
                                                  .toString()
                                              : "0",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  alturaTela * 0.027, //22.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Qtd.',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                alturaTela * 0.017, //14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
      },
    );
  }
}
