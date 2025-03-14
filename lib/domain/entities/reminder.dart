import 'package:isar/isar.dart';

part 'reminder.g.dart';
@collection
class Reminder{

  Id? isarId;

  final int id;
  final String userId;
  final String title;
  final String description;
  final String status;
  final String frequency;
  final String time;
  
  Reminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.frequency,
    required this.time,
  });
}