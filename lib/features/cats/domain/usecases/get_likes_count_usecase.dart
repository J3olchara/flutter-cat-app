import '../repositories/likes_repository.dart';

class GetLikesCountUseCase {
  final LikesRepository repository;

  GetLikesCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getLikesCount();
  }
}
