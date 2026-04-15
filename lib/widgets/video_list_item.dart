import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:car_api_final_app/pages/custom_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoListItem extends StatelessWidget {
  const VideoListItem({super.key, required this.video});
  final CareVideo video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomPlayerPage(video: video)),
      ),
      child: Card(
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        margin: EdgeInsets.all(10),
        // padding: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " ${video.categoria}",
                style: GoogleFonts.interTight(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepOrange,
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      video.titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),

                  Image.network(video.thumbnail, width: 125),
                ],
              ),
              Divider(),
              Text(
                video.descripcion,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
