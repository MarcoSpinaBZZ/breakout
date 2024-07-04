import 'package:breakout/pages/main_settings_page.dart';
import 'package:breakout/pages/main_game_page.dart';
import 'package:breakout/providers/volume_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Color black = Colors.black;
  late AudioPlayer _audioPlayer;
  late AudioPlayer _buttonPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _buttonPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    double volume = context.read<VolumeProvider>().backgroundMusicVolume;
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/menu_music.mp3'), volume: volume);
  }

  void _playButtonSound() async {
    double volume = context.read<VolumeProvider>().soundEffectVolume;
    await _buttonPlayer.play(AssetSource('audio/play_button.mp3'), volume: volume);
  }

  void _stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _buttonPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'B',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'R',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'E',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'A',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'K',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'O',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'U',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40,
                  ),
                ),
                Text(
                  'T',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _playButtonSound();
                _stopBackgroundMusic();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainGamePage()),
                );
              },
              child: const Text('Play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _playButtonSound();
                _stopBackgroundMusic();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainSettings()),
                );
              },
              child: const Text('Settings'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text('Quit'),
            ),
          ],
        ),
      ),
    );
  }
}
