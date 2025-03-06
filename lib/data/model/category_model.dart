import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String categoryName;
  final String categoryId;
  final List<String> tags;

  const CategoryModel({
    required this.categoryName,
    required this.categoryId,
    required this.tags,
  });

  CategoryModel copyWith({
    String? categoryName,
    String? categoryId,
    List<String>? tags,
  }) {
    return CategoryModel(categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryId': categoryId,
      'tags': tags,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'] ?? '',
      categoryId: map['categoryId'] ?? '',
      tags: List<String>.from(map['tags']),
    );
  }

  @override
  List<Object?> get props =>
      [
        categoryName,
        categoryId,
        tags,
      ];
}
