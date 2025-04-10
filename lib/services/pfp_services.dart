/*

This code is giving error rn

 */


import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_services.dart';

String? savedImagePath;
final _supabase = Supabase.instance.client;
final session = _supabase.auth.currentSession;
final authService = AuthService();
const String defaultAssetImage = "";

final userId = Supabase.instance.client.auth.currentUser?.id;


Future<File?> pickImage() async {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    selectedImage = File(image.path);
    return selectedImage;
  }
  return null;
}

Future<String> fetchDefaultProfileUrl() async {
  try {
    const String defaultImagePath =
        '';

    final String defaultUrl =
    _supabase.storage.from('profiles').getPublicUrl(defaultImagePath);

    return defaultUrl;
  } catch (e) {
    return '';
  }
}

Future<String?> saveImage(File? selectedImage) async {
  if (selectedImage == null) return null;

  try {

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String userFolderPath = '${appDir.path}/$userId/profile';

    final Directory profileDir = Directory(userFolderPath);
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final String imagePath = '$userFolderPath/profile.jpg';
    final File profileImageFile = File(imagePath);

    if (await profileImageFile.exists()) {
      await profileImageFile.delete();
      await Future.delayed(Duration(milliseconds: 200));
    }
    File newImage = await selectedImage.copy(imagePath);
    if (await newImage.exists()) {
      String savedImagePath = imagePath;
      return savedImagePath;
    }
  } catch (e) {
    //print('Error saving profile image: $e');
  }
  return null;
}

Future<void> uploadProfileImageToSupabase(File imageFile) async {
  try {
    final path = 'profiles/$userId.jpg';
    await _supabase.storage
        .from('profiles')
        .upload(path, imageFile, fileOptions: const FileOptions(upsert: true));

    //final publicUrl = _supabase.storage.from('profiles').getPublicUrl(path);
  } catch (e) {
    print('Upload error: $e');
  }
}

Future<String?> updateSaveImage() async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String userFolderPath = '${appDir.path}/$userId/profile';

    final Directory profileDir = Directory(userFolderPath);
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final String imagePath = '$userFolderPath/profile.jpg';
    final File profileImageFile = File(imagePath);

    String? supabaseImageUrl = await fetchImageFromSupabase(userId!);

    if (supabaseImageUrl != null) {
      await downloadAndSaveImage(supabaseImageUrl, imagePath);

      if (await profileImageFile.exists()) {
        return imagePath;
      } else {
        //      print("Error: Image not saved correctly.");
      }
    } else {
//      print("No image found in Supabase.");
    }
  } catch (e) {
    print('Error saving profile image: $e');
    //print('Error updating profile image: $e');
  }
  return null;
}

Future<String?> fetchImageFromSupabase(String userId) async {
  final String imagePath = 'profiles/$userId.jpg';

  try {
    final response = await _supabase.storage
        .from('profiles')
        .createSignedUrl(imagePath, 3600);

    return response;
  } catch (e) {
    //print('Error fetching image from Supabase: $e');
    return null;
  }
}

Future<void> downloadAndSaveImage(String imageUrl, String savePath) async {
  try {
    final downloadImage = await http.get(Uri.parse(imageUrl));
    if (downloadImage.statusCode == 200) {
      File file = File(savePath);
      await file.writeAsBytes(downloadImage.bodyBytes);
    } else {
      //print("Failed to download image, status code: ${downloadImage.statusCode}");
    }
  } catch (e) {
    //print('Error downloading image: $e');
  }
}

Future<String?> getSavedImagePath() async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath = '${appDir.path}/$userId/profile/profile.jpg';

    if (await File(imagePath).exists()) {
      return imagePath;
    }
  } catch (e) {
    //print('Error retrieving profile image path: $e');
  }
  return null;
}

