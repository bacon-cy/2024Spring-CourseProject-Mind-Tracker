class Song {
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
        title: '冥想',
        description: '引導 : 石世明老師',
        url: 'assets/musics/audio.mp3',
        coverUrl: 'assets/images/meditation2.jpg')
  ];
}
