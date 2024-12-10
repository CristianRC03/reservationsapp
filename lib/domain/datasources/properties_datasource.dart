import 'package:booking_app/domain/entities/property.dart';
import 'package:dio/dio.dart';

class PropertiesDatasource {
  Future<List<Property>> getProperties() async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      final response = await dio.get('/');
      final data = response.data as List;
      return data.map((e) => Property.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Property>> getPropertiesByUserId(String userId) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      final response = await dio.get('/host/$userId');
      final data = response.data as List;
      return data.map((e) => Property.fromJson(e)).toList();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Property> getPropertyById(String id) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      final response = await dio.get('/$id');
      return Property.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Property> createProperty(Property property) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      final response = await dio.post('/', data: {
        'title': property.title,
        'description': property.description,
        'address': property.address,
        'pricePerNight': property.pricePerNight,
        'latitude': property.latitude,
        'longitude': property.longitude,
        'availability': property.availability,
        'role': property.role,
        'userId': property.host!.id,
      });

      return Property.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Property> updateProperty(Property property) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      final response = await dio.put('/${property.id}', data: {
        'title': property.title,
        'description': property.description,
        'address': property.address,
        'pricePerNight': property.pricePerNight,
        'latitude': property.latitude,
        'longitude': property.longitude,
        'availability': property.availability,
        'role': property.role,
      });

      return Property.fromJson(response.data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteProperty(String id) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://reservations-api.ddns.net/api/properties';

    try {
      await dio.delete('/$id');
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
