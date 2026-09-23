import '../entities/cat_image.dart';
import '../repositories/cat_repository.dart';

class GetRandomCatUseCase {
  final CatRepository repository;

  GetRandomCatUseCase(this.repository);

  Future<CatImage> call() async {
    return await repository.getRandomCatWithBreed();
  }
}
