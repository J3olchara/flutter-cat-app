import '../../domain/entities/cat_breed.dart';

class CatBreedModel extends CatBreed {
  CatBreedModel({
    required super.id,
    required super.name,
    super.description,
    super.temperament,
    super.origin,
    super.lifeSpan,
    super.adaptability,
    super.affectionLevel,
    super.childFriendly,
    super.energyLevel,
    super.wikipediaUrl,
  });

  factory CatBreedModel.fromJson(Map<String, dynamic> json) {
    return CatBreedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      temperament: json['temperament'] as String?,
      origin: json['origin'] as String?,
      lifeSpan: json['life_span'] as String?,
      adaptability: json['adaptability'] as int?,
      affectionLevel: json['affection_level'] as int?,
      childFriendly: json['child_friendly'] as int?,
      energyLevel: json['energy_level'] as int?,
      wikipediaUrl: json['wikipedia_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'temperament': temperament,
      'origin': origin,
      'life_span': lifeSpan,
      'adaptability': adaptability,
      'affection_level': affectionLevel,
      'child_friendly': childFriendly,
      'energy_level': energyLevel,
      'wikipedia_url': wikipediaUrl,
    };
  }
}
