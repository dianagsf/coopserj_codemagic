import 'package:flutter/material.dart';

class InfosDevedor extends StatelessWidget {
  final String total;

  const InfosDevedor({
    Key key,
    this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
          margin: const EdgeInsets.only(left: 15, right: 10),
          child: Text(
            "Realize a transferência no valor de $total para:",
            style: TextStyle(
              fontSize: alturaTela * 0.025,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _bancoInfos(alturaTela, "Banco Itaú", "6015", "04151-7"),
        const SizedBox(height: 10),
        _bancoInfos(alturaTela, "Banco Bradesco", "3176", "450910-2"),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "ou através do PIX:",
            style: TextStyle(
              fontSize: alturaTela * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "02.723.075/0001-26",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: alturaTela * 0.025,
          ),
        ),
        /*Container(
          width: 200,
          height: 200,
          child: Image.asset(
            'images/exemploQR.png',
            fit: BoxFit.scaleDown,
          ),
        ),*/
        const SizedBox(height: 50),
      ],
    );
  }
}

Widget _bancoInfos(
  double alturaTela,
  String banco,
  String agencia,
  String conta,
) {
  return Column(children: [
    Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        banco,
        style: TextStyle(
          fontSize: alturaTela * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        text: TextSpan(
          text: "Agência: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: alturaTela * 0.025,
          ),
          children: [
            TextSpan(
              text: agencia,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: alturaTela * 0.025,
              ),
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 10),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        text: TextSpan(
          text: "Conta: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: alturaTela * 0.025,
          ),
          children: [
            TextSpan(
              text: conta,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: alturaTela * 0.025,
              ),
            ),
          ],
        ),
      ),
    ),
  ]);
}
