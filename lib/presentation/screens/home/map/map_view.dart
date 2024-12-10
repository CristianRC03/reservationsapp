import 'package:booking_app/domain/entities/property.dart';
import 'package:booking_app/domain/entities/reservation.dart';
import 'package:booking_app/domain/entities/user.dart';
import 'package:booking_app/domain/providers/property_provider.dart';
import 'package:booking_app/domain/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final Set<Marker> _markers = {};
  String? userRole;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserRoleAndId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
    });
  }

  Future<void> _loadUserRoleAndId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role');
      userId = prefs.getString('userId');
    });
  }

  Future<void> _loadMarkers() async {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    await provider.getProperties();
    setState(() {
      _markers.clear();
      for (var property in provider.properties) {
        _markers.add(Marker(
          markerId: MarkerId(property.id),
          position: LatLng(property.latitude!, property.longitude!),
          infoWindow: InfoWindow(
            title: property.title,
            snippet: 'Descripción: ${property.description} \n Dirección: ${property.address} Precio: \$${property.pricePerNight?.toStringAsFixed(2) ?? 'N/A'} por noche',
            onTap: () {
              _showReservationBottomSheet(property);
            },
          ),
        ));
      }
    });
  }

  void _onLongPress(LatLng position) {
    if (userRole == 'host') {
      _showAddPropertyDialog(position);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Solo los hosts pueden agregar propiedades.')),
      );
    }
  }

  void _showAddPropertyDialog(LatLng position) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Agregar propiedad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Precio por noche',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _addProperty(position);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

  Future<void> _addProperty(LatLng position) async {
    if (userId == null) return;

    final provider = Provider.of<PropertyProvider>(context, listen: false);
    final newProperty = Property(
      id: '',
      title: titleController.text,
      description: descriptionController.text,
      address: addressController.text,
      pricePerNight: priceController.text.isNotEmpty
          ? double.tryParse(priceController.text)
          : 0.0,
      host: User(id: userId!, name: '', email: '', role: 'host'),
      latitude: position.latitude,
      longitude: position.longitude,
      availability: [],
      role: 'host',
    );

    try {
      await provider.createProperty(newProperty);
      await _loadMarkers(); // Actualizar marcadores después de crear la propiedad
      titleController.clear();
      descriptionController.clear();
    } catch (e) {
      print('Error al crear la propiedad: $e');
    }
  }

  void _showReservationBottomSheet(Property property) {
    DateTime? startDate;
    DateTime? endDate;
    final guestsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reservar en ${property.title}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    startDate != null
                        ? 'Fecha de inicio: ${startDate!.toLocal()}'
                            .split(' ')[0]
                        : 'Selecciona la fecha de inicio',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      endDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    endDate != null
                        ? 'Fecha de fin: ${endDate!.toLocal()}'.split(' ')[0]
                        : 'Selecciona la fecha de fin',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: guestsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de huéspedes',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final guests = int.tryParse(guestsController.text) ?? 0;

                  if (startDate == null ||
                      endDate == null ||
                      guests <= 0 ||
                      startDate!.isAfter(endDate!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Datos inválidos')),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  await _createReservation(
                      property, startDate!, endDate!, guests);
                },
                child: const Text('Reservar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _createReservation(Property property, DateTime startDate,
      DateTime endDate, int guests) async {
    if (userId == null) return;

    final reservationProvider =
        Provider.of<ReservationProvider>(context, listen: false);

    final newReservation = Reservation(
      id: '',
      property: property,
      user: User(id: userId!, name: '', email: '', role: userRole ?? 'user'),
      startDate: startDate,
      endDate: endDate,
      guests: guests,
      totalAmount: (property.pricePerNight ?? 0) * guests,
      status: 'pending',
    );

    try {
      await reservationProvider.createReservation(newReservation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservación creada con éxito')),
      );
    } catch (e) {
      print('Error al crear la reservación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear la reservación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(21.128010, -101.687023),
        zoom: 12,
      ),
      onLongPress: _onLongPress,
      markers: _markers,
    );
  }
}
