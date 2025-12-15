class Note {
  final int? id;
  final String recipeId;
  final String content;

  Note({this.id, required this.recipeId, required this.content});

  // Mengubah Objek Note menjadi Map (untuk disimpan ke SQL)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'content': content,
    };
  }
}