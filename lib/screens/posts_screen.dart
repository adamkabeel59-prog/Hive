import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../services/favorites_service.dart';
import '../widgets/post_card.dart';

/// Posts tab. Navigation to Favorites lives in the bottom NavigationBar
/// (see HomeShell), so this screen has no AppBar favorites action.
class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _service = PostService();
  final FavoritesService _favorites = FavoritesService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _service.getPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _service.getPosts();
    });
    await _postsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          } else if (snapshot.hasError) {
            return _ErrorState(message: '${snapshot.error}', onRetry: _refresh);
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  // The star rebuilds whenever favoritesBox changes, so tapping
                  // it updates immediately.
                  return ValueListenableBuilder(
                    valueListenable: Hive.box<Post>(FavoritesService.boxName)
                        .listenable(),
                    builder: (context, Box<Post> box, _) {
                      return PostCard(
                        post: post,
                        isFavorite: _favorites.isFavorite(post.id),
                        onToggleFavorite: () => _favorites.toggleFavorite(post),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading posts…', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 60, color: Colors.grey[500]),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
