import 'package:autoformsai_blogs/data/model/category_model.dart';
import 'package:equatable/equatable.dart';
import 'package:timeago/timeago.dart' as ago;

class BlogPostModel extends Equatable {
  final String title;
  final String description;
  final String? postedBy;
  final int postedAt;
  final CategoryModel category;
  final String? image;
  final String id;

  const BlogPostModel({
    required this.title,
    required this.description,
    required this.postedBy,
    required this.postedAt,
    required this.category,
    required this.image,
    required this.id,
  });

  BlogPostModel copyWith({
    String? title,
    String? description,
    String? postedBy,
    int? postedAt,
    CategoryModel? category,
    String? image,
    String? id,
  }) {
    return BlogPostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      postedBy: postedBy ?? this.postedBy,
      postedAt: postedAt ?? this.postedAt,
      category: category ?? this.category,
      image: image ?? this.image,
    );
  }

  // Convert the BlogPostModel instance to a map (for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'postedBy': postedBy,
      'postedAt': postedAt,
      'category': category.toMap(),
      'image': image,
      'id': id,
    };
  }

  // Create a BlogPostModel instance from a map (for JSON deserialization)
  factory BlogPostModel.fromMap(Map<String, dynamic> map) {
    return BlogPostModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      postedBy: map['postedBy'] ?? '',
      postedAt: map['postedAt'],
      category: CategoryModel.fromMap(map['category']),
      image: map['image'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String? get postTimeAgo {
    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(postedAt);
      return ago.format(
        time,
        allowFromNow: true,
      );
    } catch (e) {
      return null;
    }
  }

  // Optional: String representation for easier debugging
  @override
  String toString() {
    return 'BlogPostModel(id: $id, title: $title, description: $description, postedBy: $postedBy, postedAt: $postedAt, category: $category, image: $image)';
  }

  String get calculateReadTime {

    const int wordsPerMinute = 200;

    int wordCount = toString().trim().split(RegExp(r'\s+')).length;

    int minutes = wordCount ~/ wordsPerMinute;
    int seconds = ((wordCount % wordsPerMinute) / (wordsPerMinute / 60)).round();

    String readTime = minutes > 0
        ? "$minutes min ${seconds > 0 ? '$seconds sec' : ''} read"
        : "$seconds sec read";

    return readTime;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    title,
    description,
    postedBy,
    postedAt,
    category,
    id,
    image,
  ];
}
