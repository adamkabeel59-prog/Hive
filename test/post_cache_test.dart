import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_posts_app_v2/models/post_model.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_cache_test_v2');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PostAdapter());
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('cached posts are retrievable after reopen (offline path)', () async {
    var box = await Hive.openBox<Post>('postsBox');
    await box.addAll([
      Post(id: 1, title: 'A', body: 'a', userId: 1),
      Post(id: 2, title: 'B', body: 'b', userId: 1),
    ]);
    await box.close();
    box = await Hive.openBox<Post>('postsBox');
    expect(box.values.length, 2);
  });

  test('refresh replaces the cache', () async {
    final box = await Hive.openBox<Post>('postsBox');
    await box.addAll([Post(id: 1, title: 'Old', body: 'o', userId: 1)]);
    await box.clear();
    await box.addAll([Post(id: 10, title: 'New', body: 'n', userId: 2)]);
    expect(box.length, 1);
    expect(box.values.first.title, 'New');
  });
}
