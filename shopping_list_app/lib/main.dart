import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'models/shopping_item.dart';
import 'services/storage_service.dart';

const uuid = Uuid();
final StorageService _storageService = StorageService();

void main() {
  runApp(const ShoppingListApp());
}

class ShoppingListApp extends StatelessWidget {
  const ShoppingListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      // 1. MENGHAPUS TEKS DEBUG
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 3. WARNA UI MENARIK: Menggunakan skema warna Teal/Hijau Tosca
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black87,
        ),
      ),
      home: const ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final loadedItems = await _storageService.loadItems();
    setState(() {
      _items = loadedItems;
      _isLoading = false;
    });
  }

  void _saveItems() {
    _storageService.saveItems(_items);
  }

  void _addItem(ShoppingItem item) {
    setState(() {
      _items.add(item);
      _saveItems();
    });
  }

  // Fungsi baru untuk MENGHAPUS item
  void _deleteItem(ShoppingItem item) {
    setState(() {
      _items.removeWhere((i) => i.id == item.id);
      _saveItems();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} berhasil dihapus.'),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  // Fungsi baru untuk MENGEDIT item
  void _editItem(ShoppingItem item) {
    _showAddItemDialog(context, itemToEdit: item);
  }

  void _toggleItemStatus(ShoppingItem item) {
    setState(() {
      item.isCompleted = !item.isCompleted;
      _saveItems();
    });
  }

  int _calculateTotal(bool isCompleted) {
    return _items.where((item) => item.isCompleted == isCompleted).length;
  }
  
  // Dialog untuk Menambah/Mengedit Item
  Future<void> _showAddItemDialog(BuildContext context, {ShoppingItem? itemToEdit}) async {
    final bool isEditing = itemToEdit != null;
    final TextEditingController nameController = TextEditingController(text: isEditing ? itemToEdit!.name : '');
    final TextEditingController quantityController = TextEditingController(text: isEditing ? itemToEdit!.quantity.toString() : '1');
    String? selectedCategory = isEditing ? itemToEdit!.category : 'Makanan';

    final List<String> categories = ['Makanan', 'Minuman', 'Elektronik', 'Kebutuhan Rumah', 'Lainnya'];
    
    // State lokal untuk Dropdown di Dialog
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Item' : 'Tambah Item Baru'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama Item'),
                    ),
                    TextField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Jumlah'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Kategori'),
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setStateDialog(() { // Menggunakan setStateDialog untuk mengubah state lokal di dialog
                          selectedCategory = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(isEditing ? 'Simpan' : 'Tambah'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && quantityController.text.isNotEmpty) {
                      final quantity = int.tryParse(quantityController.text) ?? 1;
                      
                      if (isEditing) {
                        // Logika Simpan Edit
                        setState(() { // Menggunakan setState global
                          itemToEdit!.name = nameController.text;
                          itemToEdit.quantity = quantity;
                          itemToEdit.category = selectedCategory ?? 'Lainnya';
                          _saveItems();
                        });
                      } else {
                        // Logika Tambah Baru
                        final newItem = ShoppingItem(
                          id: uuid.v4(),
                          name: nameController.text,
                          quantity: quantity,
                          category: selectedCategory ?? 'Lainnya',
                        );
                        _addItem(newItem);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final completedCount = _calculateTotal(true);
    final pendingCount = _calculateTotal(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛒 Daftar Belanja', style: TextStyle(color: Colors.white)),
        // Bagian Total Item di AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCountChip(context, 'Sudah Dibeli', completedCount, Colors.greenAccent[700]!),
                _buildCountChip(context, 'Belum Dibeli', pendingCount, Colors.orangeAccent[700]!),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)))
          : _items.isEmpty
            ? const Center(child: Text('Daftar belanja kosong. Silakan tambahkan item!', style: TextStyle(fontSize: 16, color: Colors.grey)))
            : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildShoppingItemTile(item);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget Pembantu untuk Chip Total Item
  Widget _buildCountChip(BuildContext context, String title, int count, Color color) {
    return Chip(
      label: Text('$title: $count', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: color,
    );
  }

  // Widget Pembantu untuk ListTile Item Belanja
  Widget _buildShoppingItemTile(ShoppingItem item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: item.isCompleted ? Colors.green.shade200 : Colors.teal.shade100, width: 1),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          activeColor: Colors.teal,
          onChanged: (val) {
            _toggleItemStatus(item);
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: item.isCompleted ? Colors.grey.shade600 : Colors.black,
            decoration: item.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          '${item.category} (${item.quantity} unit)',
          style: TextStyle(
            color: item.isCompleted ? Colors.grey : Colors.teal.shade700,
          ),
        ),
        // 2. MENAMBAHKAN ICON EDIT DAN HAPUS
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _editItem(item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _deleteItem(item),
            ),
          ],
        ),
      ),
    );
  }
}