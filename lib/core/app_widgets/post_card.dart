import 'package:autoformsai_blogs/core/app_logger.dart';
import 'package:autoformsai_blogs/core/app_widgets/app_image_widget.dart';
import 'package:flutter/material.dart';

class BlogPostCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String date;
  final String category;
  final String readTime;
  final VoidCallback onReadMore;

  const BlogPostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.readTime,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onReadMore,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              AppImageWidget(
                imageUrl: imageUrl,
                width: 120,
                height: 120,
                radius: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(description, style: TextStyle(color: Colors.grey[800])),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(date, style: const TextStyle(color: Colors.grey)),
                        Text(readTime, style: const TextStyle(color: Colors.grey)),
                        // Text(category, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // InkWell(
                    //   onTap: onReadMore,
                    //   child: Row(
                    //     children: const [
                    //       Text(
                    //         "Read Post",
                    //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    //       ),
                    //       Icon(Icons.arrow_right, color: Colors.blue),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogPostShimmerCard extends StatelessWidget {
  const BlogPostShimmerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image_icon.png', fit: BoxFit.cover, height: 200, width: double.infinity),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Container(color: Colors.grey[300]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 20,
              child: Container(color: Colors.grey[300]),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 80,
              child: Container(color: Colors.grey[300]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 20,
                  child: Container(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
