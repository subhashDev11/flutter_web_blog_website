import 'package:autoformsai_blogs/core/app_router.dart';
import 'package:autoformsai_blogs/core/app_widgets/post_card.dart';
import 'package:autoformsai_blogs/core/layout_components/web_app_responsive_widget.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogSearchDelegate extends SearchDelegate {
  // Clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  // Close the search delegate
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Show results based on the search query
  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<BlogCubit, BlogState>(
      builder: (
        _,
        state,
      ) {
        final results = state.posts.where((post) => post.title.toLowerCase().contains(query.toLowerCase())).toList();
        return WepAppResponsiveWidget(
          child: results.isNotEmpty
              ? ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final post = results[index];
                    return InkWell(
                      onTap: () {
                        context.go(
                          getBlogDetailRoute(post),
                          extra: post,
                        );
                      },
                      child: BlogPostCard(
                        imageUrl: post.image,
                        title: post.title,
                        description: "Created by ${post.postedBy}",
                        date: post.postTimeAgo ?? "",
                        category: post.category.categoryName,
                        readTime: post.calculateReadTime,
                        onReadMore: () {
                          context.go(
                            getBlogDetailRoute(post),
                            extra: post,
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(child: Text("No results found")),
        );
      },
    );
  }

  // Show suggestions as user types
  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<BlogCubit, BlogState>(
      builder: (
        _,
        state,
      ) {
        final suggestions =
            state.posts.where((post) => post.title.toLowerCase().contains(query.toLowerCase())).toList();

        return WepAppResponsiveWidget(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final post = suggestions[index];
              return InkWell(
                onTap: () {
                  context.go(
                    getBlogDetailRoute(post),
                    extra: post,
                  );
                },
                child: BlogPostCard(
                  imageUrl: post.image,
                  title: post.title,
                  description: "Created by ${post.postedBy}",
                  date: post.postTimeAgo ?? "",
                  category: post.category.categoryName,
                  readTime: post.calculateReadTime,
                  onReadMore: () {
                    context.go(
                      getBlogDetailRoute(post),
                      extra: post,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
