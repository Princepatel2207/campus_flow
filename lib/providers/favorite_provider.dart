import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  // userId -> set of procedureIds
  final Map<String, Set<String>> _favorites = {};

  Set<String> _getUserFavorites(String userId) {
    return _favorites.putIfAbsent(
      userId,
          () => <String>{},
    );
  }

  bool isFavorite({
    required String userId,
    required String procedureId,
  }) {
    final favorites = _favorites[userId];

    if (favorites == null) {
      return false;
    }

    return favorites.contains(procedureId);
  }

  void toggleFavorite({
    required String userId,
    required String procedureId,
  }) {
    final favorites = _getUserFavorites(userId);

    if (favorites.contains(procedureId)) {
      favorites.remove(procedureId);
    } else {
      favorites.add(procedureId);
    }

    notifyListeners();
  }

  Set<String> getFavoriteIds(String userId) {
    return Set.unmodifiable(
      _favorites[userId] ?? <String>{},
    );
  }
}