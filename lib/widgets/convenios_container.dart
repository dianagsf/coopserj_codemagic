import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConveniosContainer extends StatefulWidget {
  final int matricula;

  const ConveniosContainer({
    Key key,
    this.matricula,
  }) : super(key: key);

  @override
  _ConveniosContainerState createState() => _ConveniosContainerState();
}

class _ConveniosContainerState extends State<ConveniosContainer> {
  ConveniosContrController contrController =
      Get.put(ConveniosContrController());

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
            child: Row(
              children: [
                Image.asset(
                  "images/convenios.png",
                  width: 150,
                  height: 150,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Convênios",
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
          const SizedBox(height: 20),
          GetX<ConveniosContrController>(
            initState: (state) {
              contrController.getConveniosContr(widget.matricula);
            },
            builder: (_) {
              return _.conveniosContr.length < 1
                  ? Center(child: CircularProgressIndicator())
                  : InfosValue(
                      total: _.conveniosContr[0].total != null
                          ? money.formatterMoney(
                              double.parse(
                                  _.conveniosContr[0].total.toString()),
                            )
                          : 'R\$ 0,00',
                      desconto: _.conveniosContr[0].desconto != null
                          ? money.formatterMoney(
                              double.parse(
                                  _.conveniosContr[0].desconto.toString()),
                            )
                          : 'R\$ 0,00',
                      quantidade: _.conveniosContr[0].quantidade != null
                          ? _.conveniosContr[0].quantidade
                          : 0,
                      colors: [
                          Colors.blue[700],
                          Colors.blueGrey,
                        ] //[Colors.blue[700], Colors.pinkAccent],
                      );
            },
          ),
          const SizedBox(height: 15),
          ConveniosTable()
        ],
      ),
    );
  }
}
