class ShoppingItem {
  final String id;
  String name;
  int quantity;
  String category;
  bool isCompleted; // Status: Sudah dibeli / Belum

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isCompleted = false,
  });

  // Metode untuk konversi dari JSON (untuk shared_preferences)
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      category: json['category'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Metode untuk konversi ke JSON (untuk shared_preferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isCompleted': isCompleted,
    };
  }
}