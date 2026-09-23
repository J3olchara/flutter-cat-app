import '../../domain/repositories/likes_repository.dart';
import '../datasources/likes_local_datasource.dart';

class LikesRepositoryImpl implements LikesRepository {
  final LikesLocalDataSource localDataSource;

  LikesRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveLike(String catId) async {
    await localDataSource.saveLike(catId);
  }

  @override
  Future<int> getLikesCount() async {
    return await localDataSource.getLikesCount();
  }

  @override
  Future<bool> isLiked(String catId) async {
    return await localDataSource.isLiked(catId);
  }

  @override
  Future<List<String>> getLikedCats() async {
    return await localDataSource.getLikedCats();
  }

  @override
  Future<void> removeLike(String catId) async {
    await localDataSource.removeLike(catId);
  }

  @override
  Future<void> clearAllLikes() async {
    await localDataSource.clearAllLikes();
  }
}
