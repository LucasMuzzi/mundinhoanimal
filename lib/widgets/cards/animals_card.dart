// lib/widgets/cards/animals_card.dart
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

  void _onTap() async {
    // Aumenta a escala
    setState(() {
      _scale = 1.1;
    });
    // Adiciona uma pequena pausa antes de diminuir
    await Future.delayed(const Duration(milliseconds: 150));
    // Volta ao tamanho original
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
