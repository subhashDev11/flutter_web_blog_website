import 'package:autoformsai_blogs/core/get_it_locator.dart';
import 'package:autoformsai_blogs/core/service/loading_service.dart';
import 'package:autoformsai_blogs/data/data_repository.dart';
import 'package:autoformsai_blogs/data/model/blog_model.dart';
import 'package:autoformsai_blogs/data/model/category_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_state.dart';

class BlogCubit extends Cubit<BlogState> {
  BlogCubit() : super(BlogState.initial());

  Future<void> init() async {
    try {
      final fetchedCategories = await DataRepository.instance.fetchAllCategories();
      final allPosts = await DataRepository.instance.fetchBlogPosts();
      var allCate = CategoryModel(
        categoryName: 'All',
        categoryId: 'all-8999688',
        tags: [],
      );
      fetchedCategories.insert(
        0,
        allCate,
      );
      emit(state.copyWith(
        categories: fetchedCategories,
        posts: allPosts,
        initialized: true,
        selectedCategory: allCate,
      ));
      fetchLatestPost();
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  Future<void> onCategoryTabChange(CategoryModel category) async {
    if (category == state.selectedCategory) return;
    getIt<EasyLoadingService>().show();
    final categoryPost = await (category.categoryName == 'All'
        ? DataRepository.instance.fetchBlogPosts()
        : DataRepository.instance.fetchBlogPostsByCategory(category.categoryName));
    getIt<EasyLoadingService>().hide();
    emit(state.copyWith(
      selectedCategory: category,
      posts: categoryPost,
    ));
  }

  Future<void> fetchLatestPost() async {
    final latestPosts = await DataRepository.instance.fetchRecentBlogPosts();
    emit(state.copyWith(
      latestPosts: latestPosts,
    ));
    if(state.latestPosts==null){
      emit(state.copyWith(
        latestPosts: [],
      ));
    }
  }
}
