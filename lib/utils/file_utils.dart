import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class FileUtils {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
    return null;
  }

  static Future<File?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        return File(photo.path);
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
    return null;
  }

  static Future<File?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      print('Error picking file: $e');
    }
    return null;
  }

  static String getFileType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    return mimeType ?? 'application/octet-stream';
  }

  static String getFileName(String filePath) {
    return path.basename(filePath);
  }

  static String getFileExtension(String filePath) {
    return path.extension(filePath).toLowerCase();
  }

  static bool isImageFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext);
  }

  static bool isVideoFile(String filePath) {
    final ext = getFileExtension(filePath);
    return ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv'].contains(ext);
  }

  static Future<String> getFileSize(File file) async {
    final size = await file.length();
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}