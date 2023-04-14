import 'package:asa_audio_player/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/song_model.dart';
import '../widgets/background_filter.dart';
import '../widgets/player_button.dart';
import '../widgets/seekbar_data.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({Key? key}) : super(key: key);

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {

  Song song = Get.arguments ?? Song.songs[0];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
              Uri.parse('assets:///${song.url}')
          ),
        ]
      )
    );
  }

  Stream<SeekbarData> _seekbarDataStream(){
    return rxdart.Rx.combineLatest2<Duration, Duration?, SeekbarData>(
        audioPlayer.positionStream,
        audioPlayer.durationStream,
            (Duration position, Duration? duration){
          return SeekbarData(position: position, duration: duration ?? Duration.zero) ;
        }
    );
  }


  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            song.coverUrl,
            fit: BoxFit.cover,
          ),
          const BackgroundFilter(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<SeekbarData>(
                  stream: _seekbarDataStream(),
                  builder: (context, snapshot){
                    final positionData = snapshot.data;
                    return Seekbar(
                      position: positionData?.position ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onChangeEnd: audioPlayer.seek
                    );
                  }
                ),

                const SectionHeader(title: 'title'),

                Row(
                  children: [
                    PlayerButton(audioPlayer: audioPlayer)
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){
                          audioPlayer.hasPrevious ? audioPlayer.seekToPrevious() : null;
                        },
                        iconSize: 35,
                        icon: const Icon(Icons.settings, color: Colors.white)
                    ),
                    IconButton(
                        onPressed: (){
                          audioPlayer.hasPrevious ? audioPlayer.seekToPrevious() : null;
                        },
                        iconSize: 35,
                        icon: const Icon(Icons.cloud_download, color: Colors.white)
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
