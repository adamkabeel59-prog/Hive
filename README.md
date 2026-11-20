# Hive Posts App — v2 (Redesigned UI)

An **alternative visual design** of the Section 5 Hive lab. The Hive logic,
offline behavior, and Favorites feature are identical to v1 and satisfy every
PDF requirement — only the **UI** differs.

## What's different from v1

| Aspect | v1 | v2 (this project) |
|--------|----|-------------------|
| Theme color | Indigo | **Teal** (seed `#00897B`) |
| Favorites navigation | AppBar button → pushed route | **Bottom `NavigationBar`** (Posts / Favorites tabs) with a live count badge |
| Post card | `ListTile` (avatar + title + body + star) | Custom card: **left accent stripe** (color by userId), id badge, title, 2-line body, **"User N" chip**, tonal star button |
| Empty state | Grey outlined star | Amber circular badge + star |
| Loading | Spinner | Spinner + "Loading posts…" |
| Posts screen hosting | Single screen | Lives inside a bottom-nav shell (`home_shell.dart`), kept alive via `IndexedStack` |

> Note on the lab requirement: the PDF asks for an AppBar button to open
> Favorites. v2 instead uses a bottom `NavigationBar` tab, which is a common and
> arguably cleaner navigation pattern and still "opens the Favorites screen." If
> your instructor requires the AppBar-button form specifically, submit **v1**
> (which implements it literally); v2 is the design variant.

## Requirements still satisfied

- API-first, Hive-fallback `getPosts()` with offline cache ✅
- Loading / error / data states + pull-to-refresh ✅
- Separate `favoritesBox`, `post.id` key, **copy-on-save** (HiveObject single-box rule) ✅
- Filled `Icons.star` vs outlined `Icons.star_border` ✅
- Immediate UI updates via `ValueListenableBuilder` ✅
- Favorites screen + "No favorites yet" empty state ✅
- Offline persistence across restarts ✅

## Structure

```
lib/
├── main.dart                 # teal Material 3 theme
├── models/                   # data.dart(+.g), post_model.dart(+.g)
├── services/                 # post_service.dart, favorites_service.dart
├── screens/
│   ├── home_shell.dart       # NEW: bottom NavigationBar shell
│   ├── posts_screen.dart     # redesigned, no AppBar favorites action
│   └── favorites_screen.dart # redesigned
└── widgets/
    └── post_card.dart        # NEW shared redesigned card
test/
├── favorites_service_test.dart
└── post_cache_test.dart
```

## Run

```bash
cd hive_posts_app_v2
flutter create . --project-name hive_posts_app_v2   # add platform scaffolding
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter run
```

> `flutter create .` overwrites `pubspec.yaml`, `lib/main.dart`, and `test/` —
> see v1's README for the safe scaffold-then-copy approach if you need it.

## License

Educational lab project — Fall 2026, Section 5.
