import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // verifica se tá na WEB

class MainDrawer extends StatelessWidget {
  final String nome;
  final int matricula;
  final String email;
  final String telefone;
  final String senha;
  final String cpf;

  const MainDrawer({
    Key key,
    @required this.nome,
    @required this.matricula,
    @required this.email,
    @required this.telefone,
    @required this.senha,
    this.cpf,
  }) : super(key: key);

  _launchURL() async {
    const url = 'https://api.whatsapp.com/send?phone=5521992356817';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  Widget _createItem(IconData icon, String label, Function onTap) {
    if (label.compareTo("CONVÊNIOS") == 0) {
      return ExpansionTile(
        leading: Icon(icon),
        title: Text(label),
        children: [
          buildSubMenu('CONSULTAR CONVÊNIOS', ConsultaConveniosPage()),
          buildSubMenu(
              'SOLICITAR NOVO CONVÊNIO',
              SolicitarConvenioPage(
                matricula: matricula,
                senha: senha,
              )),
          buildSubMenu(
            'SOLICITAR CANCELAMENTO',
            CancelarConvenioPage(
              matricula: matricula,
              senha: senha,
            ),
          ),
        ],
      );
    }
    if (label.compareTo("EMPRÉSTIMOS") == 0) {
      return ExpansionTile(
        leading: Icon(icon),
        title: Text(label),
        children: [
          buildSubMenu(
            'CONSULTAR SOLICITAÇÕES',
            ConsultaSolicPage(matricula: matricula),
          ),
          buildSubMenu(
            'SOLICITAR EMPRÉSTIMO',
            SolicitarEmprestimoPage(
              matricula: matricula,
              senha: senha,
            ),
          ),
          buildSubMenu(
            'REFINANCIAR EMPRÉSTIMO',
            RefinanciarEmprestimoPage(
              senha: senha,
              matricula: matricula,
            ),
          ),
        ],
      );
    }
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        label,
      ),
      onTap: () {
        //SAVE LOG
        if (label.compareTo("SAIR") == 0) {
          LogAppRepository _logAppRepository = LogAppRepository();

          /// SAVE LOG APP
          _logAppRepository.saveLog({
            "usuario": matricula,
            "datahora": DateTime.now().toString().substring(0, 23),
            "modulo": "Fim Sessão",
          });
        }
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  nome.toUpperCase(),
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "matrícula: ${matricula.toString()}",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Divider(),
              _createItem(
                Icons.home_outlined,
                'PÁGINA INICIAL',
                () => Get.to(
                  HomePage(
                    nome: nome,
                    matricula: matricula,
                    email: "",
                    telefone: "",
                    senha: senha,
                    cpf: cpf,
                  ),
                ),
              ),
              Divider(),
              _createItem(
                Icons.work_outline,
                'CONVÊNIOS',
                () {},
              ),
              Divider(),
              _createItem(
                Icons.credit_card,
                'EMPRÉSTIMOS',
                () {},
              ),
              Divider(),
              _createItem(
                Icons.payments_outlined,
                'PEDIDO DE QUITAÇÃO',
                () => Get.to(
                  QuitacaoPage(matricula: matricula, senha: senha),
                ),
              ),
              Divider(),
              _createItem(
                Icons.work_off_outlined,
                'PEDIDO DE DESLIGAMENTO',
                () => Get.to(DesligamentoPage()),
              ),
              Divider(),
              _createItem(
                Icons.face,
                'PESSOA EXPOSTA',
                () => Get.to(
                  PessoaExpostaPage(
                    matricula: matricula,
                    senha: senha,
                    solicPage: false,
                  ),
                ),
              ),
              Divider(),
              _createItem(
                Icons.info_outline,
                'INFORMAÇÕES',
                () => Get.to(InfoPage()),
              ),
              Divider(),
              _createItem(
                MdiIcons.whatsapp,
                'FALE CONOSCO',
                _launchURL,
              ),
              Divider(),
              _createItem(
                Icons.exit_to_app,
                'SAIR',
                () => kIsWeb ? Get.to(LoginPage()) : Get.to(InitialPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildSubMenu(String text, Widget page) {
  return Padding(
    padding: EdgeInsets.only(left: 15),
    child: ListTile(
      leading: Icon(Icons.arrow_forward),
      title: Text(text),
      onTap: () {
        Get.to(page);
      },
    ),
  );
}
