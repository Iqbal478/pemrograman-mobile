import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';
import '../models/note_model.dart';
import '../db/database_helper.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Note> _currentNotes = [];
  bool _isLoading = false;
  String _error = '';

  List<Recipe> get recipes => _recipes;
  List<Note> get currentNotes => _currentNotes;
  bool get isLoading => _isLoading;
  String get error => _error;

  // 1. AMBIL DATA API (Berdasarkan Kategori)
  Future<void> fetchRecipes({String category = 'Seafood'}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        _recipes = meals.map((json) => Recipe.fromJson(json)).toList();
      } else {
        _error = 'Gagal mengambil data server';
      }
    } catch (e) {
      _error = 'Cek koneksi internet anda';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. FITUR PENCARIAN (SEARCH) - BARU DITAMBAHKAN ✅
  Future<void> searchRecipes(String query) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Menggunakan endpoint search.php dari TheMealDB
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        
        if (meals.isEmpty) {
          _error = 'Resep tidak ditemukan';
          _recipes = [];
        } else {
          _recipes = meals.map((json) => Recipe.fromJson(json)).toList();
        }
      } else {
        _error = 'Gagal mencari data';
      }
    } catch (e) {
      _error = 'Cek koneksi internet anda';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 3. READ: Ambil Catatan dari Database Lokal
  Future<void> loadNotes(String recipeId) async {
    _currentNotes = await DatabaseHelper.instance.readNotes(recipeId);
    notifyListeners();
  }

  // 4. CREATE: Tambah Catatan Baru
  Future<void> addNote(String recipeId, String content) async {
    final newNote = Note(recipeId: recipeId, content: content);
    await DatabaseHelper.instance.create(newNote);
    await loadNotes(recipeId);
  }

  // 5. UPDATE: Edit Catatan
  Future<void> updateNote(Note note) async {
    await DatabaseHelper.instance.update(note);
    await loadNotes(note.recipeId);
  }

  // 6. DELETE: Hapus Catatan
  Future<void> deleteNote(int id, String recipeId) async {
    await DatabaseHelper.instance.delete(id);
    await loadNotes(recipeId);
  }
}