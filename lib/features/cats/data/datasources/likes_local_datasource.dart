import 'package:shared_preferences/shared_preferences.dart';

abstract class LikesLocalDataSource {
  Future<void> saveLike(String catId);
  Future<int> getLikesCount();
  Future<bool> isLiked(String catId);
  Future<List<String>> getLikedCats();
  Future<void> removeLike(String catId);
  Future<void> clearAllLikes();
}

class LikesLocalDataSourceImpl implements LikesLocalDataSource {
  static const String _likesKey = 'liked_cats';
  static const String _likesCountKey = 'likes_count';

  @override
  Future<void> saveLike(String catId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedCats = await getLikedCats();

      if (!likedCats.contains(catId)) {
        likedCats.add(catId);
        await prefs.setStringList(_likesKey, likedCats);

        final count = await getLikesCount();
        await prefs.setInt(_likesCountKey, count + 1);
      }
    } catch (e) {
      throw Exception('Ошибка при сохранении лайка: $e');
    }
  }

  @override
  Future<int> getLikesCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_likesCountKey) ?? 0;
    } catch (e) {
      throw Exception('Ошибка при получении количества лайков: $e');
    }
  }

  @override
  Future<bool> isLiked(String catId) async {
    try {
      final likedCats = await getLikedCats();
      return likedCats.contains(catId);
    } catch (e) {
      throw Exception('Ошибка при проверке лайка: $e');
    }
  }

  @override
  Future<List<String>> getLikedCats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_likesKey) ?? [];
    } catch (e) {
      throw Exception('Ошибка при получении списка лайкнутых котиков: $e');
    }
  }

  @override
  Future<void> removeLike(String catId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final likedCats = await getLikedCats();

      if (likedCats.contains(catId)) {
        likedCats.remove(catId);
        await prefs.setStringList(_likesKey, likedCats);

        final count = await getLikesCount();
        await prefs.setInt(_likesCountKey, count > 0 ? count - 1 : 0);
      }
    } catch (e) {
      throw Exception('Ошибка при удалении лайка: $e');
    }
  }

  @override
  Future<void> clearAllLikes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_likesKey);
      await prefs.remove(_likesCountKey);
    } catch (e) {
      throw Exception('Ошибка при очистке лайков: $e');
    }
  }
}
