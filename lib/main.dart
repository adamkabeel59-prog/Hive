import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/post_model.dart';
import 'screens/home_shell.dart';

Future<void> main() async {
  // Order: initialise, register adapters, open boxes, then run.
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());

  await Hive.openBox<Post>('postsBox');
  await Hive.openBox<Post>('favoritesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00897B), // teal
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Posts',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF3F6F5),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: false,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const HomeShell(),
    );
  }
}
