import 'package:booking_app/domain/datasources/properties_datasource.dart';
import 'package:booking_app/domain/entities/property.dart';
import 'package:flutter/material.dart';

class PropertyProvider extends ChangeNotifier {
  PropertiesDatasource datasource;
  List<Property> properties = [];

  PropertyProvider({required this.datasource});

  // Obtener todas las propiedades
  Future<void> getProperties() async {
    try {
      properties = await datasource.getProperties();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Filtrar propiedades por usuario (host)
  List<Property> getPropertiesByUserId(String userId) {
    return properties.where((property) => property.host!.id == userId).toList();
  }

  // Crear una nueva propiedad
  Future<void> createProperty(Property property) async {
    try {
      final newProperty = await datasource.createProperty(property);
      properties.add(newProperty);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  // Actualizar una propiedad
  Future<void> updateProperty(Property property) async {
    try {
      final updatedProperty = await datasource.updateProperty(property);
      final index = properties.indexWhere((e) => e.id == property.id);
      if (index != -1) {
        properties[index] = updatedProperty;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  // Eliminar una propiedad
  Future<void> deleteProperty(String id) async {
    try {
      await datasource.deleteProperty(id);
      properties.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
