import 'package:booking_app/domain/entities/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersDatasource {
  Future<List<User>> getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/user';
    // Agregar el token de autenticación
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get('/users');
      final data = response.data as List;
      return data.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User> getUserById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/user';
    // Agregar el token de autenticación
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await dio.get('/users/$id');
      return User.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/user';
    // Agregar el token de autenticación
    dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      await dio.put('/users/${user.id}', data: {
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'role': user.role,
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }


}