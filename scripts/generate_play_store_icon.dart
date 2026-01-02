import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  // Read the source image (app icon source)
  final sourceFile = File('Assests/images/farmersmarket-1.png');
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

  // Google Play Store requires 512x512 icon
  const iconSize = 512;

  // Resize the image to 512x512 (cover mode - maintains aspect ratio, may crop)
  // Calculate aspect ratios
  final sourceAspect = sourceImage.width / sourceImage.height;
  
  int resizeWidth, resizeHeight;
  if (sourceAspect > 1.0) {
    // Source is wider - fit to height, then crop width
    resizeHeight = iconSize;
    resizeWidth = (iconSize * sourceAspect).round();
  } else {
    // Source is taller or square - fit to width, then crop height
    resizeWidth = iconSize;
    resizeHeight = (iconSize / sourceAspect).round();
  }
  
  // Resize maintaining aspect ratio
  var resizedImage = img.copyResize(
    sourceImage,
    width: resizeWidth,
    height: resizeHeight,
    interpolation: img.Interpolation.cubic,
  );
  
  // Crop to exact icon size (center crop)
  final startX = ((resizedImage.width - iconSize) / 2).round();
  final startY = ((resizedImage.height - iconSize) / 2).round();
  resizedImage = img.copyCrop(
    resizedImage,
    x: startX.clamp(0, resizedImage.width - iconSize),
    y: startY.clamp(0, resizedImage.height - iconSize),
    width: iconSize,
    height: iconSize,
  );

  // Create output directory if it doesn't exist
  final outputDir = Directory('Assests/play_store');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Save the 512x512 icon
  final outputFile = File('Assests/play_store/app_icon_512x512.png');
  final outputBytes = img.encodePng(resizedImage);
  await outputFile.writeAsBytes(outputBytes);

  print('✅ Play Store icon (512x512) generated successfully!');
  print('📁 Location: ${outputFile.path}');
  print('📐 Size: ${iconSize}x${iconSize} pixels');
  print('');
  print('Use this file when uploading your app to Google Play Console.');
}

