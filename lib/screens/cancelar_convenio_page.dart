import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CancelarConvenioPage extends StatefulWidget {
  final int matricula;
  final String senha;

  const CancelarConvenioPage({
    Key key,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);
  @override
  _CancelarConvenioPageState createState() => _CancelarConvenioPageState();
}

class _CancelarConvenioPageState extends State<CancelarConvenioPage> {
  int selectedRadioTile;
  ConveniosController conveniosController = Get.find();
  FormatMoney money = FormatMoney();

  MaskedTextController senhaController = MaskedTextController(mask: "000000");

  CancelamentoConvenioRepository cancelamentoConvenioRepository =
      CancelamentoConvenioRepository();

  int protocolo;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  handleCancelamento(ConvenioModel convenio) {
    return Get.dialog(
      AlertDialog(
        title: Text("Confirme sua senha"),
        content: TextField(
          controller: senhaController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (senhaController.text.compareTo(widget.senha) == 0) {
                  cancelamentoConvenioRepository.saveSolic({
                    "numero": protocolo,
                    "matricula": widget.matricula,
                    "data": DateTime.now().toString().substring(0, 23),
                    "convenio": convenio.numero,
                  });

                  if (!Responsive.isDesktop(context)) Get.back();
                  Get.back();
                  Get.back();
                  Get.back();

                  Get.snackbar(
                    "Aguarde!",
                    "Sua solicitação será analisada pela Diretoria.",
                    colorText: Colors.white,
                    backgroundColor: Colors.green[700],
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.back();

                  senhaController.text = "";

                  Get.snackbar(
                    "Senha incorreta!",
                    "Tente novamente.",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    padding: EdgeInsets.all(30),
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 4),
                  );
                }
              },
              child: Text("CONFIRMAR")),
        ],
      ),
    );
  }

  /*handleCancelamento(ConvenioModel convenio) {
    print("ENTREI!!!");
    var postOK;

    postOK = cancelamentoConvenioRepository.saveSolic({
      "numero": protocolo,
      "matricula": widget.matricula,
      "data": DateTime.now().toString().substring(0, 23),
      "convenio": convenio.numero,
    });

    if (postOK != null) {
      Get.back();
      Get.back();
      Get.back();

      Get.snackbar(
        "Aguarde!",
        "Sua solicitação será analisada pela Diretoria.",
        colorText: Colors.white,
        backgroundColor: Colors.green[700],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }*/

  setSelectedRadioTile(int val, ConvenioModel convenio) {
    setState(() {
      selectedRadioTile = val;
    });
    _buildModalConvenio(
      context,
      selectedRadioTile,
      convenio,
      money,
      handleCancelamento,
    );
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cancelamento de convênio",
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Convênios contratados",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: alturaTela * 0.035, //25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildListConvenios(
                selectedRadioTile,
                setSelectedRadioTile,
                conveniosController,
                money,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _buildModalConvenio(
  BuildContext context,
  int selectedListTile,
  ConvenioModel convenio,
  FormatMoney money,
  Function handleCancelamento,
) {
  showModalBottomSheet(
    isDismissible: false,
    //isScrollControlled: true, tela cheia
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Detalhes sobre o convênio",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Icon(
                          Icons.file_copy_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                      title: Text(
                        convenio.numero != null ? "${convenio.numero}" : '-',
                      ),
                      subtitle: Text("Número do Convênio"),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Icon(
                          MdiIcons.briefcaseEditOutline,
                          color: Colors.grey[400],
                        ),
                      ),
                      title: Text(
                        convenio.nome != null ? "${convenio.nome}" : '-',
                      ),
                      subtitle: Text("Nome do Convênio"),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Icon(
                          Icons.attach_money,
                          color: Colors.grey[400],
                        ),
                      ),
                      title: Text(
                        convenio.valor != null
                            ? "${money.formatterMoney(double.parse(convenio.valor.toString()))}"
                            : '-',
                      ),
                      subtitle: Text("Valor Mensal"),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.1,
                    ),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey[400],
                          ),
                        ),
                        child: Icon(
                          Icons.money_off,
                          color: Colors.grey[400],
                        ),
                      ),
                      title: Text(
                        convenio.devedor != null
                            ? money.formatterMoney(
                                double.parse(convenio.devedor.toString()))
                            : '-',
                      ),
                      subtitle: Text("Saldo Devedor"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                onPressed: () {
                  handleCancelamento(convenio);
                }, // handleCancelamento(convenio),
                child: Text(
                  "Solicitar Cancelamento",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildListConvenios(
  int selectedRadioTile,
  Function setSelectedRadioTile,
  ConveniosController conveniosController,
  FormatMoney money,
) {
  return GetX<ConveniosController>(
    builder: (_) {
      return _.convenios.where((conv) => !conv.nome.contains("RENEG")).length <
              1
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Nenhum convênio no momento.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _.convenios
                  .where((conv) => !conv.nome.contains("RENEG"))
                  .map(
                    (conv) => RadioListTile(
                      value: conv.numero,
                      groupValue: selectedRadioTile,
                      title: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          conv.nome != null ? conv.nome : '-',
                        ),
                      ),
                      subtitle: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Valor Mensal: ${conv.valor != null ? money.formatterMoney(double.parse(conv.valor.toString())) : '-'}",
                        ),
                      ),
                      onChanged: (val) {
                        setSelectedRadioTile(val, conv);
                      },
                      activeColor: Colors.red,
                      secondary: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Data início: "),
                          Text(
                            "${conv.dataInicio != null ? formatDate(DateTime.parse(conv.dataInicio), [
                                dd,
                                '/',
                                mm,
                                '/',
                                yyyy
                              ]) : '-'}",
                          )
                        ],
                      ),
                      selected: selectedRadioTile == conv.numero ? true : false,
                    ),
                  )
                  .toList(),
            );
    },
  );
}
