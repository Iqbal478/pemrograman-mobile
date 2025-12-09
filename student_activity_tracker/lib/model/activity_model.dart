// lib/model/activity_model.dart

import 'dart:convert';

class Activity {
  final String id;
  final String name;
  final String category;
  final int duration; // hours
  final bool done;
  final String notes;

  Activity({
    required this.id,
    required this.name,
    required this.category,
    required this.duration,
    required this.done,
    required this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'duration': duration,
        'done': done ? 1 : 0,
        'notes': notes,
      };

  factory Activity.fromMap(Map<String, dynamic> m) => Activity(
        id: m['id'] as String,
        name: m['name'] as String,
        category: m['category'] as String,
        duration: (m['duration'] as num).toInt(),
        done: (m['done'] as int) == 1,
        notes: m['notes'] as String,
      );

  String toJson() => jsonEncode(toMap());

  factory Activity.fromJson(String s) => Activity.fromMap(jsonDecode(s));
}