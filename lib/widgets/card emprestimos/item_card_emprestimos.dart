// Card Empréstimos Contratados
import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/material.dart';

Widget buildCardEmprestimo(
  String value,
  String title,
  double alturaTela,
  BuildContext context,
  bool homePage,
  Color color,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25.0),
    child: Card(
      elevation: 5,
      color: color,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * 0.24, //100.0,
        height: alturaTela * 0.12, //90.0,
        color: color,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: homePage ? Colors.white : Colors.black,
                  fontSize: Responsive.isMobile(context)
                      ? alturaTela * 0.02
                      : alturaTela * 0.03, //16.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: alturaTela * 0.012, //10,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  color: homePage ? Colors.white : Colors.black,
                  fontSize: Responsive.isMobile(context)
                      ? alturaTela * 0.016
                      : alturaTela * 0.02, //13.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
