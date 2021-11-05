import 'package:flutter/material.dart';

class SolicitarButton extends StatelessWidget {
  final Function handleSolicitar;

  const SolicitarButton({
    Key key,
    @required this.handleSolicitar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      height: alturaTela * 0.055, //45,
      width: MediaQuery.of(context).size.width * 0.73,

      child: ElevatedButton(
        onPressed: handleSolicitar,
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "SOLICITAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: alturaTela * 0.025,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
