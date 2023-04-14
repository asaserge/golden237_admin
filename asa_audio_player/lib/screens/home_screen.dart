import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/playlist_model.dart';
import '../models/song_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_bottomnavbar.dart';
import '../widgets/discover_music.dart';
import '../widgets/section_header.dart';
import '../widgets/song_card.dart';
import '../widgets/trending_music.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Playlist> playlist = Playlist.playlist;


  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ]
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppbar(),
        bottomNavigationBar: const CustomNavBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const DiscoverMusic(),
              TrendingMusic(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SectionHeader(title: 'Playlists'),
                    const SizedBox(height: 20.0),
                    ListView.builder(
                      itemCount: playlist.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 20.0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            Get.toNamed('/playlist', arguments: playlist);
                          },
                          child: Container(
                            height: 75.0,
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.deepPurple.shade800.withOpacity(0.6)
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    playlist[index].imageUrl,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(playlist[index].title, style: Theme.of(context)
                                          .textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      Text('${playlist[index].songs.length}', maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: (){

                                    },
                                    icon: const Icon(Icons.play_circle, color: Colors.white)
                                )

                              ],
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
