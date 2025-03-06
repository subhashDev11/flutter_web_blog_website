import 'package:autoformsai_blogs/core/app_router.dart';
import 'package:autoformsai_blogs/core/app_widgets/category_tab.dart';
import 'package:autoformsai_blogs/core/app_widgets/post_card.dart';
import 'package:autoformsai_blogs/core/app_widgets/recent_post_card.dart';
import 'package:autoformsai_blogs/core/layout_components/column_spacer.dart';
import 'package:autoformsai_blogs/core/layout_components/responsive_widget.dart';
import 'package:autoformsai_blogs/src/home/state/blog_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final ValueNotifier<String> _mobSegNotifier = ValueNotifier(
    'Posts',
  );

  late BlogCubit _blogCubit;

  @override
  void initState() {
    // TODO: implement initState
    _blogCubit = context.read<BlogCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget posts(BlogState state) => ColumnSpacer(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacerWidget: SizedBox(
            height: 10,
          ),
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 15,
              ),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.categories
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          _blogCubit.onCategoryTabChange(e);
                        },
                        child: CategoryTab(
                          text: e.categoryName,
                          selected: state.selectedCategory == e,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: state.posts.isEmpty
                  ? Center(
                      child: Text(
                        "No posts found in ${state.selectedCategory?.categoryName}",
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: 40,
                      ),
                      itemBuilder: (_, index) {
                        final post = state.posts[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
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
                      itemCount: state.posts.length,
                    ),
            ),
          ],
        );
    Widget latestPost(BlogState state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "Latest posts",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 10,
                ),
                child: Builder(
                  builder: (context) {
                    if (state.latestPosts==null) {
                      return ColumnSpacer(
                          spacerWidget: SizedBox(
                            height: 15,
                          ),
                          children: [
                            LatestPostShimmer(),
                            LatestPostShimmer(),
                            LatestPostShimmer(),
                            LatestPostShimmer(),
                          ]);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final e = state.latestPosts![index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 15,
                          ),
                          child: InkWell(
                            onTap: (){
                              context.go(
                                getBlogDetailRoute(e),
                                extra: e,
                              );
                            },
                            child: LatestPostWidget(
                              imageUrl: e.image,
                              title: e.title,
                              description: "",
                              date: e.postTimeAgo ?? '',
                              category: e.category.categoryName ?? '',
                              readTime: e.calculateReadTime,
                            ),
                          ),
                        );
                      },
                      itemCount: state.latestPosts!.length,
                    );
                  },
                ),
              ),
            ),
          ],
        );

    return BlocBuilder<BlogCubit, BlogState>(builder: (
      context,
      state,
    ) {
      if (!state.initialized) {
        return Center(child: CircularProgressIndicator());
      }
      return ResponsiveWidget(
        desktopView: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 8,
              child: posts(state),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: latestPost(state),
            ),
          ],
        ),
        mobileView: ValueListenableBuilder(
          valueListenable: _mobSegNotifier,
          builder: (context, selectedSeg, child) {
            return Column(
              children: [
                SegmentedButton(
                  segments: [
                    ButtonSegment(
                      value: "Posts",
                      label: Text("Posts"),
                    ),
                    ButtonSegment(
                      value: "Latest",
                      label: Text(
                        "Latest",
                      ),
                    ),
                  ],
                  onSelectionChanged: (v) {
                    _mobSegNotifier.value = v.first;
                  },
                  selected: <String>{
                    selectedSeg,
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    child: selectedSeg == "Latest" ? latestPost(state) : posts(state),
                  ),
                )
              ],
            );
          },
        ),
      );
    });
  }
}
