import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioplayersPlayerService {
  final AudioPlayer audioPlayer;

  late Stream<PlayerState> playerStateStream;
  late Stream<Duration> positionStream;

  AudioplayersPlayerService({required this.audioPlayer});

  Future<Duration?> get position async => await audioPlayer.getCurrentPosition();
  Future<Duration?> get duration async => await audioPlayer.getDuration();
  PlayerState? get playerState => audioPlayer.state;

  Future<void> init() async {
    await audioPlayer.setSource(AssetSource('mp3/song.mp3'));

    playerStateStream = audioPlayer.onPlayerStateChanged;
    positionStream = audioPlayer.onPositionChanged;
  }

  Future<void> play() async {
    await audioPlayer.play(AssetSource('mp3/song.mp3'));
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  /* Future<void> setSpeed(double speed) async {
    var validatedSpeed = speed;

    if (speed < _minSpeed) {
      validatedSpeed = _minSpeed;
    } else if (speed > _maxSpeed) {
      validatedSpeed = _maxSpeed;
    }

    await audioPlayer.setSpeed(validatedSpeed);
  } */

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await audioPlayer.stop();
    await audioPlayer.dispose();
    await playerStateStream.drain();
    await positionStream.drain();

    await audioPlayer.dispose();
  }
}
