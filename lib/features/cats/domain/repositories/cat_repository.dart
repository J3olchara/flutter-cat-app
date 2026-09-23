import '../entities/cat_breed.dart';
import '../entities/cat_image.dart';

abstract class CatRepository {
  Future<CatImage> getRandomCatWithBreed();
  Future<List<CatBreed>> getAllBreeds();
  Future<CatBreed> getBreedDetails(String breedId);
  Future<List<String>> getBreedImages(String breedId, {int limit = 3});
}
