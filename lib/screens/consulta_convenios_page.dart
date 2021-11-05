import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConsultaConveniosPage extends StatefulWidget {
  @override
  _ConsultaConveniosPageState createState() => _ConsultaConveniosPageState();
}

class _ConsultaConveniosPageState extends State<ConsultaConveniosPage> {
  FormatMoney money = FormatMoney();

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Convênios",
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: Responsive.isDesktop(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                "Convênios contratados",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: alturaTela * 0.035, //25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ConveniosTable(),
            ],
          ),
        ),
      ),
    );
  }
}
