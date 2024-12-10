import 'package:booking_app/domain/providers/property_provider.dart';
import 'package:booking_app/domain/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyView extends StatefulWidget {
  const PropertyView({super.key});

  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  var userId = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });

    // Cargar las propiedades y reservaciones del usuario
    final propertyProvider =
        Provider.of<PropertyProvider>(context, listen: false);
    final reservationProvider =
        Provider.of<ReservationProvider>(context, listen: false);

    propertyProvider.getPropertiesByUserId(userId);
    reservationProvider.getReservations();
  }

  @override
  Widget build(BuildContext context) {
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final reservationProvider = Provider.of<ReservationProvider>(context);
    propertyProvider.getPropertiesByUserId(userId);
    reservationProvider.getReservations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Propiedades'),
      ),
      body: propertyProvider.properties.isEmpty
          ? const Center(child: Text('No tienes propiedades registradas.'))
          : ListView.builder(
              itemCount: propertyProvider.getPropertiesByUserId(userId).length,
              itemBuilder: (context, index) {
                final property = propertyProvider.getPropertiesByUserId(userId)[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          property.description ?? 'Sin descripción',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dirección: ${property.address}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Precio por noche: \$${property.pricePerNight?.toStringAsFixed(2) ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              _showReservations(
                                  context, property.id, reservationProvider);
                            },
                            child: const Text('Ver Reservas'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showReservations(BuildContext context, String propertyId,
      ReservationProvider reservationProvider) {
    final filteredReservations =
        reservationProvider.findReservationsByProperty(propertyId);

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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          title:
                              Text('Desde: ${reservation.startDate.toLocal()}'),
                          subtitle: Text(
                            'Hasta: ${reservation.endDate.toLocal()}\nEstado: ${reservation.status}',
                          ),
                        );
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
