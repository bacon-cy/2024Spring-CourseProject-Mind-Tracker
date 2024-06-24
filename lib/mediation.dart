import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mind_tracker/seekbar.dart';
import 'package:mind_tracker/song_model.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Song song = Song.songs[0];

  @override
  void initState() {
    super.initState();
    audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse('asset:///${song.url}')),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDaataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    // temporarily being a Material App to be main page
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(song.coverUrl, fit: BoxFit.cover),
            ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [
                        0.0,
                        0.6,
                        0.8
                      ]).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.yellow.shade200,
                      Colors.yellow.shade800,
                    ],
                  )),
                )),
            MusicPlayer(
                song: song,
                seekBarDataStream: _seekBarDaataStream,
                audioPlayer: audioPlayer)
          ],
        ));
  }
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({
    super.key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  }) : _seekBarDataStream = seekBarDataStream;

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(song.title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    )),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(song.description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    )),
          ),
          const SizedBox(height: 30),
          StreamBuilder(
              stream: _seekBarDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SeekBar(
                      position: positionData?.position ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onChangedEnd: audioPlayer.seek,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            audioPlayer.seek(((positionData?.position ??
                                        Duration.zero) <
                                    const Duration(seconds: 5))
                                ? Duration.zero
                                : (positionData?.position ?? Duration.zero) -
                                    const Duration(seconds: 5));
                          },
                          iconSize: 45,
                          icon: const Icon(
                            Icons.replay_5,
                            color: Colors.white,
                          ),
                        ),
                        StreamBuilder(
                            stream: audioPlayer.playerStateStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final playerState = snapshot.data;
                                final processingState =
                                    playerState!.processingState;
                                if (processingState ==
                                        ProcessingState.loading ||
                                    processingState ==
                                        ProcessingState.buffering) {
                                  return Container(
                                    width: 64.0,
                                    height: 64.0,
                                    margin: const EdgeInsets.all(10.0),
                                    child: const CircularProgressIndicator(),
                                  );
                                } else if (!audioPlayer.playing) {
                                  return Center(
                                    child: IconButton(
                                      onPressed: audioPlayer.play,
                                      iconSize: 64,
                                      icon: const Icon(
                                        Icons.play_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                } else if (processingState !=
                                    ProcessingState.completed) {
                                  return Center(
                                    child: IconButton(
                                      onPressed: audioPlayer.pause,
                                      iconSize: 75,
                                      icon: const Icon(
                                        Icons.pause_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                } else {
                                  // the audio is completed.
                                  return Center(
                                    child: IconButton(
                                      onPressed: () {
                                        Get.toNamed('/mood');
                                      },
                                      iconSize: 75,
                                      icon: const Icon(
                                        Icons.pause_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Container(
                                  width: 64.0,
                                  height: 64.0,
                                  margin: const EdgeInsets.all(10.0),
                                  child: const CircularProgressIndicator(),
                                );
                              }
                            }),
                        IconButton(
                          onPressed: () async {
                            audioPlayer.seek(((positionData?.position ??
                                        Duration.zero) >=
                                    (positionData?.duration ?? Duration.zero))
                                ? (positionData?.duration ?? Duration.zero)
                                : (positionData?.position ?? Duration.zero) +
                                    const Duration(seconds: 5));
                          },
                          iconSize: 45,
                          icon: const Icon(
                            Icons.forward_5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }
}
