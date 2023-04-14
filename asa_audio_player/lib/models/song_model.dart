class Song{
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
    Song(
      title: 'Trolls',
      description: 'Fragile Glass Trolls',
      url: 'assets/musics/trolls.mp3',
      coverUrl: 'assets/images/trolls.jpg',
    ),
    Song(
      title: 'Alcohol',
      description: 'Drink My Life Out',
      url: 'assets/musics/trolls.mp3',
      coverUrl: 'assets/images/alcohol.jpg',
    ),
    Song(
      title: 'Bad',
      description: 'Baddest Boy',
      url: 'assets/musics/trolls.mp3',
      coverUrl: 'assets/images/bad.jpg',
    ),
  ];
}