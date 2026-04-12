import 'package:car_api_final_app/models/noticia_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/news_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late List<Noticia> _newsList = [];

  @override
  void initState() {
    super.initState();
    getNewsList();
  }

  Future getNewsList() async {
    final apiNewsList = await HttpService.getListaNoticias();
    if (!mounted) return;
    setState(() {
      _newsList = apiNewsList;
    });
  }

  Future _handleRefresh() async {
    HapticFeedback.lightImpact();
    await getNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Noticias Automotrices",
          style: GoogleFonts.sairaStencilOne(fontSize: 30),
        ),
        _newsList.isNotEmpty
            ? Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return NewsListItem(news: _newsList[index]);
                    },
                  ),
                ),
              )
            : Expanded(
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text("No se pudo encontrar ningúna noticia"),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
