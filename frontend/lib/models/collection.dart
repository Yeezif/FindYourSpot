import 'spot.dart';
import 'user.dart';

class Collection {
  final String id;
  final String title;
  final String description;
  final List<Spot> spots;
  final User createdBy;

  Collection({
    required this.id,
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
      spots: (json['spots'] as List).map((s) => Spot.fromJson(s)).toList(),
      createdBy: User.fromJson(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {

    return {
      'title': title,
      'description': description,
      'spots': spots.map((s) => s.id).toList(), // nur IDs senden
      'createdBy': createdBy.id, // optional, wenn Backend das erwartet
    };
    
  }

}
