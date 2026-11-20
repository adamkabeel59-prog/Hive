import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_posts_app_v2/models/post_model.dart';
import 'package:hive_posts_app_v2/services/favorites_service.dart';

void main() {
  late Directory tempDir;
  final service = FavoritesService();

  Post samplePost(int id) =>
      Post(id: id, title: 'Title $id', body: 'Body $id', userId: 1);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_fav_test_v2');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PostAdapter());
    }
    await Hive.openBox<Post>(FavoritesService.boxName);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('toggleFavorite adds then removes', () async {
    final post = samplePost(1);
    expect(service.isFavorite(1), isFalse);
    await service.toggleFavorite(post);
    expect(service.isFavorite(1), isTrue);
    await service.toggleFavorite(post);
    expect(service.isFavorite(1), isFalse);
  });

  test('stored favorite is an independent copy', () async {
    final postsBox = await Hive.openBox<Post>('postsBox');
    final original = samplePost(7);
    await postsBox.add(original);
    await service.toggleFavorite(original);
    await postsBox.clear();
    expect(service.isFavorite(7), isTrue);
    expect(service.getFavorites().length, 1);
  });

  test('favorites survive close/reopen (restart)', () async {
    await service.toggleFavorite(samplePost(9));
    await Hive.box<Post>(FavoritesService.boxName).close();
    await Hive.openBox<Post>(FavoritesService.boxName);
    expect(service.isFavorite(9), isTrue);
  });
}
