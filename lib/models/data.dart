import 'package:hive/hive.dart';

part 'data.g.dart';

/// Part 1 (Hive Basics) practice model.
@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  String name;

  @HiveField(1)
  String id;

  Data({required this.name, required this.id});
}
