import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConveniosDetalhes extends StatefulWidget {
  final ConvenioModel convenio;

  const ConveniosDetalhes({
    Key key,
    this.convenio,
  }) : super(key: key);

  @override
  _ConveniosDetalhesState createState() => _ConveniosDetalhesState();
}

class _ConveniosDetalhesState extends State<ConveniosDetalhes> {
  ConvenioDetalhesController convenioDetalhesController =
      Get.put(ConvenioDetalhesController());
  FormatMoney money = FormatMoney();

  int _currentIndex = 0;

  onTapNavBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Detalhes do Convênio",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: Responsive.isDesktop(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Convênio #${widget.convenio.numero}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: Responsive.isDesktop(context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                    child: Icon(
                      Icons.work_outline,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Nome: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: widget.convenio.nome != null
                              ? widget.convenio.nome.startsWith("R")
                                  ? "Renegociação"
                                  : '${widget.convenio.nome}'
                              : "-",
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              /* InfosValue(
                color: Colors.blue[700],
                icon: Icons.work_outline,
                text: 'Nome: ',
                value: widget.convenio.eMPRESA.startsWith("R")
                    ? "Renegociação"
                    : '${widget.convenio.eMPRESA}',
              ),*/
              const SizedBox(height: 30),
              _buildTableDetalhes(
                convenioDetalhesController,
                widget.convenio.numero,
                money,
                _currentIndex,
              ),
              /* InfosValue(
                color: Colors.blue[700],
                icon: Icons.date_range,
                text: 'Data do Contrato: ',
                value: '$dataInicio',
              ),
              const SizedBox(height: 20),
              InfosValue(
                color: Colors.blue[700],
                icon: Icons.work_outline,
                text: 'Nome: ',
                value: '${widget.convenio.eMPRESA}',
              ),
              const SizedBox(height: 20),
              InfosValue(
                color: Colors.blue[700],
                icon: Icons.attach_money,
                text: 'Valor Mensal: ',
                value: valor,
              ),
              const SizedBox(height: 20),
              InfosValue(
                color: Colors.blue[700],
                icon: Icons.money_off,
                text: 'Saldo Devedor: ',
                value: 'R\$ 1.000,00',
              ),*/
              // _buildButtonCancelamento(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTapNavBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.creditCard),
            label: 'A PAGAR',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.cashCheck),
            label: 'PAGAS',
          ),
        ],
      ),
    );
  }
}

Widget _buildTableDetalhes(
  ConvenioDetalhesController convenioDetalhesController,
  int contrato,
  FormatMoney money,
  int index,
) {
  return GetX<ConvenioDetalhesController>(
    initState: (state) {
      convenioDetalhesController.getConveniosDetalhes(contrato);
    },
    builder: (_) {
      return _.conveniosDetalhes.length < 1
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: index == 0
                  ? _buildTable(
                      _.conveniosDetalhes
                          .where((conv) => conv.dataPag == null)
                          .toList(),
                      money,
                    )
                  : _buildTable(
                      _.conveniosDetalhes
                          .where((conv) => conv.dataPag != null)
                          .toList(),
                      money,
                    ),
            );
    },
  );
}

Widget _buildTable(
    List<ConvenioDetalhesModel> conveniosDetalhes, FormatMoney money) {
  return conveniosDetalhes.length > 0
      ? DataTable(
          columns: [
            DataColumn(
              label: Text(
                "Parcela",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              numeric: true,
            ),
            DataColumn(
              label: Text(
                "Vencimento",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Valor",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Situação",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                "Data Pag.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          rows: conveniosDetalhes.map(
            (conv) {
              var dataVencimento = conv.vencimento != null
                  ? formatDate(
                      DateTime.parse(conv.vencimento),
                      [dd, '/', mm, '/', yyyy],
                    )
                  : '-';

              var dataPag = conv.dataPag != null
                  ? formatDate(
                      DateTime.parse(conv.dataPag),
                      [dd, '/', mm, '/', yyyy],
                    )
                  : '-';

              var valorMensal = conv.valor != null
                  ? money.formatterMoney(double.parse(conv.valor.toString()))
                  : '-';
              return DataRow(
                cells: [
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        conv.parcela != null ? "${conv.parcela}" : '-',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$dataVencimento",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$valorMensal",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        conv.situacao != null ? "${conv.situacao}" : '-',
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$dataPag",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        )
      : Container(
          child: Text(
            'Nenhuma parcela a pagar.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
}
