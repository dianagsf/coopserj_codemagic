import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class InfosValue extends StatelessWidget {
  final String total;
  final String desconto;
  final int quantidade;
  final List<Color> colors;

  const InfosValue({
    Key key,
    this.total,
    this.desconto,
    this.quantidade,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: buildCardEmprestimo(
              total,
              'Total Contr.',
              alturaTela,
              context,
              true,
              colors[0],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.024),
          Expanded(
            child: buildCardEmprestimo(
              desconto,
              'Desc. Total',
              alturaTela,
              context,
              true,
              colors[1],
            ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          quantidade.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: alturaTela * 0.027, //22.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          'Qtd.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: alturaTela * 0.017, //14.0,
                            fontWeight: FontWeight.w600,
                          ),
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
    );
  }
}
