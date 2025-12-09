class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  bool isDone;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.isDone = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isDone': isDone,
    };
  }

  // Untuk update lebih mudah
  Note copyWith({
    String? title,
    String? content,
    bool? isDone,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      isDone: isDone ?? this.isDone,
    );
  }
}
