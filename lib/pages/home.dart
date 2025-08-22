import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../widgets/cards/home_card.dart';
import 'category_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> cardData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final List<String> assetPaths = await getAssetListFromRootBundle();

    final Map<String, List<String>> categoryAssets = {};

    for (var path in assetPaths) {
      if (path.startsWith('assets/images/')) {
        final parts = path.split('/');
        if (parts.length >= 3) {
          final categoryName = parts[2];
          if (categoryName.isNotEmpty) {
            if (!categoryAssets.containsKey(categoryName)) {
              categoryAssets[categoryName] = [];
            }
            categoryAssets[categoryName]!.add(path);
          }
        }
      }
    }

    final List<Map<String, String>> loadedData = [];
    late Map<String, String> translations = {
      'dinos': 'Dinossauros',
      'farm': 'Fazenda',
      'florest': 'Floresta',
      'pets': 'Pets',
    };

    for (final categoryName in categoryAssets.keys) {
      final categoryFiles = categoryAssets[categoryName]!;
      final bgImage = categoryFiles.firstWhere(
        (path) => path.contains('bg-'),
        orElse: () => '',
      );
      final titleImage = categoryFiles.firstWhere(
        (path) => path.contains('title-'),
        orElse: () => '',
      );
      final translatedTitle = translations[categoryName] ?? categoryName;

      if (bgImage.isNotEmpty && titleImage.isNotEmpty) {
        loadedData.add({
          'title': translatedTitle,
          'imagePath': bgImage,
          'titleImagePath': titleImage,
        });
      }
    }

    setState(() {
      cardData = loadedData;
      _isLoading = false;
    });
  }

  Future<List<String>> getAssetListFromRootBundle() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    return manifestMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/common/app-bg.png'),

                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: SizedBox(
                    height: 150.0,
                    child: Image.asset(
                      'assets/images/common/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: cardData.length,
                  itemBuilder: (context, index) {
                    final item = cardData[index];
                    final String title = item['title']!;
                    final String imagePath = item['imagePath']!;
                    final String titleImagePath = item['titleImagePath']!;

                    return HomeCard(
                      titleImagePath: titleImagePath,
                      imagePath: imagePath,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryPage(categoryTitle: title),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
