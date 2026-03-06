import '../../domain/entities/cat_breed.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_remote_datasource.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;

  CatRepositoryImpl(this.remoteDataSource);

  @override
  Future<CatImage> getRandomCatWithBreed() async {
    return await remoteDataSource.getRandomCatWithBreed();
  }

  @override
  Future<List<CatBreed>> getAllBreeds() async {
    return await remoteDataSource.getAllBreeds();
  }

  @override
  Future<CatBreed> getBreedDetails(String breedId) async {
    return await remoteDataSource.getBreedDetails(breedId);
  }

  @override
  Future<List<String>> getBreedImages(String breedId, {int limit = 3}) async {
    return await remoteDataSource.getBreedImages(breedId, limit: limit);
  }
}
