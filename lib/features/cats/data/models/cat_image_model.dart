import '../../domain/entities/cat_image.dart';
import 'cat_breed_model.dart';

class CatImageModel extends CatImage {
  CatImageModel({
    required super.id,
    required super.url,
    super.width,
    super.height,
    super.breeds,
  });

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    return CatImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      breeds:
          (json['breeds'] as List<dynamic>?)
              ?.map(
                (breed) =>
                    CatBreedModel.fromJson(breed as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
      'breeds': breeds.map((breed) {
        if (breed is CatBreedModel) {
          return breed.toJson();
        }
        return {};
      }).toList(),
    };
  }
}
