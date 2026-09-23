import '../repositories/cat_repository.dart';

class GetBreedImagesUseCase {
  final CatRepository repository;

  GetBreedImagesUseCase(this.repository);

  Future<List<String>> call(String breedId, {int limit = 3}) async {
    return await repository.getBreedImages(breedId, limit: limit);
  }
}
