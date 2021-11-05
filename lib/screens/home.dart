import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:coopserj_app/utils/responsive.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final String nome;
  final int matricula;
  final String email;
  final String telefone;
  final String senha;
  final String cpf;

  const HomePage({
    Key key,
    @required this.nome,
    @required this.matricula,
    this.email,
    this.telefone,
    @required this.senha,
    @required this.cpf,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoriasController categoriasController = Get.put(CategoriasController());
  BancosController bancosController = Get.put(BancosController());
  ConveniosController conveniosController = Get.put(ConveniosController());
  NotificacoesController notificacoesController =
      Get.put(NotificacoesController());

  SolicitacoesController solicitacoesController =
      Get.put(SolicitacoesController());

  final SolicPendentesController solicPendentesController =
      Get.put(SolicPendentesController());

  final PedidoQuitacaoController pedidoQuitacaoController =
      Get.put(PedidoQuitacaoController());

  AssociadoRepository associadoRepository = AssociadoRepository();
  LogAppRepository _logAppRepository = LogAppRepository();

  TextEditingController emailController = TextEditingController();
  MaskedTextController telefoneController =
      MaskedTextController(mask: "(00) 00000-0000");

  _saveDados() {
    if (widget.email == null) {
      associadoRepository.postEmail(
        {
          "email": emailController.text,
        },
        widget.matricula,
      );
    } else if (widget.telefone == null) {
      associadoRepository.postTelefone(
        {
          "telefone": telefoneController.text,
        },
        widget.matricula,
      );
    } else {
      associadoRepository.postEmail(
        {
          "email": emailController.text,
        },
        widget.matricula,
      );
      associadoRepository.postTelefone(
        {
          "telefone": telefoneController.text,
        },
        widget.matricula,
      );
    }

    Get.back();
    Get.snackbar(
      "Dados enviados com sucesso!",
      "",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            "Identificamos a falta de alguns dados pessoais na nossa base de dados. Esses dados são importantes para conseguirmos entrar em contato."),
        content: Form(
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                widget.email == null
                    ? TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "e-mail",
                        ),
                      )
                    : SizedBox.shrink(),
                widget.telefone == null
                    ? TextFormField(
                        controller: telefoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone_callback_outlined),
                          labelText: "telefone",
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "CANCELAR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _saveDados();
            },
            child: Text(
              "ENVIAR",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // SAVE LOG APP
    _logAppRepository.saveLog({
      "usuario": widget.matricula,
      "datahora": DateTime.now().toString().substring(0, 23),
      "modulo": "Início Sessão",
    });

    //get categorias solic
    categoriasController.getCategorias();
    //get bancos solic
    bancosController.getBancos();
    conveniosController.getConvenios(widget.matricula);

    //get quitações em andamento
    pedidoQuitacaoController.getPedidosQuitacao();

    // get solic consulta
    solicitacoesController.getSolicitacoes(widget.matricula);
  }

  @override
  Widget build(BuildContext context) {
    /*print("EMAIL: ${widget.email}");
    print("TELEFONE: ${widget.telefone}");

    if (widget.email == null || widget.telefone == null)
      Future.delayed(Duration(seconds: 5), () => showAlert(context));*/

    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Coopserj",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            GetX<NotificacoesController>(
              initState: (state) {
                notificacoesController.getNotificacoes(widget.matricula);
              },
              builder: (_) {
                return _.notificacoes
                            .where((not) =>
                                not.matricula == null ||
                                not.matricula == widget.matricula)
                            .length >
                        0
                    ? Badge(
                        position: BadgePosition.topEnd(top: 0, end: 6),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          _.notificacoes
                              .where((not) =>
                                  not.matricula == null ||
                                  not.matricula == widget.matricula)
                              .length
                              .toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              Icons.notification_important_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.to(NotificationPage(
                                  matricula: widget.matricula));
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          icon: Icon(
                            Icons.notification_important_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Get.to(
                                NotificationPage(matricula: widget.matricula));
                          },
                        ),
                      );
              },
            )
          ],
        ),
        drawer: MainDrawer(
          nome: widget.nome,
          matricula: widget.matricula,
          email: widget.email,
          telefone: widget.telefone,
          senha: widget.senha,
          cpf: widget.cpf,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ConveniosContainer(matricula: widget.matricula),
            ),
            SliverToBoxAdapter(
              child: EmprestimosContainer(matricula: widget.matricula),
            ),
            SliverToBoxAdapter(
                child: InkWell(
              onTap: () =>
                  Get.to(ConsultaSolicPage(matricula: widget.matricula)),
              child: Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Ver minhas solicitações de empréstimos em andamento',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[700],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
      tablet: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Coopserj",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            GetX<NotificacoesController>(
              initState: (state) {
                notificacoesController.getNotificacoes(widget.matricula);
              },
              builder: (_) {
                return _.notificacoes
                            .where((not) =>
                                not.matricula == null ||
                                not.matricula == widget.matricula)
                            .length >
                        0
                    ? Badge(
                        position: BadgePosition.topEnd(top: 0, end: 6),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          _.notificacoes
                              .where((not) =>
                                  not.matricula == null ||
                                  not.matricula == widget.matricula)
                              .length
                              .toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: IconButton(
                            icon: Icon(
                              Icons.notification_important_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.to(NotificationPage(
                                  matricula: widget.matricula));
                            },
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          icon: Icon(
                            Icons.notification_important_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Get.to(
                                NotificationPage(matricula: widget.matricula));
                          },
                        ),
                      );
              },
            )
          ],
        ),
        drawer: MainDrawer(
          nome: widget.nome,
          matricula: widget.matricula,
          email: widget.email,
          telefone: widget.telefone,
          senha: widget.senha,
          cpf: widget.cpf,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ConveniosContainer(matricula: widget.matricula),
            ),
            SliverToBoxAdapter(
              child: EmprestimosContainer(matricula: widget.matricula),
            ),
            SliverToBoxAdapter(
                child: InkWell(
              onTap: () =>
                  Get.to(ConsultaSolicPage(matricula: widget.matricula)),
              child: Card(
                elevation: 5,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Ver minhas solicitações de empréstimos em andamento',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[700],
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
      desktop: Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: MainDrawer(
                  nome: widget.nome,
                  matricula: widget.matricula,
                  email: widget.email,
                  telefone: widget.telefone,
                  senha: widget.senha,
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: Responsive.isMobile(context)
                              ? const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20)
                              : const EdgeInsets.all(8),
                          child:
                              ConveniosContainer(matricula: widget.matricula),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: Responsive.isMobile(context)
                              ? const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20)
                              : const EdgeInsets.all(8),
                          child:
                              EmprestimosContainer(matricula: widget.matricula),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: InkWell(
                        onTap: () => Get.to(
                            ConsultaSolicPage(matricula: widget.matricula)),
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    alignment: Alignment.center,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      'Ver minhas solicitações de empréstimos em andamento',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey[700],
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
