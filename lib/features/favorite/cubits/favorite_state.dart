import 'package:shopping_app/features/favorite/models/favorite_model.dart';

abstract class FavoritesState {
  final List<FavoriteModel> favorites;
  
  const FavoritesState(this.favorites);
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial() : super(const []);
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(super.favorites);
}

class FavoriteAdded extends FavoritesState {
  final String message;
  
  const FavoriteAdded(super.favorites, this.message);
}

class FavoriteRemoved extends FavoritesState {
  final String message;
  
  const FavoriteRemoved(super.favorites, this.message);
}