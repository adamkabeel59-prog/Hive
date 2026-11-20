import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';
import 'posts_screen.dart';
import 'favorites_screen.dart';

/// Hosts the two main views behind a bottom [NavigationBar]. This is the main
/// visual difference from v1 (which used an AppBar button + pushed route).
///
/// IndexedStack keeps both views alive so switching tabs preserves scroll and
/// the posts Future is not re-fetched.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [PostsScreen(), FavoritesScreen()],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: Hive.box<Post>(FavoritesService.boxName).listenable(),
        builder: (context, Box<Post> box, _) {
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'Posts',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: box.isNotEmpty,
                  label: Text('${box.length}'),
                  child: const Icon(Icons.star_border),
                ),
                selectedIcon: Badge(
                  isLabelVisible: box.isNotEmpty,
                  label: Text('${box.length}'),
                  child: const Icon(Icons.star),
                ),
                label: 'Favorites',
              ),
            ],
          );
        },
      ),
    );
  }
}
