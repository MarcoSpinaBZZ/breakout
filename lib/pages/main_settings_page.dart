import 'package:audioplayers/audioplayers.dart';
import 'package:breakout/pages/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breakout/providers/volume_provider.dart';

class MainSettings extends StatefulWidget {
  const MainSettings({Key? key}) : super(key: key);

  @override
  _MainSettingsState createState() => _MainSettingsState();
}

class _MainSettingsState extends State<MainSettings> {
  late AudioPlayer _settingsMusicPlayer;
  late AudioPlayer _sliderSoundPlayer;

  @override
  void initState() {
    super.initState();
    _settingsMusicPlayer = AudioPlayer();
    _sliderSoundPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    await _settingsMusicPlayer.setReleaseMode(ReleaseMode.loop);
    double volume = context.read<VolumeProvider>().backgroundMusicVolume;
    await _settingsMusicPlayer.play(AssetSource('audio/settings_music.mp3'), volume: volume);
  }

  void _playSliderSound() async {
    double volume = context.read<VolumeProvider>().soundEffectVolume;
    await _sliderSoundPlayer.play(AssetSource('audio/slider_sound.mp3'), volume: volume);
  }

  void _stopBackgroundMusic() async {
    await _settingsMusicPlayer.stop();
  }

  @override
  void dispose() {
    _settingsMusicPlayer.dispose();
    _sliderSoundPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Positioned(
            top: 42,
            right: 25,
            child: IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              iconSize: 40,
              onPressed: () {
                _stopBackgroundMusic();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCustomSlider(
              icon: Icons.music_note,
              value: context.watch<VolumeProvider>().backgroundMusicVolume,
              onChanged: (value) {
                context.read<VolumeProvider>().setBackgroundMusicVolume(value);
                _settingsMusicPlayer.setVolume(value);
                _playSliderSound();
              },
            ),
            const SizedBox(height: 40),
            _buildCustomSlider(
              icon: Icons.volume_up,
              value: context.watch<VolumeProvider>().soundEffectVolume,
              onChanged: (value) {
                context.read<VolumeProvider>().setSoundEffectVolume(value);
                _sliderSoundPlayer.setVolume(value);
                _playSliderSound();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSlider({
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: CustomSliderThumbIcon(icon),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: 0,
        max: 1,
        divisions: 10,
        label: (value * 100).round().toString(),
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
      ),
    );
  }
}

class CustomSliderThumbIcon extends SliderComponentShape {
  final IconData icon;
  CustomSliderThumbIcon(this.icon);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(40.0, 40.0);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = Colors.white;
    final double iconSize = 24.0;

    canvas.drawCircle(center, 20.0, paint);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.black,
        ),
      ),
      textDirection: textDirection,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(iconSize / 2, iconSize / 2),
    );
  }
}
