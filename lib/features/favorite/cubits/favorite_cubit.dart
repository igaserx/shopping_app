import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/features/favorite/cubits/favorite_state.dart';
import 'package:shopping_app/features/favorite/models/favorite_model.dart';
import 'dart:convert';

import 'package:shopping_app/features/products/domain/entities/product_entity.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  static const String _favoritesKey = 'favorites';
  
  FavoritesCubit() : super(const FavoritesInitial()) {
    loadFavorites();
  }


  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      
      final favorites = favoritesJson
          .map((json) => FavoriteModel.fromMap(jsonDecode(json)))
          .toList();
      
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(const FavoritesLoaded([]));
    }
  }


  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = state.favorites
          .map((favorite) => jsonEncode(favorite.toMap()))
          .toList();
      
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      emit(const FavoritesLoaded([]));
    }
  }


  bool isFavorite(ProductEntity product) {
    return state.favorites.any((favorite) => 
        favorite.product.id == product.id || 
        favorite.product.title == product.title);
  }

  
  Future<void> addToFavorites(ProductEntity product) async {
    if (isFavorite(product)) return;
    
    final newFavorite = FavoriteModel(
      product: product,
      addedAt: DateTime.now(),
    );
    
    final updatedFavorites = List<FavoriteModel>.from(state.favorites)
      ..add(newFavorite);
    
    emit(FavoriteAdded(updatedFavorites, '${product.title} added to favorites!'));
    await _saveFavorites();
  }

  
  Future<void> removeFromFavorites(ProductEntity product) async {
    final updatedFavorites = state.favorites
        .where((favorite) => 
            favorite.product.id != product.id && 
            favorite.product.title != product.title)
        .toList();
    
    emit(FavoriteRemoved(updatedFavorites, '${product.title} removed from favorites'));
    await _saveFavorites();
  }

  
  Future<void> toggleFavorite(ProductEntity product) async {
    if (isFavorite(product)) {
      await removeFromFavorites(product);
    } else {
      await addToFavorites(product);
    }
  }

  
  Future<void> clearFavorites() async {
    emit(const FavoritesLoaded([]));
    await _saveFavorites();
  }

  
  int get favoritesCount => state.favorites.length;

  
  List<ProductEntity> get favoriteProducts => 
      state.favorites.map((favorite) => favorite.product).toList();
}