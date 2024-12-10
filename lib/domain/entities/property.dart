import 'package:booking_app/domain/entities/avialability.dart';
import 'package:booking_app/domain/entities/user.dart';

class Property {
  final String id;
  final String title;
  final String? description;
  final String address;
  final double? pricePerNight;
  final User? host;
  final double? latitude;
  final double? longitude;
  final List<Avialability>? availability;
  final String? role;

  Property({
    required this.id,
    required this.title,
    this.description,
    required this.address,
    this.pricePerNight,
    required this.host,
    this.latitude,
    this.longitude,
    this.availability,
    this.role,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Sin título',
      description: json['description']?.toString() ?? 'Sin descripción',
      address: json['address']?.toString() ?? 'Sin dirección',
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      host: json['host'] != null
          ? User.fromJson(json['host'])
          : User.defaultUser(),
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) ?? 0.0
          : 0.0,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) ?? 0.0
          : 0.0,
      availability: json['availability'] != null
          ? (json['availability'] as List<dynamic>)
              .map((e) => Avialability.fromJson(e))
              .toList()
          : [],
      role: json['role']?.toString() ?? 'guest',
    );
  }

  factory Property.defaultProperty() {
    return Property(
        id: '',
        title: 'Propiedad desconocida',
        address: 'Dirección desconocida',
        host: User.defaultUser());
  }
}
