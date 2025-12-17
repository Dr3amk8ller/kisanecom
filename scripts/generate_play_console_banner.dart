import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  // Read the source image
  final sourceFile = File('Assests/images/294949024_460187556114448_3878388641743438730_n.jpg');
  if (!await sourceFile.exists()) {
    print('Error: Source image not found at ${sourceFile.path}');
    exit(1);
  }

  // Read and decode the image
  final sourceBytes = await sourceFile.readAsBytes();
  final sourceImage = img.decodeImage(sourceBytes);
  
  if (sourceImage == null) {
    print('Error: Could not decode source image');
    exit(1);
  }

  // Play Console banner size is 1024x500 pixels
  const bannerWidth = 1024;
  const bannerHeight = 500;

  // Resize the image to fit the banner size (cover mode - maintains aspect ratio, may crop)
  // Calculate aspect ratios
  final sourceAspect = sourceImage.width / sourceImage.height;
  final bannerAspect = bannerWidth / bannerHeight;
  
  int resizeWidth, resizeHeight;
  if (sourceAspect > bannerAspect) {
    // Source is wider - fit to height, then crop width
    resizeHeight = bannerHeight;
    resizeWidth = (bannerHeight * sourceAspect).round();
  } else {
    // Source is taller - fit to width, then crop height
    resizeWidth = bannerWidth;
    resizeHeight = (bannerWidth / sourceAspect).round();
  }
  
  // Resize maintaining aspect ratio
  var resizedImage = img.copyResize(
    sourceImage,
    width: resizeWidth,
    height: resizeHeight,
    interpolation: img.Interpolation.cubic,
  );
  
  // Crop to exact banner size (center crop)
  final startX = ((resizedImage.width - bannerWidth) / 2).round();
  final startY = ((resizedImage.height - bannerHeight) / 2).round();
  resizedImage = img.copyCrop(
    resizedImage,
    x: startX.clamp(0, resizedImage.width - bannerWidth),
    y: startY.clamp(0, resizedImage.height - bannerHeight),
    width: bannerWidth,
    height: bannerHeight,
  );

  // Create output directory if it doesn't exist
  final outputDir = Directory('Assests/play_console');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Save the banner
  final outputFile = File('Assests/play_console/feature_graphic.png');
  final outputBytes = img.encodePng(resizedImage);
  await outputFile.writeAsBytes(outputBytes);

  print('✅ Play Console banner generated successfully!');
  print('📁 Location: ${outputFile.path}');
  print('📐 Size: ${bannerWidth}x${bannerHeight} pixels');
}

