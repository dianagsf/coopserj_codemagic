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
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ConsultaSolicPage extends StatefulWidget {
  final int matricula;

  const ConsultaSolicPage({
    Key key,
    @required this.matricula,
  }) : super(key: key);

  @override
  _ConsultaSolicPageState createState() => _ConsultaSolicPageState();
}

class _ConsultaSolicPageState extends State<ConsultaSolicPage> {
  SolicitacoesController solicitacoesController =
      Get.put(SolicitacoesController());

  ControleAnexosController controleAnexosController =
      Get.put(ControleAnexosController());

  ControleAnexosRepository controleAnexosRepository =
      ControleAnexosRepository();

  FormatMoney money = FormatMoney();
  StorageService _storageService = StorageService();

  File _anexoRG;
  File _contracheque;
  File _comprovanteResid;
  final picker = ImagePicker();

  //WEB
  Uint8List _anexoRGWeb;
  Uint8List _contrachequeWeb;
  Uint8List _comprovanteResidWeb;
  FilePickerResult pickedFile;
  ImagePostRepository imagePostRepository = ImagePostRepository();

  String extensaoRG;
  String extensaoContracheque;
  String extensaoComprovResid;

  @override
  void initState() {
    super.initState();
    solicitacoesController.getSolicitacoes(widget.matricula);
  }

  Future getRG() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(
      () {
        if (pickedFile != null) {
          _anexoRG = File(pickedFile.path);
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  Future getContracheque() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(
      () {
        if (pickedFile != null) {
          _contracheque = File(pickedFile.path);
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  Future getComprovanteResid() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 70);

    setState(
      () {
        if (pickedFile != null) {
          _comprovanteResid = File(pickedFile.path);
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  handleDeleteRG() {
    setState(() {
      _anexoRG = null;
    });
  }

  handleDeleteContracheque() {
    setState(() {
      _contracheque = null;
    });
  }

  handleDeleteComprovanteResid() {
    setState(() {
      _comprovanteResid = null;
    });
  }

  uploadDocumentos() {
    SolicitacaoModel solicitacao = solicitacoesController.solicitacoes
        .lastWhere((solic) =>
            solic.situacao != null && solic.situacao.compareTo("L") == 0);

    if (_anexoRG == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o RG.",
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

    if (_contracheque == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o contracheque.",
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

    if (_comprovanteResid == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o comprovante de residência.",
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

    if (_anexoRG != null &&
        _comprovanteResid != null &&
        _contracheque != null) {
      _storageService.uploadImageAtPath(
        _anexoRG.path,
        "RG",
        "simulacaoEmprestimo",
        solicitacao.numero,
      );
      _storageService.uploadImageAtPath(
        _anexoRG.path,
        "contracheque",
        "simulacaoEmprestimo",
        solicitacao.numero,
      );
      _storageService.uploadImageAtPath(
        _anexoRG.path,
        "comprovanteResid",
        "simulacaoEmprestimo",
        solicitacao.numero,
      );

      /// SALVA NA TABELA DE CONTROLE O ENVIO DOS ANEXOS
      /// qual é o número??? verificar!!!!
      controleAnexosRepository.postAnexos({
        "data": DateTime.now().toString().substring(0, 19),
        "matricula": widget.matricula,
        "solic": solicitacao.numero,
      });

      Get.back();
      Get.back();
      Get.snackbar(
        "Os documentos foram enviados com sucesso!",
        "",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    }
  }

  ///////////////////////////////// WEB ///////////////////////

  Future getRGWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _anexoRGWeb = pickedFile.files.first.bytes;
          extensaoRG = pickedFile.files.first.extension.toString();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  Future getContrachequeWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _contrachequeWeb = pickedFile.files.first.bytes;
          extensaoContracheque = pickedFile.files.first.extension.toString();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  Future getComprovanteResidWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _comprovanteResidWeb = pickedFile.files.first.bytes;
          extensaoComprovResid = pickedFile.files.first.extension.toString();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
  }

  handleDeleteRGWeb() {
    setState(() {
      _anexoRGWeb = null;
    });
  }

  handleDeleteContrachequeWeb() {
    setState(() {
      _contrachequeWeb = null;
    });
  }

  handleDeleteComprovanteResidWeb() {
    setState(() {
      _comprovanteResidWeb = null;
    });
  }

  uploadDocumentosWeb() {
    SolicitacaoModel solicitacao = solicitacoesController.solicitacoes
        .lastWhere((solic) =>
            solic.situacao != null && solic.situacao.compareTo("L") == 0);

    if (_anexoRGWeb == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o RG.",
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

    if (_contrachequeWeb == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o contracheque.",
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

    if (_comprovanteResidWeb == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Adicione o comprovante de residência.",
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

    if (_anexoRGWeb != null &&
        _contrachequeWeb != null &&
        _comprovanteResidWeb != null) {
      imagePostRepository.uploadImage(
        _anexoRGWeb,
        solicitacao.numero,
        "RG",
        "simulacaoEmprestimo",
        "emprestimo",
        extensaoRG,
      );
      imagePostRepository.uploadImage(
        _contrachequeWeb,
        solicitacao.numero,
        "contracheque",
        "simulacaoEmprestimo",
        "emprestimo",
        extensaoContracheque,
      );
      imagePostRepository.uploadImage(
        _comprovanteResidWeb,
        solicitacao.numero,
        "comprovanteResid",
        "simulacaoEmprestimo",
        "emprestimo",
        extensaoComprovResid,
      );

      /// SALVA NA TABELA DE CONTROLE O ENVIO DOS ANEXOS
      controleAnexosRepository.postAnexos({
        "data": DateTime.now().toString().substring(0, 19),
        "matricula": widget.matricula,
        "solic": solicitacao.numero,
      });

      // Get.back();
      Get.back();
      Get.snackbar(
        "Os documentos foram enviados com sucesso!",
        "",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Solicitações de empréstimo",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.symmetric(
                vertical: 10, horizontal: alturaTela * 0.05),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Text("Pendentes"),
              Text("Processadas"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: Responsive.isDesktop(context)
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Solicitações Pendentes",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: alturaTela * 0.035, //25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TableSolicPendentes(matricula: widget.matricula),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: Responsive.isDesktop(context)
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Solicitações realizadas",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: alturaTela * 0.035, //25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTableSolic(
                      solicitacoesController,
                      widget.matricula,
                      money,
                    ),
                    const SizedBox(height: 100),
                    GetX<ControleAnexosController>(
                      initState: (state) {
                        controleAnexosController.getControleInfos();
                      },
                      builder: (_) {
                        return buildAnexosContainer(
                          context,
                          _.controleAnexos,
                          solicitacoesController,
                          _anexoRG,
                          _contracheque,
                          _comprovanteResid,
                          Responsive.isDesktop(context) ? getRGWeb : getRG,
                          Responsive.isDesktop(context)
                              ? getContrachequeWeb
                              : getContracheque,
                          Responsive.isDesktop(context)
                              ? getComprovanteResidWeb
                              : getComprovanteResid,
                          Responsive.isDesktop(context)
                              ? handleDeleteRGWeb
                              : handleDeleteRG,
                          Responsive.isDesktop(context)
                              ? handleDeleteContrachequeWeb
                              : handleDeleteContracheque,
                          Responsive.isDesktop(context)
                              ? handleDeleteComprovanteResidWeb
                              : handleDeleteComprovanteResid,
                          Responsive.isDesktop(context)
                              ? uploadDocumentosWeb
                              : uploadDocumentos,
                          _anexoRGWeb,
                          _contrachequeWeb,
                          _comprovanteResidWeb,
                          extensaoRG,
                          extensaoContracheque,
                          extensaoComprovResid,
                        );
                      },
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

Widget _buildTableSolic(
  SolicitacoesController solicitacoesController,
  int matricula,
  FormatMoney money,
) {
  return GetX<SolicitacoesController>(
    /*initState: (state) {
      solicitacoesController.getSolicitacoes(matricula);
    },*/
    builder: (_) {
      return _.solicitacoes.length < 1
          ? Text(
              "Nenhuma solicitação no momento.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'Número',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'Data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'ValorCR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Prestação',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'NP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Informações',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                rows: _.solicitacoes.map((solic) {
                  var data = formatDate(
                      DateTime.parse(solic.data), [dd, '/', mm, '/', yyyy]);
                  var valor = money
                      .formatterMoney(double.parse(solic.valor.toString()));

                  var prestacao = money
                      .formatterMoney(double.parse(solic.prestacao.toString()));

                  var status;
                  var colorRow;

                  switch (solic.situacao) {
                    case "L":
                      {
                        status = "Aguardando\ndocumentos";
                        colorRow = Colors.blue;
                      }
                      break;
                    case "U":
                      {
                        status = "Liberada";
                        colorRow = Colors.green;
                      }
                      break;
                    case "R":
                      {
                        status = "Recusada";
                        colorRow = Colors.red;
                      }
                      break;
                    case "C":
                      {
                        status = "Cancelada";
                        colorRow = Colors.grey[700];
                      }
                      break;
                    default:
                      status = "Recebida";
                      colorRow = Colors.black;
                  }
                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${solic.numero}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$data',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$valor',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$prestacao',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${solic.np}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '$status',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colorRow),
                          ),
                        ),
                      ),
                      solic.motivo != null &&
                              (solic.situacao.compareTo('R') == 0 ||
                                  solic.situacao.compareTo('C') == 0)
                          ? DataCell(
                              Container(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: Text(
                                          'A solicitação foi negada pelo seguinte motivo:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          solic.motivo,
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : DataCell(
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: colorRow),
                                ),
                              ),
                            ),
                    ],
                  );
                }).toList(),
              ),
            );
    },
  );
}

Widget buildAnexosContainer(
  BuildContext context,
  List<ControleAnexoModel> controleAnexos,
  SolicitacoesController solicitacoesController,
  File _anexoRG,
  File _contracheque,
  File _comprovanteResid,
  Function getRG,
  Function getContracheque,
  Function getComprovanteResid,
  Function handleDeleteRG,
  Function handleDeleteContracheque,
  Function handleDeleteComprovanteResid,
  Function uploadDocumentos,
  Uint8List _anexoRGWeb,
  Uint8List _contrachequeWeb,
  Uint8List _comprovanteResidWeb,
  String extensaoRG,
  String extensaoContracheque,
  String extensaoComprovResid,
) {
  List<SolicitacaoModel> solicLiberadas = solicitacoesController.solicitacoes
      .where((sol) => sol.situacao != null && sol.situacao.compareTo('L') == 0)
      .toList();

  bool mostraAnexo = true;

  if (solicLiberadas.length != 0) {
    solicLiberadas.forEach((element) {
      if (controleAnexos.length != 0 &&
          controleAnexos.any((sol) => sol.solic == element.numero))
        mostraAnexo = false;
    });

    if (mostraAnexo) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text(
              "Anexos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Envie os documentos listados abaixo para concluir a solicitação aprovada.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: Icon(
                    Icons.person_add_alt_1,
                    color: Colors.purpleAccent,
                    size: 30,
                  ),
                  title: Text(
                    "Anexar RG",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: _anexoRG != null || _anexoRGWeb != null
                      ? _showImage(
                          context,
                          _anexoRG,
                          _anexoRGWeb,
                          'rg',
                          extensaoRG,
                          handleDeleteRG,
                        )
                      : SizedBox.shrink(),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: getRG,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: Icon(
                    Icons.playlist_add,
                    color: Colors.orangeAccent,
                    size: 30,
                  ),
                  title: Text(
                    "Anexar contracheque",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: _contracheque != null || _contrachequeWeb != null
                      ? _showImage(
                          context,
                          _contracheque,
                          _contrachequeWeb,
                          'contracheque',
                          extensaoContracheque,
                          handleDeleteContracheque,
                        )
                      : SizedBox.shrink(),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: getContracheque,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  leading: Icon(
                    Icons.add_business_sharp,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  title: Text(
                    "Anexar comprovante de residência",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle:
                      _comprovanteResid != null || _comprovanteResidWeb != null
                          ? _showImage(
                              context,
                              _comprovanteResid,
                              _comprovanteResidWeb,
                              'comprovanteResid',
                              extensaoComprovResid,
                              handleDeleteComprovanteResid,
                            )
                          : SizedBox.shrink(),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add,
                    ),
                    onPressed: getComprovanteResid,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: 100,
                child: ElevatedButton(
                  onPressed: uploadDocumentos,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.blue[600]),
                    ),
                  ),
                  child: Text(
                    "Enviar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
  return SizedBox.shrink();
}

Widget _showImage(
  BuildContext context,
  File image,
  Uint8List imageWeb,
  String label,
  String extensao,
  Function handleDeleteImage,
) {
  return image != null || imageWeb != null
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                constraints: BoxConstraints(maxHeight: 60.0, maxWidth: 50.0),
                child: Responsive.isDesktop(context)
                    ? SizedBox.shrink()
                    : Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 4.0),
              Expanded(
                child: Responsive.isDesktop(context)
                    ? Text("$label.$extensao")
                    : Text("$label.jpg"),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ),
                onPressed: handleDeleteImage,
              ),
            ],
          ),
        )
      : SizedBox.shrink();
}
