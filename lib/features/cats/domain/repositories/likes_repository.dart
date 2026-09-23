abstract class LikesRepository {
  Future<void> saveLike(String catId);
  Future<int> getLikesCount();
  Future<bool> isLiked(String catId);
  Future<List<String>> getLikedCats();
  Future<void> removeLike(String catId);
  Future<void> clearAllLikes();
}
