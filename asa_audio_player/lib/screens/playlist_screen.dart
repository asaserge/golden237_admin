import 'package:flutter/material.dart';

import '../models/playlist_model.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

  final Playlist playlist = Playlist.playlist[0];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    bool isPlay = true;
    return
      Container(
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: (){

            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: const Text('Playlist'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: (){

              },
              icon: const Icon(Icons.more_vert_outlined),
            ),
          ],
        ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    playlist.imageUrl,
                    height: size.height * 0.6,
                    width: size.width * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Text(playlist.title, style: Theme.of(context)
                      .textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30.0),

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isPlay = !isPlay;
                      });
                    },
                    child: Container(
                      height: 50.0,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            left: isPlay ? 0 : size.width * 0.45,
                            child: Container(
                                  height: 50.0,
                                  width: size.width * 0.45,
                                  decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(15.0)
                                  )
                              ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text('Play', style: TextStyle(color: isPlay ? Colors.white :
                                        Colors.deepPurple, fontSize: 17)),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.play_circle,color: isPlay ? Colors.white : Colors.deepPurple )
                                    ],
                                  )
                              ),
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text('Shuffle', style: TextStyle(color: isPlay ? Colors.white :
                                        Colors.deepPurple, fontSize: 17)),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Icon(Icons.shuffle,color: isPlay ? Colors.white : Colors.deepPurple )
                                    ],
                                  )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}
