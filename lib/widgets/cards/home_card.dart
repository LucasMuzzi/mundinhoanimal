import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String titleImagePath;
  final String imagePath;
  final VoidCallback? onTap;

  const HomeCard({
    super.key,
    required this.titleImagePath,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),

            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

            Center(child: Image.asset(titleImagePath, height: 100)),
          ],
        ),
      ),
    );
  }
}
