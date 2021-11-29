import 'dart:io';
import 'dart:typed_data';

import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/utils/storage_service.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class QuitacaoPage extends StatefulWidget {
  final int matricula;
  final String senha;

  const QuitacaoPage({
    Key key,
    @required this.matricula,
    @required this.senha,
  }) : super(key: key);

  @override
  _QuitacaoPageState createState() => _QuitacaoPageState();
}

class _QuitacaoPageState extends State<QuitacaoPage> {
  MaskedTextController senhaController = MaskedTextController(mask: "000000");
  PropostaController propostaController = Get.find();
  QuitacaoRepository quitacaoRepository = QuitacaoRepository();
  final PedidoQuitacaoController pedidoQuitacaoController = Get.find();
  FormatMoney money = FormatMoney();
  double total = 0.0;
  double saldoDevedor = 0.0;
  int protocolo;

  File _image;
  final picker = ImagePicker();

  //WEB
  Uint8List _imageWeb;
  FilePickerResult pickedFile;
  ImagePostRepository imagePostRepository = ImagePostRepository();

  List<PropostaModel> selectedEmp = [];
  StorageService _storageService = StorageService();

  _uploadComprovante() {
    _storageService.uploadComprovante(
      _image.path,
      widget.matricula,
      "comprovanteQuitacao",
      protocolo: protocolo,
    );
  }

  _uploadComprovanteWeb() {
    String extensaoArq = pickedFile.files.first.extension.toString();

    if (_imageWeb != null) {
      imagePostRepository.uploadImage(
        _imageWeb,
        protocolo,
        "comprovante",
        "comprovanteQuitacao",
        "quitacao",
        extensaoArq,
      );
    }
  }

  handleChangeCheckBox(bool value, PropostaModel prop) async {
    double valor = double.parse(prop.valorQuitacao.toString());
    List<int> pedidosEmAnalise = [];
    pedidoQuitacaoController.pedidosQuitacao.forEach((pedidoEmAnalise) {
      pedidosEmAnalise.add(pedidoEmAnalise.emprestimo);
    });

    if (pedidosEmAnalise.contains(prop.numero)) {
      Get.defaultDialog(
        title: 'Atenção!',
        titleStyle: TextStyle(fontSize: 18),
        content: Text(
          'Você já realizou o pedido de quitação do empréstimo ${prop.numero} e sua solicitação já está sendo analisada.',
          style: TextStyle(fontSize: 18),
        ),
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'OK',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else {
      setState(() {
        if (value) {
          selectedEmp.add(prop);
          total = (total + valor).abs();
        } else {
          selectedEmp.remove(prop);
          total = (total - valor).abs();
        }
      });
    }
  }

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  handleDeleteImage() {
    setState(() {
      _image = null;
    });
  }

  Future getImageWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _imageWeb = pickedFile.files.first.bytes;
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  handleDeleteImageWeb() {
    setState(() {
      _imageWeb = null;
    });
  }

  handlePedidoQuitacao() {
    if (selectedEmp.length == 0) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Selecione os empréstimos que deseja quitar.",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      );
    }

    if (Responsive.isDesktop(context) || kIsWeb) {
      if (_imageWeb == null) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Adicione o comprovante.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      }
    } else {
      if (_image == null) {
        Get.dialog(
          AlertDialog(
            title: Text("Atenção!"),
            content: Text(
              "Adicione o comprovante.",
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        );
      }
    }

    //SALVA SOLICITAÇÃO
    if (selectedEmp.length != 0 && (_image != null || _imageWeb != null)) {
      Get.dialog(
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
                    for (int i = 0; i < selectedEmp.length; i++) {
                      quitacaoRepository.savePedidoQuitacao({
                        "numero": protocolo,
                        "data": DateTime.now().toString().substring(0, 19),
                        "valor": total,
                        "matricula": widget.matricula,
                        "emprestimo": selectedEmp[i].numero,
                      });
                    }

                    Responsive.isDesktop(context) || kIsWeb
                        ? _uploadComprovanteWeb()
                        : _uploadComprovante();

                    Get.back();
                    Get.back();
                    // Get.back();
                    Get.snackbar(
                      "Sua solicitação foi enviada com sucesso!",
                      "Ela será analisada e processada em breve.",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      padding: EdgeInsets.all(30),
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 4),
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
  }

  @override
  void initState() {
    super.initState();
    propostaController.propostas.forEach((prop) {
      saldoDevedor = saldoDevedor + double.parse(prop.valorQuitacao.toString());
    });

    var data = DateTime.now().toString().substring(0, 19);

    var codigo = widget.matricula.toString() + " " + data;
    protocolo = codigo.hashCode;
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quitação de empréstimos",
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Text(
                "Empréstimos em Vigor",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: alturaTela * 0.035, //24.0 : 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTable(
              money,
              selectedEmp,
              handleChangeCheckBox,
            ),
            const SizedBox(height: 70),
            /*buildCardInfo(
              Icons.attach_money,
              "Crédito de Associado",
              "R\$ 1.000,00",
              Colors.blue,
              alturaTela,
            ),*/
            buildCardInfo(
              Icons.money_off,
              "Saldo Devedor",
              money.formatterMoney(saldoDevedor),
              Colors.red[400],
              alturaTela,
            ),
            Padding(
              padding: Responsive.isDesktop(context)
                  ? EdgeInsets.symmetric(horizontal: alturaTela * 0.5)
                  : const EdgeInsets.all(20.0),
              child: Card(
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total a pagar',
                        style: TextStyle(
                          fontSize: alturaTela * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        money.formatterMoney(total),
                        style: TextStyle(
                          fontSize: alturaTela * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            propostaController.propostas.length != 0
                ? Column(
                    children: [
                      InfosDevedor(total: money.formatterMoney(total)),
                      const SizedBox(height: 30),
                      Container(
                        margin: Responsive.isDesktop(context)
                            ? EdgeInsets.only(left: alturaTela * 0.3)
                            : const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: buildAnexoButton(
                            context, getImage, getImageWeb, alturaTela),
                      ),
                      _image != null || _imageWeb != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Responsive.isDesktop(context)
                                      ? alturaTela * 0.3
                                      : 20,
                                  vertical: 15),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    constraints: BoxConstraints(
                                        maxHeight: 60.0, maxWidth: 50.0),
                                    child:
                                        Responsive.isDesktop(context) || kIsWeb
                                            ? SizedBox.shrink()
                                            : Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  Responsive.isDesktop(context) || kIsWeb
                                      ? Expanded(
                                          child: Text(pickedFile != null
                                              ? '${pickedFile.files.first.name}'
                                              : 'Erro ao selecionar o documento. Tente novamente.'))
                                      : Expanded(
                                          child: Text("comprovante.jpg"),
                                        ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.red,
                                    ),
                                    onPressed:
                                        Responsive.isDesktop(context) || kIsWeb
                                            ? handleDeleteImageWeb
                                            : handleDeleteImage,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Obs.: Caso já tenha realizado o pagamento, mande uma foto do comprovante.",
                          style: TextStyle(
                            fontSize: alturaTela * 0.023,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        height: alturaTela * 0.055, //45,
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width * 0.2
                            : MediaQuery.of(context).size.width * 0.73,
                        child: ElevatedButton(
                          onPressed: handlePedidoQuitacao,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: Colors.blue),
                            ),
                          ),
                          child: Text(
                            "Solicitar Quitação",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: alturaTela * 0.025,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

Widget buildCardInfo(
  IconData icon,
  String text,
  String value,
  Color color,
  double alturaTela,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: alturaTela * 0.055, //45.0,
          width: alturaTela * 0.055, //45.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(60.0),
            ),
          ),
          child: Icon(
            icon,
            size: alturaTela * 0.03, //25.0,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: alturaTela * 0.025,
          ),
        ),
        FittedBox(
          child: Text(
            value,
            style: TextStyle(
              fontSize: alturaTela * 0.025,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildTable(
  FormatMoney money,
  List<PropostaModel> selectedEmp,
  Function handleChangeCheckBox,
) {
  return GetX<PropostaController>(builder: (_) {
    return _.propostas.length < 1
        ? Text(
            "Nenhum empréstimo ativo no momento.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: true,
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
                  label: Text(
                    "Valor p/ quitação",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    padding: const EdgeInsets.only(left: 20),
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
                    "Valor Liberado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Prestação",
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
              ],
              rows: _.propostas.map((prop) {
                var data = prop.data != null
                    ? formatDate(
                        DateTime.parse(prop.data),
                        [dd, '/', mm, '/', yyyy],
                      )
                    : '-';
                var valor = prop.valorcr != null
                    ? money
                        .formatterMoney(double.parse(prop.valorcr.toString()))
                    : '-';
                var prestacao = prop.prestacao != null
                    ? money
                        .formatterMoney(double.parse(prop.prestacao.toString()))
                    : '-';

                var valQuitacao = prop.valor != null
                    ? money.formatterMoney(
                        double.parse((prop.valorQuitacao.toString())))
                    : '-';
                return DataRow(
                  selected: selectedEmp.contains(prop),
                  onSelectChanged: (value) {
                    handleChangeCheckBox(value, prop);
                  },
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
                          valQuitacao,
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
                  ],
                );
              }).toList(),
            ),
          );
  });
}

Widget buildAnexoButton(
  BuildContext context,
  Function getImage,
  Function getImageWeb,
  double alturaTela,
) {
  return ElevatedButton.icon(
    onPressed: Responsive.isDesktop(context) || kIsWeb ? getImageWeb : getImage,
    style: ElevatedButton.styleFrom(
      primary: Colors.blue[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide(color: Colors.blue[600]),
      ),
    ),
    icon: Icon(
      Icons.note_add,
      size: alturaTela * 0.03, //20.0,
      color: Colors.white,
    ),
    label: Text(
      "Anexar comprovante",
      style: TextStyle(
        color: Colors.white,
        fontSize: alturaTela * 0.025,
      ),
    ),
  );
}
