import 'package:booking_app/domain/datasources/reservations_datasource.dart';
import 'package:booking_app/domain/entities/reservation.dart';
import 'package:flutter/material.dart';

class ReservationProvider extends ChangeNotifier {
  ReservationsDatasource datasource;
  List<Reservation> reservations = [];

  ReservationProvider({required this.datasource});

  // Obtener todas las reservaciones
  Future<void> getReservations() async {
    try {
      reservations = await datasource.getReservations();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Obtener reservaciones filtradas por usuario
  List<Reservation> getReservationsByUser(String userId) {
    return reservations.where((e) => e.user.id == userId).toList();
  }

  // Obtener reservaciones filtradas por propiedad
  List<Reservation> getReservationsByProperty(String propertyId) {
    return reservations.where((e) => e.property.id == propertyId).toList();
  }

  // Contadores dinámicos
  int countReservationsByStatus(String status,
      {String? userId, String? propertyId}) {
    var filtered = reservations.where((e) => e.status == status);
    if (userId != null) {
      filtered = filtered.where((e) => e.user.id == userId);
    }
    if (propertyId != null) {
      filtered = filtered.where((e) => e.property.id == propertyId);
    }
    return filtered.length;
  }

  // Crear reservación
  Future<void> createReservation(Reservation reservation) async {
    try {
      final newReservation = await datasource.createReservation(reservation);
      reservations.add(newReservation);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Actualizar reservación
  Future<void> updateReservation(Reservation reservation) async {
    try {
      final updatedReservation =
          await datasource.updateReservation(reservation);
      final index = reservations.indexWhere((e) => e.id == reservation.id);
      if (index != -1) {
        reservations[index] = updatedReservation;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  // Eliminar reservación
  Future<void> deleteReservation(String id) async {
    try {
      await datasource.deleteReservation(id);
      reservations.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
