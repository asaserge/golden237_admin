import 'package:asa_audio_player/models/song_model.dart';

class Playlist{
  final String title;
  final List<Song> songs;
  final String imageUrl;


  Playlist({
    required this.title,
    required this.songs,
    required this.imageUrl,
  });

  static List<Playlist> playlist = [
    Playlist(
      title: 'Hip Hop R&B Mix',
      songs: Song.songs,
      imageUrl: 'assets/images/alcohol.jpg',
    ),
    Playlist(
      title: 'Hip Hop R&B Mix',
      songs: Song.songs,
      imageUrl: 'assets/images/alcohol.jpg',
    ),
    Playlist(
      title: 'Techno & Jam',
      songs: Song.songs,
      imageUrl: 'assets/images/good.png',
    ),
    Playlist(
      title: 'Afro Mix Tape',
      songs: Song.songs,
      imageUrl: 'assets/images/bad.jpg',
    ),
  ];
}