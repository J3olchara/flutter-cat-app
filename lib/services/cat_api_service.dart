import 'package:dio/dio.dart';
import '../models/cat_breed.dart';
import '../models/cat_image.dart';

class CatApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://api.thecatapi.com/v1';
  static const String? _apiKey = null;

  CatApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: _apiKey != null ? {'x-api-key': _apiKey} : null,
        ),
      );

  Future<CatImage> getRandomCatWithBreed() async {
    try {
      final breeds = await getAllBreeds();
      if (breeds.isEmpty) {
        throw Exception('Не удалось получить список пород');
      }

      final randomBreed =
          breeds[DateTime.now().millisecondsSinceEpoch % breeds.length];

      print('Loading cat: ${randomBreed.name}');

      final response = await _dio.get(
        '/images/search',
        queryParameters: {'breed_ids': randomBreed.id, 'limit': 1},
      );

      if (response.data == null || (response.data as List).isEmpty) {
        throw Exception(
          'Не удалось получить изображение для породы ${randomBreed.name}',
        );
      }

      final imageData = (response.data as List).first;

      final catImage = CatImage(
        id: imageData['id'] as String,
        url: imageData['url'] as String,
        width: imageData['width'] as int?,
        height: imageData['height'] as int?,
        breeds: [randomBreed],
      );

      return catImage;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Ошибка при загрузке котика: $e');
    }
  }

  Future<List<CatBreed>> getAllBreeds() async {
    try {
      final response = await _dio.get('/breeds');

      if (response.data == null) {
        throw Exception('Не удалось получить список пород');
      }

      final breeds = (response.data as List)
          .map((breed) => CatBreed.fromJson(breed as Map<String, dynamic>))
          .toList();

      return breeds;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  Future<CatBreed> getBreedDetails(String breedId) async {
    try {
      final response = await _dio.get('/breeds/$breedId');

      if (response.data == null) {
        throw Exception('Не удалось получить информацию о породе');
      }

      return CatBreed.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Неожиданная ошибка: $e');
    }
  }

  Future<List<String>> getBreedImages(String breedId, {int limit = 3}) async {
    try {
      final response = await _dio.get(
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
