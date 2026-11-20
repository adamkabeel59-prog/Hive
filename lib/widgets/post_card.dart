import 'package:flutter/material.dart';
import '../models/post_model.dart';

/// Redesigned post card (v2 look):
///  - a colored accent stripe on the left (color derived from userId),
///  - a circular id badge,
///  - title + 2-line body + a "User N" chip,
///  - a tonal star button (filled when favorite, outlined otherwise).
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Post post;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  static const List<Color> _accents = [
    Color(0xFF00897B), // teal
    Color(0xFF3949AB), // indigo
    Color(0xFFD81B60), // pink
    Color(0xFFF9A825), // amber
    Color(0xFF6D4C41), // brown
    Color(0xFF00ACC1), // cyan
  ];

  Color get _accent => _accents[post.userId % _accents.length];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent stripe
            Container(width: 6, color: _accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _accent.withOpacity(0.15),
                      child: Text(
                        '${post.id}',
                        style: TextStyle(
                          color: _accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _UserChip(userId: post.userId, color: _accent),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip:
                          isFavorite ? 'Remove favorite' : 'Add favorite',
                      isSelected: isFavorite,
                      onPressed: onToggleFavorite,
                      style: IconButton.styleFrom(
                        backgroundColor: isFavorite
                            ? Colors.amber.withOpacity(0.18)
                            : Colors.grey.withOpacity(0.10),
                      ),
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber[800] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserChip extends StatelessWidget {
  const _UserChip({required this.userId, required this.color});

  final int userId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            'User $userId',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
