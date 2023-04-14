import 'package:asa_audio_player/widgets/section_header.dart';
import 'package:asa_audio_player/widgets/song_card.dart';
import 'package:flutter/material.dart';

import '../models/song_model.dart';

class TrendingMusic extends StatelessWidget {
  TrendingMusic({Key? key}) : super(key: key);

  List<Song> songs = Song.songs;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0, top: 20.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SectionHeader(title: 'Trending Music'),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: size.height * 0.27,
            child: ListView.builder(
                itemCount: songs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index){
                  return SongCard(song: songs[index]);
                }
            ),
          ),
        ],
      ),
    );
  }
}
