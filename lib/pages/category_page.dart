// lib/pages/category_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetos/model/animals.dart';

import '../widgets/cards/animals_card.dart';

class CategoryPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryPage({super.key, required this.categoryTitle});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Animal> animals = [];

  bool _isLoading = true;

  final Map<String, String> _folderMap = {
    'Dinossauros': 'dinos',
    'Fazenda': 'farm',
    'Floresta': 'florest',
    'Pets': 'pets',
  };

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final String categoryName =
        _folderMap[widget.categoryTitle] ?? widget.categoryTitle.toLowerCase();

    // Listando os assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final List<String> allAssetPaths = manifestMap.keys.toList();

    final List<Animal> loadedAnimals = [];

    // Filtro os assets da categoria atual
    final imgPaths = allAssetPaths.where(
      (path) =>
          path.startsWith('assets/images/$categoryName') &&
          !path.contains('bg-') &&
          !path.contains('title-'),
    );

    for (var image in imgPaths) {
      // Extraindo o nome
      final fileName = image.split('/').last.split('.').first;

      // Caminho para o som
      final soundPath = 'assets/sounds/$categoryName/$fileName.mp3';

      final animalName = fileName.replaceAll(RegExp(r'[-_]'), ' ');
      loadedAnimals.add(
        Animal(name: animalName, imgPath: image, soundPath: soundPath),
      );
    }

    setState(() {
      animals = loadedAnimals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String? folderName = _folderMap[widget.categoryTitle];
    final String? bgImagePath = folderName != null
        ? 'assets/images/$folderName/bg-$folderName.png'
        : null;

    return Scaffold(
      body: Container(
        decoration: bgImagePath != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgImagePath),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),

                        child: Image.asset(
                          'assets/images/common/back-arrow.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: animals.length,
                  itemBuilder: (context, index) {
                    final animal = animals[index];
                    return AnimalCard(animal: animal);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
