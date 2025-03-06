import 'package:autoformsai_blogs/core/app_widgets/app_photo_view.dart';
import 'package:flutter/material.dart';

class AppImageWidget extends StatelessWidget {
  const AppImageWidget({super.key, this.height, this.width, required this.imageUrl, this.fit, this.radius,
  this.useDefaultImageSize,});

  final double? height;
  final double? width;
  final String? imageUrl;
  final BoxFit? fit;
  final double? radius;
  final bool? useDefaultImageSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (imageUrl != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppPhotoView(imageUrl: imageUrl!), fullscreenDialog: true),
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 20),
        child: (imageUrl != null)
            ? Image.network(
                imageUrl!,
                fit: fit ?? BoxFit.cover,
                height: height ?? ((useDefaultImageSize ?? false) ? null : 210),
                width: width ?? double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Container(
                    height: height ?? 200,
                    width: width ?? double.infinity,
                    color: Colors.grey.shade200,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/image_icon.png',
                    fit: BoxFit.cover,
                    height: height ?? 200,
                    width: width ?? double.infinity,
                  );
                },
              )
            : Image.asset(
                'assets/image_icon.png',
                fit: BoxFit.cover,
                height: height ?? 200,
                width: width ?? double.infinity,
              ),
      ),
    );
  }
}
