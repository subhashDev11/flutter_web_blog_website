import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class AppPhotoView extends StatelessWidget {
  const AppPhotoView({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Photo'),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            25,
          ),
          child: PhotoView(
            imageProvider: NetworkImage(
              imageUrl,
            ),
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/image_icon.png',
            ),
          ),
        ),
      ),
    );
  }
}
