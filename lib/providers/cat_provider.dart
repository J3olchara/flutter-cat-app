import 'package:flutter/foundation.dart';
import '../models/cat_breed.dart';
import '../models/cat_image.dart';
import '../services/cat_api_service.dart';
import '../services/likes_storage.dart';

enum LoadingState { idle, loading, loaded, error }

class CatProvider with ChangeNotifier {
  final CatApiService _apiService;
  final LikesStorage _likesStorage;

  CatProvider({CatApiService? apiService, LikesStorage? likesStorage})
    : _apiService = apiService ?? CatApiService(),
      _likesStorage = likesStorage ?? LikesStorage() {
    _init();
  }

  LoadingState _loadingState = LoadingState.idle;
  LoadingState get loadingState => _loadingState;

  LoadingState _breedsLoadingState = LoadingState.idle;
  LoadingState get breedsLoadingState => _breedsLoadingState;

  CatImage? _currentCat;
  CatImage? get currentCat => _currentCat;

  List<CatBreed> _breeds = [];
  List<CatBreed> get breeds => _breeds;

  int _likesCount = 0;
  int get likesCount => _likesCount;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<CatImage> _catsQueue = [];

  Future<void> _init() async {
    await _loadLikesCount();
    loadNextCat();
    Future.delayed(const Duration(seconds: 1), () => loadBreeds());
  }

  Future<void> _loadLikesCount() async {
    try {
      _likesCount = await _likesStorage.getLikesCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка: $e');
    }
  }

  Future<void> loadNextCat() async {
    _loadingState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_catsQueue.isNotEmpty) {
        _currentCat = _catsQueue.removeAt(0);
        debugPrint('Cat loaded from queue');
      } else {
        _currentCat = await _apiService.getRandomCatWithBreed();
        debugPrint('New cat loaded');
      }

      _loadingState = LoadingState.loaded;
      _preloadNextCat();
    } catch (e) {
      _loadingState = LoadingState.error;
      _errorMessage = e.toString();
      debugPrint('Error loading cat: $e');
    }

    notifyListeners();
  }

  Future<void> _preloadNextCat() async {
    try {
      if (_catsQueue.length < 2) {
        await Future.delayed(const Duration(milliseconds: 500));
        final cat = await _apiService.getRandomCatWithBreed();
        _catsQueue.add(cat);
        debugPrint('Preloaded next cat');
      }
    } catch (e) {
      debugPrint('Preload error: $e');
    }
  }

  Future<void> likeCat() async {
    if (_currentCat == null) return;

    try {
      await _likesStorage.saveLike(_currentCat!.id);
      _likesCount = await _likesStorage.getLikesCount();
      debugPrint('Cat liked! Total: $_likesCount');
      notifyListeners();
      await loadNextCat();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> dislikeCat() async {
    if (_currentCat == null) return;

    try {
      await loadNextCat();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadBreeds() async {
    _breedsLoadingState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _breeds = await _apiService.getAllBreeds();
      _breedsLoadingState = LoadingState.loaded;
      debugPrint('Loaded ${_breeds.length} breeds');
    } catch (e) {
      _breedsLoadingState = LoadingState.error;
      _errorMessage = e.toString();
      debugPrint('Error loading breeds: $e');
    }

    notifyListeners();
  }

  Future<CatBreed?> getBreedDetails(String breedId) async {
    try {
      return await _apiService.getBreedDetails(breedId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<List<String>> getBreedImages(String breedId) async {
    try {
      return await _apiService.getBreedImages(breedId, limit: 4);
    } catch (e) {
      return [];
    }
  }

  Future<bool> isCatLiked(String catId) async {
    try {
      return await _likesStorage.isLiked(catId);
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> retry() async {
    if (_loadingState == LoadingState.error) {
      await loadNextCat();
    }
    if (_breedsLoadingState == LoadingState.error) {
      await loadBreeds();
    }
  }
}
