import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static const String _imagesFolder = 'clothing_images';

  /// Save image to app directory and return the path
  static Future<String?> saveImage(File imageFile) async {
    try {
      // Get the app documents directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      
      // Create images folder if it doesn't exist
      final Directory imagesDir = Directory(path.join(appDocPath, _imagesFolder));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Generate unique filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(imageFile.path);
      final String fileName = 'clothing_$timestamp$extension';
      final String newPath = path.join(imagesDir.path, fileName);
      
      // Copy file to new location
      final File newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  /// Delete image file
  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// Check if image file exists
  static Future<bool> imageExists(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      return await imageFile.exists();
    } catch (e) {
      return false;
    }
  }
}