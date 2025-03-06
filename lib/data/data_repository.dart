import 'dart:async';
import 'package:autoformsai_blogs/data/model/blog_model.dart';
import 'package:autoformsai_blogs/data/model/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataRepository {
  static final DataRepository instance = DataRepository();

  CollectionReference get postsCollection =>
      FirebaseFirestore.instance.collection("autoformsai_blogs").doc('blogs').collection(
            'posts',
          );

  CollectionReference get categoryCollection =>
      FirebaseFirestore.instance.collection("autoformsai_blogs").doc('blogs').collection('categories');

  Future<List<BlogPostModel>> fetchBlogPostsByCategory(String category) async {
    Completer<List<BlogPostModel>> completer = Completer();
    postsCollection
        .where(
          'category.categoryName',
          isGreaterThanOrEqualTo: category,
        )
        .get()
        .then((v) {
      final data = v.docs
          .map(
            (e) => BlogPostModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      completer.complete(data);
    }).onError(
      (e, s) {
        completer.complete([]);
      },
    );
    return completer.future;
  }

  Future<List<BlogPostModel>> fetchBlogPosts() async {
    Completer<List<BlogPostModel>> completer = Completer();
    postsCollection.limit(150).get().then((v) {
      final data = v.docs
          .map(
            (e) => BlogPostModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      completer.complete(data);
    }).onError(
      (e, s) {
        completer.complete([]);
      },
    );
    return completer.future;
  }

  Future<BlogPostModel?> fetchPostById(String postId) async {
    Completer<BlogPostModel?> completer = Completer();
    postsCollection
        .limit(150)
        .where(
          'id',
          isEqualTo: postId,
        )
        .get()
        .then((v) {
      final data = v.docs
          .map(
            (e) => BlogPostModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      if (data.isNotEmpty) {
        completer.complete(data.first);
      } else {
        completer.complete(null);
      }
    }).onError(
      (e, s) {
        completer.complete(null);
      },
    );
    return completer.future;
  }

  Future<List<BlogPostModel>> searchBlogPosts(String query) async {
    Completer<List<BlogPostModel>> completer = Completer();
    postsCollection
        .where(
          'title',
          isGreaterThanOrEqualTo: query,
        )
        .limit(150)
        .get()
        .then((v) {
      final data = v.docs
          .map(
            (e) => BlogPostModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      completer.complete(data);
    }).onError(
      (e, s) {
        completer.complete([]);
      },
    );
    return completer.future;
  }

  Future<List<BlogPostModel>> fetchRecentBlogPosts() async {
    Completer<List<BlogPostModel>> completer = Completer();
    postsCollection
        .orderBy(
          'postedAt',
        )
        .limit(5)
        .get()
        .then((v) {
      final data = v.docs
          .map(
            (e) => BlogPostModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      completer.complete(data);
    }).onError(
      (e, s) {
        completer.complete([]);
      },
    );
    return completer.future;
  }

  Future<bool> addPosts(BlogPostModel blogPost) async {
    Completer<bool> completer = Completer();
    postsCollection
        .add(
      blogPost.toJson(),
    )
        .then((v) {
      completer.complete(true);
    }).onError((v, s) {
      completer.complete(false);
    });
    return completer.future;
  }

  Future<bool> addCategory(CategoryModel categoryModel) async {
    Completer<bool> completer = Completer();
    categoryCollection
        .add(
      categoryModel.toMap(),
    )
        .then((v) {
      completer.complete(true);
    }).onError((v, s) {
      completer.complete(false);
    });
    return completer.future;
  }

  Future<List<CategoryModel>> fetchAllCategories() async {
    Completer<List<CategoryModel>> completer = Completer();
    categoryCollection.limit(400).get().then((v) {
      final data = v.docs
          .map(
            (e) => CategoryModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
      completer.complete(data);
    }).onError(
      (e, s) {
        completer.complete([]);
      },
    );
    return completer.future;
  }
}
