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
      id: json['_id'] as String,
      property: Property.fromJson(json['property']),
      user: User.fromJson(json['user']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      guests: json['guests'] as int,
      totalAmount: json['totalAmount'] as double,
      status: json['status'] as String,
    );
  }
}