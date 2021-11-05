import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class TableEmprestimos extends StatelessWidget {
  final List<PropostaModel> propostas;

  const TableEmprestimos({Key key, this.propostas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormatMoney money = FormatMoney();

    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Número",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Container(
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
          label: Text(
            "Valor Contratado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Valor Liberado",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Prestração",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "NPC",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "NPF",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Valor p/ Quitação",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      rows: propostas.map((prop) {
        var data =
            formatDate(DateTime.parse(prop.data), [dd, '/', mm, '/', yyyy]);
        var valorCR = prop.valorcr != null
            ? money.formatterMoney(double.parse(prop.valorcr.toString()))
            : '-';
        var prestacao = prop.prestacao != null
            ? money.formatterMoney(double.parse(prop.prestacao.toString()))
            : '-';
        var valor = prop.valor != null
            ? money.formatterMoney(double.parse(prop.valor.toString()))
            : '-';

        var valQuitacao = prop.valorQuitacao != null
            ? money.formatterMoney(double.parse(prop.valorQuitacao.toString()))
            : '-';

        return DataRow(
          cells: [
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  prop.numero != null ? "${prop.numero}" : '-',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  data,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  valor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  valorCR,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  prestacao,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  prop.npc != null ? "${prop.npc}" : '-',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  prop.npf != null ? "${prop.npf}" : '-',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                child: Text(
                  valQuitacao,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
    /*Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
      children: [
        _buildTableRow(
            "Número* Data* Valor Contratado* Valor Liberado* Prestação* NPC* NPF*",
            true),
        ...propostas.map<TableRow>((prop) {
          var data =
              formatDate(DateTime.parse(prop.data), [dd, '/', mm, '/', yyyy]);
          var valorCR = prop.valorcr != null
              ? money.formatterMoney(double.parse(prop.valorcr.toString()))
              : '-';
          var prestacao = prop.prestacao != null
              ? money.formatterMoney(double.parse(prop.prestacao.toString()))
              : '-';
          var valor = prop.valor != null
              ? money.formatterMoney(double.parse(prop.valor.toString()))
              : '-';
          return _buildTableRow(
              "${prop.numero}* $data* $valor* $valorCR*  $prestacao* ${prop.npc}* ${prop.npf}*",
              false);
        }).toList(),
      ],
    );
  }
}

_buildTableRow(String values, bool header) {
  return TableRow(
    children: values.split('*').map((value) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: header ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }).toList(),
  );
}*/
