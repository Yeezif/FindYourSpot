class Spot {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  Spot({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {

    final coords = json['location']['coordinates'];

    return Spot(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      longitude: coords[0],
      latitude: coords[1],
    );

  }

}