import '../repositories/likes_repository.dart';

class LikeCatUseCase {
  final LikesRepository repository;

  LikeCatUseCase(this.repository);

  Future<void> call(String catId) async {
    await repository.saveLike(catId);
  }
}
