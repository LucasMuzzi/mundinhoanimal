// lib/pages/category_page.dart
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryTitle;

  const CategoryPage({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: Center(
        child: Text(
          'Conteúdo para a categoria: $categoryTitle',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
