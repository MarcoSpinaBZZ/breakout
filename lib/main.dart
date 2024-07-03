import 'package:breakout/providers/volume_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/main_menu_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => VolumeProvider(),
      child: const BreakoutApp(),
    ),
  );
}

class BreakoutApp extends StatelessWidget {
  const BreakoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breakout',
      home: MainMenu(),
    );
  }
}
