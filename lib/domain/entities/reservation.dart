import 'package:booking_app/domain/entities/property.dart';
import 'package:booking_app/domain/entities/user.dart';

class Reservation {
  final String id;
  final Property property;
  final User user;
  final DateTime startDate;
  final DateTime endDate;
  final int guests;
  final double totalAmount;
  final String status;

  Reservation({
    required this.id,
    required this.property,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.totalAmount,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id']?.toString() ?? '', // ID predeterminado vacío
      property: json['property'] != null
          ? Property.fromJson(json['property'])
          : Property.defaultProperty(), // Propiedad predeterminada si es nulo
      user: json['user'] != null
          ? User.fromJson(json['user']) : User.defaultUser(), // Usuario predeterminado si es nulo
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : DateTime.now(), // Fecha actual si es nulo
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : DateTime.now(), // Fecha actual si es nulo
      guests: json['guests'] as int? ?? 0, // Número de invitados predeterminado
      totalAmount:
          json['totalAmount'] as double? ?? 0.0, // Total predeterminado
      status: json['status']?.toString() ?? 'pending', // Estado predeterminado
    );
  }
}
