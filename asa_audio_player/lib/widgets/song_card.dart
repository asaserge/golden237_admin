import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/song_model.dart';

class SongCard extends StatelessWidget {
  SongCard({Key? key, required this.song}) : super(key: key);
  final Song song;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Get.toNamed('/song', arguments: song);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: size.width * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(song.coverUrl)
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: size.width * 0.37,
              margin: const EdgeInsets.only(bottom: 10.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white.withOpacity(0.8)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.deepPurple)),
                      Expanded(
                        child: Text(song.description, overflow: TextOverflow.ellipsis, maxLines: 1,
                            style: const TextStyle(color: Colors.deepPurple, fontSize: 10, fontFamily: 'montserrat_light')),
                      ),
                    ],
                  ),
                  const Icon(Icons.play_circle, color: Colors.deepPurple, size: 25,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
