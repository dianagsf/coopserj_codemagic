import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmprestimosContainer extends StatefulWidget {
  final int matricula;

  const EmprestimosContainer({
    Key key,
    this.matricula,
  }) : super(key: key);

  @override
  _EmprestimosContainerState createState() => _EmprestimosContainerState();
}

class _EmprestimosContainerState extends State<EmprestimosContainer> {
  PropostaController propostaController = Get.put(PropostaController());
  EmpContratadosController empContratadosController =
      Get.put(EmpContratadosController());

  FormatMoney money = FormatMoney();

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Responsive(
              mobile: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Empréstimos",
                      style: TextStyle(
                        fontSize: alturaTela * 0.034, //28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Image.asset(
                    "images/emprestimos.png",
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
              tablet: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/emprestimos.png",
                    width: 150,
                    height: 150,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Empréstimos",
                      style: TextStyle(
                        fontSize: alturaTela * 0.034, //28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "images/emprestimos.png",
                    width: 150,
                    height: 150,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Empréstimos",
                      style: TextStyle(
                        fontSize: alturaTela * 0.034, //28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GetX<EmpContratadosController>(
            initState: (state) {
              empContratadosController.getEmpContratados(widget.matricula);
            },
            builder: (_) {
              return _.empContratados.length < 1
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        InfosValue(
                          total: _.empContratados[0].total != null
                              ? money.formatterMoney(
                                  double.parse(
                                      _.empContratados[0].total.toString()),
                                )
                              : 'R\$ 0,00',
                          desconto: _.empContratados[0].desconto != null
                              ? money.formatterMoney(
                                  double.parse(
                                      _.empContratados[0].desconto.toString()),
                                )
                              : 'R\$ 0,00',
                          quantidade: _.empContratados[0].quantidade,
                          colors: [
                            Colors.blue[700],
                            Colors.blueGrey,
                          ], //[Colors.pinkAccent, Colors.blue[700]],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
            },
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: GetX<PropostaController>(
                initState: (state) {
                  propostaController.getPropostasUser(widget.matricula);
                },
                builder: (_) {
                  return _.propostas.length < 1
                      ? Text(
                          "Nenhum contrato ativo no momento.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        )
                      : TableEmprestimos(
                          propostas: _.propostas,
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
