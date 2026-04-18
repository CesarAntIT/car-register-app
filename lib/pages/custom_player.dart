import 'package:car_api_final_app/models/care_video_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class CustomPlayerPage extends StatefulWidget {
  const CustomPlayerPage({super.key, required this.video});
  final CareVideo video;

  @override
  State<CustomPlayerPage> createState() => _CustomPlayerPageState();
}

class _CustomPlayerPageState extends State<CustomPlayerPage> {
  late YoutubePlayerController _controller;
  final _btnStyle = IconButton.styleFrom(
    fixedSize: Size(75, 10),
    elevation: 50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(8),
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.youtubeId,
      params: YoutubePlayerParams(origin: "https://www.youtube-nocookie.com"),
    );
  }

  // Skip Forward 10 Seconds
  void skipForward() async {
    final currentTime = await _controller.currentTime;
    _controller.seekTo(seconds: currentTime + 10, allowSeekAhead: true);
  }

  // Replay (Skip Backward) 10 Seconds
  void skipBackward() async {
    final currentTime = await _controller.currentTime;
    _controller.seekTo(seconds: currentTime - 10, allowSeekAhead: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Video Player",
          style: GoogleFonts.sairaStencilOne(fontWeight: FontWeight(300)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Text(
              widget.video.titulo,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            YoutubePlayer(controller: _controller, aspectRatio: 4 / 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: <Widget>[
                IconButton.filled(
                  onPressed: () => skipBackward(),
                  icon: Icon(Icons.replay_10),
                  style: _btnStyle,
                ),
                IconButton.filled(
                  onPressed: () => _controller.playVideo(),
                  icon: Icon(Icons.play_arrow),
                  style: _btnStyle,
                ),
                IconButton.filled(
                  onPressed: () => _controller.pauseVideo(),
                  icon: Icon(Icons.pause),
                  style: _btnStyle,
                ),
                IconButton.filled(
                  onPressed: () => skipForward(),
                  icon: Icon(Icons.forward_10),
                  style: _btnStyle,
                ),
              ],
            ),
            Divider(),
            Text(widget.video.descripcion),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Ver en Youtube:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " Presiona Aquí!",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
