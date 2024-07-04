import 'package:audioplayers/audioplayers.dart';
import 'package:breakout/pages/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart' as flame;
import 'package:provider/provider.dart';
import '../forge2d_game_world.dart';
import 'package:breakout/pages/overlay_builder.dart';
import 'package:breakout/providers/volume_provider.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  final rwGreen = const Color.fromRGBO(21, 132, 67, 1);
  late AudioPlayer _audioPlayer;
  late Forge2dGameWorld _forge2dGameWorld;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _forge2dGameWorld = Forge2dGameWorld();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    double volume = context.read<VolumeProvider>().backgroundMusicVolume;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/play_music.mp3'), volume: volume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rwGreen,
      body: Stack(
        children: [
          Container(
            color: Colors.black87,
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 40,
            ),
            child: flame.GameWidget<Forge2dGameWorld>(
              game: _forge2dGameWorld,
              overlayBuilderMap: {
                'PreGame': (context, game) => OverlayBuilder.preGame(context, game),
                'PostGame': (context, game) => OverlayBuilder.postGame(context, game),
              },
              initialActiveOverlays: const ['PreGame'],
            ),
          ),
          Positioned(
            top: 42,
            right: 25,
            child: IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
