import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';
import '../widgets/post_card.dart';

/// Favorites tab. Rebuilds automatically when favoritesBox changes.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Post>(FavoritesService.boxName).listenable(),
        builder: (context, Box<Post> box, _) {
          final posts = box.values.toList();

          if (posts.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                isFavorite: true,
                onToggleFavorite: () => favorites.toggleFavorite(post),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.star_border, size: 56, color: Colors.amber[700]),
          ),
          const SizedBox(height: 16),
          const Text(
            'No favorites yet',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the star on a post to save it here.',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
