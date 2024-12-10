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
      id: json['_id']?.toString() ?? '', // ID predeterminado vacío
      title: json['title']?.toString() ?? 'Sin título', // Título predeterminado
      description: json['description']?.toString() ??
          'Sin descripción', // Descripción predeterminada
      address: json['address']?.toString() ??
          'Sin dirección', // Dirección predeterminada
      pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ??
          0.0, // Precio por noche predeterminado
      host: json['host'] != null
          ? User.fromJson(json['host'])
          : User.defaultUser(), // Usuario predeterminado si es nulo
      latitude: (json['latitude'] as num?)?.toDouble() ??
          0.0, // Latitud predeterminada
      longitude: (json['longitude'] as num?)?.toDouble() ??
          0.0, // Longitud predeterminada
      availability: json['availability'] != null
          ? (json['availability'] as List<dynamic>)
              .map((e) => Avialability.fromJson(e))
              .toList()
          : [], // Lista vacía si es nulo
      role: json['role']?.toString() ?? 'guest', // Rol predeterminado
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
