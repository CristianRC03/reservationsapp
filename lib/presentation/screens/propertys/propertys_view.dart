import 'package:booking_app/domain/providers/property_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/domain/entities/property.dart';
import 'package:booking_app/domain/entities/reservation.dart';

class PropertyView extends StatefulWidget {
  const PropertyView({super.key});
  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  @override
  void initState() {
    super.initState();
    // Cargar las propiedades del usuario al iniciar la pantalla
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.getProperties();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Propiedades'),
      ),
      body: provider.properties.isEmpty
          ? const Center(child: Text('No tienes propiedades registradas.'))
          : ListView.builder(
              itemCount: provider.properties.length,
              itemBuilder: (context, index) {
                final property = provider.properties[index];
                return Card(
                  child: ListTile(
                    title: Text(property.title),
                    subtitle: Text('Dirección: ${property.address}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showReservations(context, property.id, provider);
                      },
                      child: const Text('Ver Reservas'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showReservations(BuildContext context, String propertyId, PropertyProvider provider) async {
    try {
      // Obtener las reservas de la propiedad específica
      await provider.getReservationsByProperty(propertyId);
      final filteredReservations = provider.getFilteredReservations(propertyId);

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reservas para la propiedad $propertyId',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                filteredReservations.isEmpty
                    ? const Text('No hay reservaciones para esta propiedad.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredReservations.length,
                        itemBuilder: (context, index) {
                          final reservation = filteredReservations[index];
                          return ListTile(
                            title: Text('Desde: ${reservation.startDate.toLocal()}'),
                            subtitle: Text('Hasta: ${reservation.endDate.toLocal()}Estado: ${reservation.status}'),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('No se pudieron cargar las reservas: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }
}