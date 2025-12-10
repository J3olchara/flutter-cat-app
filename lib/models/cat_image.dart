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
    required this.breeds,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final url = json['url'];

    if (id == null) throw Exception('id is null');
    if (url == null) throw Exception('url is null');

    final breedsData = json['breeds'];

    List<CatBreed> breeds = [];
    if (breedsData != null && breedsData is List) {
      breeds = breedsData
          .map((breed) {
            try {
              return CatBreed.fromJson(breed as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<CatBreed>()
          .toList();
    }

    return CatImage(
      id: id.toString(),
      url: url.toString(),
      width: json['width'] as int?,
      height: json['height'] as int?,
      breeds: breeds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
      'breeds': breeds.map((breed) => breed.toJson()).toList(),
    };
  }

  CatBreed? get primaryBreed => breeds.isNotEmpty ? breeds.first : null;
}
