import 'package:dio/dio.dart';
import '../models/cat_breed_model.dart';
import '../models/cat_image_model.dart';

abstract class CatRemoteDataSource {
  Future<CatImageModel> getRandomCatWithBreed();
  Future<List<CatBreedModel>> getAllBreeds();
  Future<CatBreedModel> getBreedDetails(String breedId);
  Future<List<String>> getBreedImages(String breedId, {int limit = 3});
}

class CatRemoteDataSourceImpl implements CatRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const String? apiKey = null;

  CatRemoteDataSourceImpl({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: apiKey != null ? {'x-api-key': apiKey} : null,
            ),
          );

  @override
  Future<CatImageModel> getRandomCatWithBreed() async {
    try {
      final breeds = await getAllBreeds();
      if (breeds.isEmpty) {
        throw Exception('Не удалось получить список пород');
      }

      final randomBreed =
          breeds[DateTime.now().millisecondsSinceEpoch % breeds.length];

      final response = await dio.get(
        '/images/search',
        queryParameters: {'breed_ids': randomBreed.id, 'limit': 1},
      );

      if (response.data == null || (response.data as List).isEmpty) {
        throw Exception(
          'Не удалось получить изображение для породы ${randomBreed.name}',
        );
      }

      final imageData = (response.data as List).first;

      return CatImageModel(
        id: imageData['id'] as String,
        url: imageData['url'] as String,
        width: imageData['width'] as int?,
        height: imageData['height'] as int?,
        breeds: [randomBreed],
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Ошибка при загрузке котика: $e');
    }
  }

  @override
  Future<List<CatBreedModel>> getAllBreeds() async {
    try {
      final response = await dio.get('/breeds');

      if (response.data == null) {
        throw Exception('Не удалось получить список пород');
      }

      final breeds = (response.data as List)
          .map((breed) => CatBreedModel.fromJson(breed as Map<String, dynamic>))
          .toList();

      return breeds;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  @override
  Future<CatBreedModel> getBreedDetails(String breedId) async {
    try {
      final response = await dio.get('/breeds/$breedId');

      if (response.data == null) {
        throw Exception('Не удалось получить информацию о породе');
      }

      return CatBreedModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  @override
  Future<List<String>> getBreedImages(String breedId, {int limit = 3}) async {
    try {
      final response = await dio.get(
        '/images/search',
        queryParameters: {'breed_ids': breedId, 'limit': limit},
      );

      if (response.data == null) {
        return [];
      }

      return (response.data as List)
          .map((image) => image['url'] as String)
          .toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Превышено время ожидания. Проверьте подключение к интернету.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return Exception('Данные не найдены.');
        } else if (statusCode == 429) {
          return Exception('Слишком много запросов. Попробуйте позже.');
        } else if (statusCode != null && statusCode >= 500) {
          return Exception('Ошибка сервера. Попробуйте позже.');
        }
        return Exception(
          'Ошибка: ${error.response?.statusMessage ?? "Неизвестная ошибка"}',
        );
      case DioExceptionType.cancel:
        return Exception('Запрос был отменен.');
      case DioExceptionType.connectionError:
        return Exception(
          'Нет подключения к интернету. Проверьте настройки сети.',
        );
      default:
        return Exception('Произошла ошибка: ${error.message}');
    }
  }
}
