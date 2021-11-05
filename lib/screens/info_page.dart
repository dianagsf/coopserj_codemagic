import 'package:coopserj_app/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double alturaTela =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Não foi possível abrir $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Informações",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          !Responsive.isDesktop(context) && !Responsive.isTablet(context)
              ? SliverToBoxAdapter(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: Responsive.isMobile(context) ? 1 : 0.5,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [
                      _buildCardCarrousel(
                          'images/info.jpg', 'Descontos', alturaTela),
                      _buildCardCarrousel(
                          'images/infoPromo.jpg', 'Sem taxas', alturaTela),
                      _buildCardCarrousel(
                          'images/infoPage.jpg', 'Empréstimos', alturaTela),
                    ],
                  ),
                )
              : SliverToBoxAdapter(),
          SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: alturaTela * 0.05, vertical: alturaTela * 0.04),
            sliver: SliverGrid.count(
              crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildCardMenu(
                  'Convênios - Benefícios',
                  Colors.blue[600],
                  Icons.file_copy,
                  Colors.blue[200],
                  'https://www.coopserj.coop.br/convenios',
                  _launchURL,
                  alturaTela,
                ),
                _buildCardMenu(
                  'Balanço da Cooperativa',
                  Colors.green[800],
                  Icons.book_outlined,
                  Colors.greenAccent,
                  'https://d61d0cd6-8dd5-4423-832a-cf5f699d1032.filesusr.com/ugd/c350bf_29fbaf4bb9a84f2e865c89b8cac0dc7a.pdf',
                  _launchURL,
                  alturaTela,
                ),
                _buildCardMenu(
                  'Instagram',
                  Colors.pinkAccent,
                  MdiIcons.instagram,
                  Colors.pink[200],
                  'https://www.instagram.com/coopcoopserj/',
                  _launchURL,
                  alturaTela,
                ),
                _buildCardMenu(
                  'Site',
                  Colors.purple[800],
                  Icons.web,
                  Colors.purple[200],
                  'https://www.coopserj.coop.br/',
                  _launchURL,
                  alturaTela,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildCardCarrousel(String image, String text, double alturaTela) {
  return Container(
    margin: const EdgeInsets.all(20),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            image,
            height: alturaTela * 0.3, // 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 20,
          left: 10,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 20,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCardMenu(
  String label,
  Color color,
  IconData icon,
  Color gradient,
  String url,
  Function launchURL,
  double alturaTela,
) {
  return InkWell(
    onTap: () => launchURL(url),
    child: Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
            colors: [
              color,
              gradient,
            ],
          ),
          // color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: alturaTela * 0.07, //50,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: alturaTela * 0.022, //16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
