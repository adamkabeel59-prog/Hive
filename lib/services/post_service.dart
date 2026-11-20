import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

/// Data layer: API-first, Hive-fallback. The UI never touches http or Hive.
class PostService {
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> getPosts() async {
    var box = await Hive.openBox<Post>('postsBox');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Post> onlinePosts = data.map((e) => Post.fromJson(e)).toList();

        await box.clear();
        await box.addAll(onlinePosts);

        // ignore: avoid_print
        print('Loaded from API and cached to Hive: ${onlinePosts.length}');
        return onlinePosts;
      }
    } catch (e) {
      // ignore: avoid_print
      print('API Failed, reason: $e');
    }

    if (box.isNotEmpty) {
      // ignore: avoid_print
      print('Loaded from Hive offline: ${box.length}');
      return box.values.toList();
    } else {
      throw Exception('No Internet and No Cached Data');
    }
  }
}
