import 'package:booking_app/domain/entities/reservation.dart';
import 'package:dio/dio.dart';

class ReservationsDatasource {
  Future<List<Reservation>> getReservations() async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      final response = await dio.get('/');
      final data = response.data as List;
      return data.map((e) => Reservation.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Reservation>> getReservationsByProperty(String propertyId) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      final response = await dio.get('/property/$propertyId');
      final data = response.data as List;
      return data.map((e) => Reservation.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Reservation>> getPropertiesByUserId(String userId) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/property';

    try {
      final response = await dio.get('/user/$userId');
      final data = response.data as List;
      return data.map((e) => Reservation.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Reservation> getReservationById(String id) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      final response = await dio.get('/$id');
      return Reservation.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Reservation> createReservation(Reservation reservation) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      final response = await dio.post('/', data: {
        'propertyId': reservation.property.id,
        'userId': reservation.user.id,
        'startDate': reservation.startDate.toIso8601String(),
        'endDate': reservation.endDate.toIso8601String(),
        'guests': reservation.guests,
        'totalAmount': reservation.totalAmount,
      });

      return Reservation.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Reservation> updateReservation(Reservation reservation) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      final response = await dio.put('/${reservation.id}', data: {
        'propertyId': reservation.property.id,
        'userId': reservation.user.id,
        'startDate': reservation.startDate.toIso8601String(),
        'endDate': reservation.endDate.toIso8601String(),
        'guests': reservation.guests,
        'totalAmount': reservation.totalAmount,
        'status': reservation.status,
      });

      return Reservation.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteReservation(String id) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/bookings';

    try {
      await dio.delete('/$id');
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
