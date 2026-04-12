import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsListItem extends StatelessWidget {
  const NewsListItem({super.key, required this.news});

  final Noticia news;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: BoxBorder.all(color: Colors.black)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 250,
                  child: Text(
                    news.titulo,
                    style: GoogleFonts.inter(fontWeight: FontWeight(700)),
                  ),
                ),
                Text(DateFormat('dd/MM/yyyy').format(news.fecha)),
              ],
            ),
            Divider(),
            Text(
              news.resumen,
              style: GoogleFonts.interTight(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
