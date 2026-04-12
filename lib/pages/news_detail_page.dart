import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPageDetail extends StatefulWidget {
  const NewsPageDetail({super.key, required this.newsId, required this.title});
  final int newsId;
  final String title;

  @override
  State<NewsPageDetail> createState() => _NewsPageDetailState();
}

class _NewsPageDetailState extends State<NewsPageDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Más Detalle",
          style: GoogleFonts.sairaStencilOne(
            fontSize: 30,
            fontWeight: FontWeight(300),
          ),
        ),
      ),
      body: FutureBuilder(
        future: HttpService.getNoticia(widget.newsId),
        builder: (context, res) {
          if (res.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (res.hasError || res.hasData == false) {
            return Column(
              children: [
                Center(child: Text("No se pudo conseguir la Información")),
              ],
            );
          }

          if (res.hasData) {
            final noticia = res.data;
            return NewsDetailContent(news: noticia!);
          }

          return Placeholder();
        },
      ),
    );
  }
}

class NewsDetailContent extends StatelessWidget {
  const NewsDetailContent({super.key, required this.news});
  final Noticia news;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Text(
            news.titulo,
            style: GoogleFonts.inter(fontWeight: FontWeight(700), fontSize: 24),
          ),
          Text(DateFormat('dd/MM/yyyy').format(news.fecha)),
          Text.rich(
            style: GoogleFonts.interTight(
              fontStyle: FontStyle.italic,
              color: Colors.blueAccent,
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  if (news.link.isNotEmpty) {
                    final uri = Uri.parse(news.link);
                    await launchUrl(uri);
                  }
                },
              text: "Ver en remolacha.net",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Html(
              data: news.contenido,
              extensions: [
                
              ],
              style: {
                'body': Style(
                  fontSize: FontSize(18),
                  lineHeight: LineHeight(1.5),
                  textAlign: TextAlign.justify,
                ),
                'p': Style(margin: Margins.only(bottom: 20)),
                'a': Style(
                  color: Colors.blueAccent,
                  textDecorationColor: Colors.blueAccent,
                ),
                'img': Style(
                  display: Display.block,
                  width: Width(300),
                  height: Height(200),
                  margin: Margins.only(right: 20),
                ),
              },
              onLinkTap: (url, _, _) async {
                if (url != null) {
                  final uri = Uri.parse(url);
                  await launchUrl(uri);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
