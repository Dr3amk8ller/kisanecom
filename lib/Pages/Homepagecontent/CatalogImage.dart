import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CatalogImage extends StatelessWidget {
  final String image;

  const CatalogImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    final imageWidth = isSmallScreen ? 0.28 : (isMediumScreen ? 0.30 : 0.32);
    
    return SizedBox(
      width: MediaQuery.of(context).size.width * imageWidth,
      child: Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFF0F0F0),
            child: Icon(Icons.image_not_supported, size: isSmallScreen ? 30 : 40),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: const Color(0xFFF0F0F0),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      )
          .box
          .rounded
          .color(const Color(0xFFF0F0F0))
          .make()
          .p(isSmallScreen ? 8 : 12),
    );
  }
}
