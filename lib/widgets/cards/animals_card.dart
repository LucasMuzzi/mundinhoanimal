import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../model/animals.dart';

class AnimalCard extends StatefulWidget {
  final Animal animal;

  const AnimalCard({super.key, required this.animal});

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  double _scale = 1.0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _onTap() async {
    setState(() {
      _scale = 1.1;
    });

    await _audioPlayer.stop();
    await _audioPlayer.play(
      AssetSource(widget.animal.soundPath.replaceFirst('assets/', '')),
    );
    await Future.delayed(const Duration(milliseconds: 150));

    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Image.asset(widget.animal.imgPath, fit: BoxFit.contain),
      ),
    );
  }
}
