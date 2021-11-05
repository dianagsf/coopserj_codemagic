import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardNotification extends StatelessWidget {
  final String imageURL;
  final String title;
  final String text;
  final String url;
  final Function handleViewNotificacao;

  const CardNotification({
    Key key,
    @required this.imageURL,
    @required this.title,
    @required this.text,
    @required this.url,
    @required this.handleViewNotificacao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            imageURL.isNotEmpty
                ? Image.network(
                    imageURL,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
            title.isNotEmpty
                ? ListTile(
                    leading: Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.blueGrey,
                    ),
                    title: Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            text.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            url.isNotEmpty
                ? ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.blueAccent,
                        ),
                        onPressed: () {
                          _launchURL(url);
                          handleViewNotificacao();
                        },
                        child: const Text(
                          'SAIBA MAIS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
