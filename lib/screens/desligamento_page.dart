import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DesligamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pedido de Desligamento",
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  "Para efetuar o desligamento, entre em contato conosco:",
                  style: TextStyle(fontSize: alturaTela * 0.03), //22),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "por telefone:",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: alturaTela * 0.03, //20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      MdiIcons.phoneClassic,
                      size: alturaTela * 0.035, //35,
                      color: Colors.blue,
                    ),
                    Text(
                      "(21) 3282-7300",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: alturaTela * 0.03, //20,
                      ),
                    ),
                    Text(
                      "(21) 99235-6817",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: alturaTela * 0.03, //20,
                      ),
                    ),
                    Text(
                      "(21) 99233-9586",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: alturaTela * 0.03, //20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "ou através do e-mail:",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: alturaTela * 0.03, //20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      MdiIcons.at,
                      size: alturaTela * 0.035, //35,
                      color: Colors.blue,
                    ),
                    Text(
                      "atendimento@coopserj.coop.br",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: alturaTela * 0.03, //20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
