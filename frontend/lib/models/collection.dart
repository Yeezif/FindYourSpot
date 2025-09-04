import 'spot.dart';
import 'user.dart';

// class Collection {
//   final String id;
//   final String title;
//   final String description;
//   final List<Spot> spots;
//   final User createdBy;

//   Collection({
//     required this.id,
//     required this.title,
//     this.description = '',
//     this.spots = const [],
//     required this.createdBy,
//   });

//   factory Collection.fromJson(Map<String, dynamic> json) {
//     return Collection(
//       id: json['_id'],
//       title: json['title'],
//       description: json['description'] ?? '',
//       spots: (json['spots'] as List).map((s) => Spot.fromJson(s)).toList(),
//       createdBy: User.fromJson(json['createdBy']),
//     );
//   }

//   Map<String, dynamic> toJson() {

//     return {
//       'title': title,
//       'description': description,
//       'spots': spots.map((s) => s.id).toList(), // nur IDs senden
//       'createdBy': createdBy.id, // optional, wenn Backend das erwartet
//     };
    
//   }

// }


class Collection {

  final String? id;
  final String title;
  final String description;
  final List<SpotRef> spots;
  final User createdBy;

  Collection({
    this.id,
    required this.title,
    this.description = '',
    this.spots = const [],
    required this.createdBy,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      spots: (json['spots'] as List?)?.map((s) => SpotRef.fromJson(s)).toList() ?? [],
      createdBy: User.fromJson(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'title': title,
      'description': description,
      'spots': spots.map((s) => s.toJson()).toList(), // nur IDs senden
      'createdBy': createdBy.id, // optional, wenn Backend das erwartet
    };
    
  }

}


class SpotRef {

  final Spot? spot;
  final String? spotId;
  final DateTime addedAt;

  SpotRef({
    this.spot,
    this.spotId,
    required this.addedAt,
  });

  factory SpotRef.fromJson(Map<String, dynamic> json) {
    
    final spotData = json['spot'];
    Spot? parsedSpot;
    String? parsedId;

    if (spotData is String) {
      parsedId = spotData;
    } else if (spotData is Map<String, dynamic>) {
      parsedSpot = Spot.fromJson(spotData);
      parsedId = spotData['_id'];
    }
    
    return SpotRef(
      spot: parsedSpot,
      spotId: parsedId,
      addedAt: json['addedAt'] != null ? DateTime.parse(json['addedAt']) : DateTime.now(),
    );

  }

  Map<String, dynamic> toJson() {

    return {
      'spot': spotId ?? spot?.id,
      'addedAt': addedAt.toIso8601String(),
    };
  }

}