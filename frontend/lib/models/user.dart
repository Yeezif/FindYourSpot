import 'collection.dart';

class User {

  final String id;
  final String username;
  final String role;
  final List<Collection> collections;

  User({
    required this.id,
    required this.username,
    this.role = 'user',
    this.collections = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      id: json['_id'],
      username: json['username'],
      role: json['role'] ?? 'user',
      collections: json['collections'] != null
        ? List<Collection>.from(json['collections'].map((collection) => Collection.fromJson(collection)))
        : [],
    );

  }

}