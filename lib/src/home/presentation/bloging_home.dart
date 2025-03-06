import 'package:autoformsai_blogs/core/app_logger.dart';
import 'package:autoformsai_blogs/src/home/presentation/blog_search_delegate.dart';
import 'package:autoformsai_blogs/src/home/widgets/home_body.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BlogHomePage extends StatelessWidget {
  const BlogHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Matches Tailwind's bg-white
        elevation: 1,
        title: Row(
          children:  [
            InkWell(
              onTap: (){
                try{
                  launchUrlString("https://autoformsai.com");
                }catch(e){
                  AppLogger.e(e);
                }
              },
              child: Text(
                "AutoFormsAI",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
        actions: [
          InkWell(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: BlogSearchDelegate(),
                );
              },
              child: Icon(Icons.search, color: Colors.black)),
          SizedBox(width: 15),
          // Icon(Icons.wb_sunny_outlined, color: Colors.black),
          // SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: HomeBody(),
      ),
    );
  }
}
