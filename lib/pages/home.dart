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

    final List<Map<String, String>> loadedData = [];
    final Set<String> categories = {};

    late Map<String, String> translations = {
      'dinos': 'Dinossauros',
      'farm': 'Fazenda',
      'florest': 'Floresta',
      'pets': 'Pets',
    };

    for (var path in assetPaths) {
      if (path.startsWith('assets/images/') && path.contains('bg-')) {
        final categoryName = path.split('/')[2];

        if (categoryName.isNotEmpty) {
          final String translatedTitle =
              translations[categoryName] ?? categoryName;
          categories.add(categoryName);

          loadedData.add({'title': translatedTitle, 'imagePath': path});
        }
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

                    return HomeCard(
                      imagePath: item['imagePath']!,

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
