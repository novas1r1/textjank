import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:textjank/audioplayers_player_service.dart';
import 'package:textjank/just_audio_player_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  final justaudioPlayerService = JustAudioPlayerService(justAudioPlayer: AudioPlayer());
  await justaudioPlayerService.init();
  runApp(MainAppJustAudio(audioPlayerService: justaudioPlayerService));

  /*   final audioplayersPlayerService = AudioplayersPlayerService(
    audioPlayer: audioplayers.AudioPlayer(),
  );
  await audioplayersPlayerService.init();
  runApp(MainAppAudioplayers(audioPlayerService: audioplayersPlayerService)); */
}

class MainAppJustAudio extends StatelessWidget {
  final JustAudioPlayerService audioPlayerService;

  const MainAppJustAudio({super.key, required this.audioPlayerService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TextJank Just Audio')),
        body: Column(
          children: [
            StreamBuilder<Duration>(
              stream: audioPlayerService.positionStream,
              initialData: Duration.zero,
              builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.toFormattedString());
                }
                return const SizedBox.shrink();
              },
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayerService.play();
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayerService.pause();
              },
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainAppAudioplayers extends StatelessWidget {
  final AudioplayersPlayerService audioPlayerService;

  const MainAppAudioplayers({super.key, required this.audioPlayerService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TextJank Audioplayers')),
        body: Column(
          children: [
            StreamBuilder<Duration>(
              stream: audioPlayerService.positionStream,
              initialData: Duration.zero,
              builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.toFormattedString());
                }
                return const SizedBox.shrink();
              },
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayerService.play();
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                audioPlayerService.pause();
              },
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}

extension DurationExtension on Duration {
  String toFormattedString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final milliseconds = inMilliseconds.remainder(1000);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}';
    }
  }

  String toFormattedStringWithoutMilliseconds() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String toFormattedStringMinutesSecondsMilliseconds() {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final milliseconds = inMilliseconds.remainder(1000);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}';
  }
}
