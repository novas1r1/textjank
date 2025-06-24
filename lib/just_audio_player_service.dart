import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class JustAudioPlayerService {
  final AudioPlayer justAudioPlayer;

  late Stream<PlayerState> playerStateStream;
  late Stream<Duration> positionStream;

  JustAudioPlayerService({required this.justAudioPlayer});

  Duration get position => justAudioPlayer.position;
  Duration? get duration => justAudioPlayer.duration;
  PlayerState? get playerState => justAudioPlayer.playerState;

  Future<void> init() async {
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());

    final audioSource = AudioSource.asset(
      'assets/mp3/song.mp3',
      tag: MediaItem(
        id: '1',
        title: 'Song',
        artist: 'Artist',
        duration: Duration(minutes: 3, seconds: 24),
      ),
    );

    await justAudioPlayer.setAudioSource(audioSource);

    playerStateStream = justAudioPlayer.playerStateStream;
    positionStream = justAudioPlayer.createPositionStream(
      minPeriod: const Duration(milliseconds: 250),
      maxPeriod: const Duration(milliseconds: 250),
    );
  }

  Future<void> play() async {
    await justAudioPlayer.play();
  }

  Future<void> pause() async {
    await justAudioPlayer.pause();
  }

  Future<void> stop() async {
    await justAudioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await justAudioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await justAudioPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await justAudioPlayer.stop();
    await justAudioPlayer.dispose();
    await playerStateStream.drain();
    await positionStream.drain();

    await justAudioPlayer.dispose();
  }
}
