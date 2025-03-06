import 'dart:convert';
import 'package:autoformsai_blogs/core/app_logger.dart';
import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/data/data_repository.dart';
import 'package:autoformsai_blogs/data/model/blog_model.dart';
import 'package:autoformsai_blogs/data/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class AdminHomeProvider extends ChangeNotifier {
  CategoryModel? _selectedCategory;

  CategoryModel? get selectedCategory => _selectedCategory;

  Uint8List? _selectedImage;

  Uint8List? get selectedImage => _selectedImage;

  XFile? _selectedFile;

  XFile? get selectedFile => _selectedFile;

  void onCategorySelected(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> galleryImagePicker() async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (file != null) {
      _selectedImage = await file.readAsBytes();
      _selectedFile = file;
      notifyListeners();
    }
  }

  Future<void> onPostSubmit(BuildContext context,
      {required String title, required String description, required CategoryModel category}) async {
    if (selectedFile == null) return;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    String postId = 'post-$timestamp';
    getIt<EasyLoadingService>().show();
    String? imageUrl = await uploadFileToPinata(
      selectedFile!,
      postId: postId,
    );
    bool res = await DataRepository.instance.addPosts(
      BlogPostModel(
        title: title,
        description: description,
        postedBy: "Subhash Chandra Shukla",
        postedAt: timestamp,
        category: category,
        image: imageUrl,
        id: postId,
      ),
    );
    getIt<EasyLoadingService>().hide();
    if (res) {
      getIt<EasyLoadingService>().showToast(
        content: 'Post created successfully',
      );
      Navigator.of(context).pop();
    }
  }

  // Future<String?> uploadFile(String postId) async {
  //   if (_selectedImage != null) {
  //     String fileName = "$postId/${path.extension(selectedImageName ?? "test.png")}";
  //     getIt<EasyLoadingService>().show();
  //     try {
  //       final storageRef = FirebaseStorage.instance.ref().child("blog-assets/$fileName");
  //       await storageRef.putData(_selectedImage!);
  //       final downloadUrl = await storageRef.getDownloadURL();
  //       getIt<EasyLoadingService>().hide();
  //       AppLogger.i("File URL - $downloadUrl");
  //       return downloadUrl;
  //     } catch (e) {
  //       AppLogger.e("file upload error - $e");
  //       getIt<EasyLoadingService>().hide();
  //       getIt<EasyLoadingService>().showToast(
  //         content: "Failed to upload: $e",
  //       );
  //     }
  //   }
  //   return null;
  // }

  Future<bool> isValidFileSize(XFile? file) async {
    if (file == null) return false;
    const num maxFileSizeInBytes = 0.5 * 1024 * 1024; // 7 MB in bytes
    try {
      int fileSize = await file.length();
      if (fileSize > maxFileSizeInBytes) {
        AppLogger.i("File is too large. Maximum allowed size is 7 MB.");
        getIt<EasyLoadingService>().showToast(
          content: "File is too large. Maximum allowed size is 500 KB.",
        );
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadFileToPinata(XFile file, {required String postId}) async {
    const String pinataApiKey = '7c85f8d2455414453746';
    const String pinataSecretApiKey = 'ed09981ae39612b0091940785daab9228935be010fb09d37a9b47444f7d88d91';
    const String pinataUrl = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

    try {
      String fName = path.basename(file.path);
      var request = http.MultipartRequest('POST', Uri.parse(pinataUrl))
        ..headers.addAll({
          'pinata_api_key': pinataApiKey,
          'pinata_secret_api_key': pinataSecretApiKey,
        })
        ..files.add(http.MultipartFile.fromBytes('file', _selectedImage!, filename: "$postId--$fName"));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData.body);
        final downloadUrl = 'https://gateway.pinata.cloud/ipfs/${jsonResponse['IpfsHash']}';
        AppLogger.i("uploaded file URL - $downloadUrl");
        return downloadUrl;
      } else {
        AppLogger.e('Failed to upload file: ${responseData.body}');
      }
    } catch (e) {
      AppLogger.e('Error uploading file: $e');
    }
    return null;
  }
}
