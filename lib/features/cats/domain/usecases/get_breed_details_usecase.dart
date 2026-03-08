import '../entities/cat_breed.dart';
import '../repositories/cat_repository.dart';

class GetBreedDetailsUseCase {
  final CatRepository repository;

  GetBreedDetailsUseCase(this.repository);

  Future<CatBreed> call(String breedId) async {
    return await repository.getBreedDetails(breedId);
  }
}
