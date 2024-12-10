import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDatasource {
  Future<bool> login(String email, String password) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/user';

    try {
      final response = await dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final String token = response.data['token'];
      final decodedToken = JwtDecoder.decode(token);
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('userId', decodedToken['id']);
      prefs.setString('role', decodedToken['role']);


      // Suponiendo que la API devuelve un código HTTP 200 y un token en la respuesta
      if (response.statusCode == 200 && token.isNotEmpty) {
        print('Inicio de sesión exitoso');
        return true;
      } else {
        throw Exception('Credenciales inválidas');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(
      String name, String email, String password, String phone) async {
    var dio = Dio();
    dio.options.baseUrl = 'https://reservation-api.ddns.net/api/user';

    try {
      final response = await dio.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });

      final String token = response.data;
      final decodedToken = JwtDecoder.decode(token);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('userId', decodedToken['id']);
      prefs.setString('role', decodedToken['role']);

      // Suponiendo que la API devuelve un código HTTP 200 y un token en la respuesta
      if (response.statusCode == 200 && token.isNotEmpty) {
        print('Registro exitoso');
      } else {
        throw Exception('Error al registrar');
      }

    } catch (e) {
      rethrow;
    }
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Duration getTokenExpiration(String token) {
    return JwtDecoder.getRemainingTime(token);
  }
}
