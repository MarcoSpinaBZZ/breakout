import 'package:flutter/material.dart';

class VolumeProvider with ChangeNotifier {
  double _backgroundMusicVolume = 0.5;
  double _soundEffectVolume = 0.5;

  double get backgroundMusicVolume => _backgroundMusicVolume;
  double get soundEffectVolume => _soundEffectVolume;

  void setBackgroundMusicVolume(double volume) {
    _backgroundMusicVolume = volume;
    notifyListeners();
  }

  void setSoundEffectVolume(double volume) {
    _soundEffectVolume = volume;
    notifyListeners();
  }
}
