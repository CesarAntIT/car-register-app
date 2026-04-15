import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:car_api_final_app/services/http_service.dart';
import 'package:car_api_final_app/widgets/video_list_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareVideoPage extends StatefulWidget {
  const CareVideoPage({super.key});

  @override
  State<CareVideoPage> createState() => _CareVideoPageState();
}

class _CareVideoPageState extends State<CareVideoPage> {
  String? _filter = "todo";
  final _filterOptions = [
    "todo",
    "mantenimiento",
    "mantenimiento general",
    "recomendaciones",
    "misc.",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  Videos Educativos",
          style: GoogleFonts.sairaStencilOne(fontSize: 30),
        ),
        Divider(),
        Text(
          "      Categorías:",
          style: GoogleFonts.saira(fontWeight: FontWeight.bold),
        ),
        Container(
          color: Colors.transparent,
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,

            padding: EdgeInsets.all(5),
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _filter = _filterOptions.first;
                }),
                child: Text("Todas"),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _filter = _filterOptions[1];
                }),
                child: Text("Mantenimiento"),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _filter = _filterOptions[2];
                }),
                child: Text("Mantenimiento General"),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _filter = _filterOptions[3];
                }),
                child: Text("Recomendaciones"),
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  _filter = _filterOptions.last;
                }),
                child: Text("Misc."),
              ),
              // DropdownButton(
              //   onChanged: (String? value) {
              //     setState(() {
              //       _filter = value;
              //     });
              //   },
              //   value: _filter,
              //   items: _filterOptions.map<DropdownMenuItem<String>>((
              //     String? value,
              //   ) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 20),
              //         child: Text(
              //           value ?? "",
              //           style: GoogleFonts.interTight(color: Colors.black),
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
            ],
          ),
        ),
        FutureBuilder(
          future: HttpService.getVideos(),
          builder: (BuildContext context, AsyncSnapshot res) {
            if (res.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (res.hasData) {
              List<CareVideo>? data = res.data;

              if (data != null && data.isNotEmpty) {
                if (_filter != "todo") {
                  if (_filter == "misc.") {
                    data = data
                        .where(
                          (x) => !_filterOptions.contains(
                            x.categoria.toLowerCase(),
                          ),
                        )
                        .toList();
                  } else {
                    data = data
                        .where((x) => x.categoria.toLowerCase() == _filter)
                        .toList();
                  }
                }

                if (data.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text("No hay Vídeos educativos de esta Categoría"),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return VideoListItem(video: data![index]);
                    },
                  ),
                );
              }
            }

            return Expanded(
              child: Center(child: Text("No se encontraron videos educativos")),
            );
          },
        ),
      ],
    );
  }
}
