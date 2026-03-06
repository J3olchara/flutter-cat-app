import 'cat_breed.dart';

class CatImage {
  final String id;
  final String url;
  final int? width;
  final int? height;
  final List<CatBreed> breeds;

  CatImage({
    required this.id,
    required this.url,
    this.width,
    this.height,
    this.breeds = const [],
  });

  CatBreed? get primaryBreed => breeds.isNotEmpty ? breeds.first : null;
}
