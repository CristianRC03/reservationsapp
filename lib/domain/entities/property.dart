import 'package:booking_app/domain/entities/avialability.dart';

class Property {
  final String id;
  final String title;
  final String description;
  final String address;
  final double pricePerNight;
  final double latitude;
  final double longitude;
  final List<Avialability> availability;
  final String userId;
  final String role;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.pricePerNight,
    required this.latitude,
    required this.longitude,
    required this.availability,
    required this.userId,
    required this.role,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      pricePerNight: json['pricePerNight'] as double,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      availability: (json['availability'] as List)
          .map((e) => Avialability.fromJson(e))
          .toList(),
      userId: json['userId'] as String,
      role: json['role'] as String,
    );
  }
}