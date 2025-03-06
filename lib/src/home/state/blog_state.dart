part of 'blog_cubit.dart';

class BlogState extends Equatable{
  final List<CategoryModel> categories;
  final List<BlogPostModel> posts;
  final List<BlogPostModel>? latestPosts;
  final bool initialized;
  final CategoryModel? selectedCategory;
  final String? errorMessage;

  const BlogState({
    required this.categories,
    required this.posts,
    required this.initialized,
    required this.latestPosts,
    this.selectedCategory,
    this.errorMessage,
  });

  factory BlogState.initial() {
    return BlogState(
      categories: [],
      posts: [],
      initialized: false,
      selectedCategory: null,
      errorMessage: null,
      latestPosts: null,
    );
  }

  BlogState copyWith({
    List<CategoryModel>? categories,
    List<BlogPostModel>? posts,
    bool? initialized,
    CategoryModel? selectedCategory,
    String? errorMessage,
    List<BlogPostModel>? latestPosts,
  }) {
    return BlogState(
      latestPosts: latestPosts ?? this.latestPosts,
      categories: categories ?? this.categories,
      posts: posts ?? this.posts,
      initialized: initialized ?? this.initialized,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    categories,
    posts,
    initialized,
    selectedCategory,
    errorMessage,
    latestPosts,
  ];
}