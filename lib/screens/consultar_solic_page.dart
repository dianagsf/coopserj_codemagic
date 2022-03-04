import 'dart:io';
import 'dart:typed_data';

import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/models/models.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/utils/format_money.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; // verifica se tá na WEB

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

  bool anexoGaleria = false;

  /* File _anexoRG;
  File _contracheque;
  File _comprovanteResid;*/
  final picker = ImagePicker();

  //WEB
  Uint8List _anexoRGFrente;
  Uint8List _anexoRGVerso;
  Uint8List _contracheque;
  Uint8List _comprovanteResid;
  FilePickerResult pickedFile;
  ImagePostRepository imagePostRepository = ImagePostRepository();

  String extensaoRGFrente;
  String extensaoRGVerso;
  String extensaoContracheque;
  String extensaoComprovResid;

  @override
  void initState() {
    super.initState();
    solicitacoesController.getSolicitacoes(widget.matricula);
  }

  _escolherGaleriaFoto(Function getCamera, Function getGaleria) {
    Get.dialog(
      AlertDialog(
        title: Text("Escolha uma forma de enviar o documento:"),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        anexoGaleria = true;
                        getGaleria();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.pink),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          MdiIcons.imageMultipleOutline,
                          size: 25,
                        ),
                        Text(
                          "Galeria",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        anexoGaleria = false;
                        getCamera();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          MdiIcons.camera,
                          size: 25,
                        ),
                        Text(
                          "Câmera",
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future getRG() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    setState(
      () {
        if (pickedFile != null) {
          if (_anexoRGFrente != null)
            _anexoRGVerso = File(pickedFile.path).readAsBytesSync();
          else
            _anexoRGFrente = File(pickedFile.path).readAsBytesSync();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    Get.back();
  }

  Future getContracheque() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    setState(
      () {
        if (pickedFile != null) {
          _contracheque = File(pickedFile.path).readAsBytesSync();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    Get.back();
  }

  Future getComprovanteResid() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    setState(
      () {
        if (pickedFile != null) {
          _comprovanteResid = File(pickedFile.path).readAsBytesSync();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    Get.back();
  }

  handleDeleteRGFrente() {
    setState(() {
      _anexoRGFrente = null;
    });
  }

  handleDeleteRGVerso() {
    setState(() {
      _anexoRGVerso = null;
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

  /*uploadDocumentos() async {
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
      await imagePostRepository.uploadImage(
        _anexoRG.readAsBytesSync(),
        solicitacao.numero,
        "RG",
        "simulacaoEmprestimo",
        extensaoRG,
      );
      await imagePostRepository.uploadImage(
        _contracheque.readAsBytesSync(),
        solicitacao.numero,
        "contracheque",
        "simulacaoEmprestimo",
        extensaoContracheque,
      );
      await imagePostRepository.uploadImage(
        _comprovanteResid.readAsBytesSync(),
        solicitacao.numero,
        "comprovanteResid",
        "simulacaoEmprestimo",
        extensaoComprovResid,
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
  }*/

  ///////////////////////////////// WEB ///////////////////////

  Future getRGWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          if (_anexoRGFrente != null) {
            _anexoRGVerso = kIsWeb
                ? pickedFile.files.single.bytes
                : File(pickedFile.files.single.path).readAsBytesSync();
            extensaoRGVerso = pickedFile.files.first.extension.toString();
          } else {
            _anexoRGFrente = kIsWeb
                ? pickedFile.files.single.bytes
                : File(pickedFile.files.single.path).readAsBytesSync();
            extensaoRGFrente = pickedFile.files.first.extension.toString();
          }
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );

    if (!kIsWeb) Get.back();
  }

  Future getContrachequeWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _contracheque = kIsWeb
              ? pickedFile.files.single.bytes
              : File(pickedFile.files.single.path).readAsBytesSync();
          extensaoContracheque = pickedFile.files.first.extension.toString();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
    if (!kIsWeb) Get.back();
  }

  Future getComprovanteResidWeb() async {
    pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    setState(
      () {
        if (pickedFile != null) {
          _comprovanteResid = kIsWeb
              ? pickedFile.files.single.bytes
              : File(pickedFile.files.single.path).readAsBytesSync();
          extensaoComprovResid = pickedFile.files.first.extension.toString();
        } else {
          print('Nenhuma imagem selecionada.');
        }
      },
    );
    if (!kIsWeb) Get.back();
  }

  /* handleDeleteRGWeb() {
    setState(() {
      _anexoRGWeb = null;
      numAnexos -= 1;
    });
  }

  handleDeleteContrachequeWeb() {
    setState(() {
      _contrachequeWeb = null;
      numAnexos -= 1;
    });
  }

  handleDeleteComprovanteResidWeb() {
    setState(() {
      _comprovanteResidWeb = null;
      numAnexos -= 1;
    });
  }*/

  uploadDocumentos() {
    SolicitacaoModel solicitacao = solicitacoesController.solicitacoes
        .lastWhere((solic) =>
            solic.situacao != null && solic.situacao.compareTo("L") == 0);

    if (_anexoRGFrente == null &&
        _anexoRGVerso == null &&
        _contracheque == null &&
        _comprovanteResid == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Atenção!"),
          content: Text(
            "Você deve enviar os anexos pedidos para concluir a solicitação.",
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
    } else {
      if (_anexoRGFrente != null) {
        imagePostRepository.uploadImage(
          _anexoRGFrente,
          solicitacao.numero,
          "RG",
          "simulacaoEmprestimo",
          extensaoRGFrente != null ? extensaoRGFrente : 'jpg',
        );

        //SALVA RG
        controleAnexosRepository.postAnexos({
          "data": DateTime.now().toString().substring(0, 19),
          "matricula": widget.matricula,
          "solic": solicitacao.numero,
          "tipo": "RG",
        });
      }

      if (_anexoRGVerso != null) {
        imagePostRepository.uploadImage(
          _anexoRGVerso,
          solicitacao.numero,
          "RG",
          "simulacaoEmprestimo",
          extensaoRGVerso != null ? extensaoRGVerso : 'jpg',
        );
      }

      if (_contracheque != null) {
        imagePostRepository.uploadImage(
          _contracheque,
          solicitacao.numero,
          "contracheque",
          "simulacaoEmprestimo",
          extensaoContracheque != null ? extensaoContracheque : 'jpg',
        );

        //SALVA Contracheque
        controleAnexosRepository.postAnexos({
          "data": DateTime.now().toString().substring(0, 19),
          "matricula": widget.matricula,
          "solic": solicitacao.numero,
          "tipo": "ctrcheque",
        });
      }

      if (_comprovanteResid != null) {
        imagePostRepository.uploadImage(
          _comprovanteResid,
          solicitacao.numero,
          "comprovanteResid",
          "simulacaoEmprestimo",
          extensaoComprovResid != null ? extensaoComprovResid : 'jpg',
        );

        //SALVA Comprovante de residencia
        controleAnexosRepository.postAnexos({
          "data": DateTime.now().toString().substring(0, 19),
          "matricula": widget.matricula,
          "solic": solicitacao.numero,
          "tipo": "compResid",
        });
      }

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

    /*if (_anexoRGFrente == null && _anexoRGVerso == null) {
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
    }*/
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
                          getRG,
                          getContracheque,
                          getComprovanteResid,
                          getRGWeb,
                          getContrachequeWeb,
                          getComprovanteResidWeb,
                          handleDeleteRGFrente,
                          handleDeleteRGVerso,
                          handleDeleteContracheque,
                          handleDeleteComprovanteResid,
                          uploadDocumentos,
                          _anexoRGFrente,
                          _anexoRGVerso,
                          _contracheque,
                          _comprovanteResid,
                          extensaoRGFrente,
                          extensaoRGVerso,
                          extensaoContracheque,
                          extensaoComprovResid,
                          _escolherGaleriaFoto,
                          anexoGaleria,
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
                    label: Text(
                      'Modalidade',
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
                            '${solic.contratos != null && solic.contratos.toString().isNotEmpty ? 'Refin' : 'Solic Emp'}',
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
  Function getRG,
  Function getContracheque,
  Function getComprovanteResid,
  Function getRGWeb,
  Function getContrachequeWeb,
  Function getComprovanteResidWeb,
  Function handleDeleteRGFrente,
  Function handleDeleteRGVerso,
  Function handleDeleteContracheque,
  Function handleDeleteComprovanteResid,
  Function uploadDocumentos,
  Uint8List _anexoRGFrente,
  Uint8List _anexoRGVerso,
  Uint8List _contracheque,
  Uint8List _comprovanteResid,
  String extensaoRGFrente,
  String extensaoRGVerso,
  String extensaoContracheque,
  String extensaoComprovResid,
  Function escolherGaleriaFoto,
  bool anexoGaleria,
) {
  List<SolicitacaoModel> solicLiberadas = solicitacoesController.solicitacoes
      .where((sol) => sol.situacao != null && sol.situacao.compareTo('L') == 0)
      .toList();

  bool mostraAnexoRG = true;
  bool mostraAnexoContraCheque = true;
  bool mostraAnexoCompResid = true;

  if (solicLiberadas.length != 0) {
    solicLiberadas.forEach((element) {
      if (controleAnexos.length != 0) {
        if (controleAnexos.any((sol) =>
            sol.solic == element.numero &&
            (sol.tipo != null && sol.tipo.compareTo("RG") == 0)))
          mostraAnexoRG = false;

        if (controleAnexos.any((sol) =>
            sol.solic == element.numero &&
            (sol.tipo != null && sol.tipo.compareTo("ctrcheque") == 0)))
          mostraAnexoContraCheque = false;

        if (controleAnexos.any((sol) =>
            sol.solic == element.numero &&
            (sol.tipo != null && sol.tipo.compareTo("compResid") == 0)))
          mostraAnexoCompResid = false;
      }
    });

    if (mostraAnexoRG || mostraAnexoContraCheque || mostraAnexoCompResid) {
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
            if (mostraAnexoRG)
              _buildCardAnexos(
                _anexoRGFrente,
                _anexoRGVerso,
                context,
                extensaoRGFrente,
                extensaoRGVerso,
                handleDeleteRGFrente,
                handleDeleteRGVerso,
                getRG,
                getRGWeb,
                'RG',
                escolherGaleriaFoto,
              ),
            const SizedBox(height: 10),
            if (mostraAnexoContraCheque)
              _buildCardAnexos(
                _contracheque,
                null,
                context,
                extensaoContracheque,
                null,
                handleDeleteContracheque,
                null,
                getContracheque,
                getContrachequeWeb,
                'contracheque',
                escolherGaleriaFoto,
              ),
            const SizedBox(height: 10),
            if (mostraAnexoCompResid)
              _buildCardAnexos(
                _comprovanteResid,
                null,
                context,
                extensaoComprovResid,
                null,
                handleDeleteComprovanteResid,
                null,
                getComprovanteResid,
                getComprovanteResidWeb,
                'comprovanteResid',
                escolherGaleriaFoto,
              ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    uploadDocumentos();
                  },
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

Widget _buildCardAnexos(
  Uint8List _anexo,
  Uint8List _anexoRGVerso,
  BuildContext context,
  String extensao,
  String extensaoRGVerso,
  Function handleDelete,
  Function handleDeleteRGVerso,
  Function getAnexo,
  Function getAnexoWeb,
  String nomeArq,
  Function escolherGaleriaFoto,
) {
  return Container(
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
          Icons.description_outlined,
          color: Colors.blue,
          size: 30,
        ),
        title: Text(
          "Anexar $nomeArq ${nomeArq.compareTo("RG") == 0 ? "(frente e verso)" : ""}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _anexo != null
            ? _anexoRGVerso != null
                ? Column(
                    children: [
                      _showImage(
                        context,
                        _anexo,
                        nomeArq,
                        extensao,
                        handleDelete,
                      ),
                      _showImage(
                        context,
                        _anexoRGVerso,
                        nomeArq,
                        extensaoRGVerso,
                        handleDeleteRGVerso,
                      )
                    ],
                  )
                : _showImage(
                    context,
                    _anexo,
                    nomeArq,
                    extensao,
                    handleDelete,
                  )
            : SizedBox.shrink(),
        trailing: IconButton(
          icon: Icon(
            Icons.add,
          ),
          onPressed: () {
            Responsive.isDesktop(context) || kIsWeb
                ? getAnexoWeb()
                : escolherGaleriaFoto(getAnexo, getAnexoWeb);
          },
        ),
      ),
    ),
  );
}

Widget _showImage(
  BuildContext context,
  Uint8List image,
  String label,
  String extensao,
  Function handleDeleteImage,
) {
  return image != null
      ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child:
                    Text(extensao != null ? "$label.$extensao" : "$label.jpg"),
              ),
              IconButton(
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    handleDeleteImage();
                  }),
            ],
          ),
        )
      : SizedBox.shrink();
}
