import 'package:coopserj_app/controllers/controllers.dart';
import 'package:coopserj_app/repositories/repositories.dart';
import 'package:coopserj_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  final int matricula;

  const NotificationPage({
    Key key,
    @required this.matricula,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificacoesController notificacoesController = Get.find();
  VisualizouNotiRepository visualizouNotiRepository =
      VisualizouNotiRepository();

  final List<String> images = [
    "images/notification_card3.png",
    "images/news_card.png",
    "images/notification_card1.png",
    "images/notification_card2.png",
  ];

  handleViewNotificacao(dynamic numero) {
    visualizouNotiRepository.saveView(
      {
        "numero": numero,
        "data": DateTime.now().toString().substring(0, 19),
        "matricula": widget.matricula,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notificações",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GetX<NotificacoesController>(
        builder: (_) {
          return _.notificacoes
                      .where((not) =>
                          not.matricula == null ||
                          not.matricula == widget.matricula)
                      .length <
                  1
              ? Center(child: Image.asset("images/semNotificacao.png"))
              : ListView.builder(
                  itemCount: _.notificacoes.length,
                  itemBuilder: (context, index) {
                    return _.notificacoes[index].matricula == null
                        ? CardNotification(
                            imageURL: _.notificacoes[index].imagemURL != null
                                ? _.notificacoes[index].imagemURL
                                : '',
                            title: _.notificacoes[index].titulo != null
                                ? _.notificacoes[index].titulo
                                : '',
                            text: _.notificacoes[index].texto != null
                                ? _.notificacoes[index].texto
                                : '',
                            url: _.notificacoes[index].url != null
                                ? _.notificacoes[index].url
                                : '',
                            handleViewNotificacao: () => handleViewNotificacao(
                                _.notificacoes[index].numero),
                          )
                        : _.notificacoes[index].matricula == widget.matricula
                            ? CardNotification(
                                imageURL:
                                    _.notificacoes[index].imagemURL != null
                                        ? _.notificacoes[index].imagemURL
                                        : '', //images[random.nextInt(4)],
                                title: _.notificacoes[index].titulo != null
                                    ? _.notificacoes[index].titulo
                                    : '',
                                text: _.notificacoes[index].texto != null
                                    ? _.notificacoes[index].texto
                                    : '',
                                url: _.notificacoes[index].url != null
                                    ? _.notificacoes[index].url
                                    : '',
                                handleViewNotificacao: () =>
                                    handleViewNotificacao(
                                        _.notificacoes[index].numero),
                              )
                            : SizedBox.shrink();
                  },
                );
        },
      ),
    );
  }
}
