import 'package:hive/hive.dart';
import '../models/post_model.dart';

/// Manages the separate `favoritesBox`, keyed by post id.
class FavoritesService {
  static const String boxName = 'favoritesBox';

  Box<Post> get _box => Hive.box<Post>(boxName);

  /// Add if missing, remove if present. Stores a *copy* (HiveObject can only
  /// live in one box at a time).
  Future<void> toggleFavorite(Post post) async {
    if (_box.containsKey(post.id)) {
      await _box.delete(post.id);
    } else {
      await _box.put(post.id, post.copy());
    }
  }

  bool isFavorite(int id) => _box.containsKey(id);

  List<Post> getFavorites() => _box.values.toList();
}
