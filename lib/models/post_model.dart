import 'package:hive/hive.dart';

part 'post_model.g.dart';

/// A single post from https://jsonplaceholder.typicode.com/posts.
///
/// A [HiveObject] can live in only ONE box at a time, so use [copy] before
/// storing a post into a second box (favoritesBox).
@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  /// A fresh, box-free copy. Use before saving into favoritesBox.
  Post copy() => Post(id: id, title: title, body: body, userId: userId);
}
