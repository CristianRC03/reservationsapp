import 'package:booking_app/domain/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({super.key});

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  var userId = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      final provider = Provider.of<ReservationProvider>(context, listen: false);
      provider.getReservations();
    });
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String title, String content) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirmar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    reservationProvider.getReservations();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Reservaciones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoCard(
                  title: 'Pendientes',
                  value: reservationProvider
                      .countReservationsByStatus('pending', userId: userId)
                      .toString(),
                  color: Colors.orange,
                ),
                _InfoCard(
                  title: 'Confirmadas',
                  value: reservationProvider
                      .countReservationsByStatus('confirm', userId: userId)
                      .toString(),
                  color: Colors.green,
                ),
                _InfoCard(
                  title: 'Canceladas',
                  value: reservationProvider
                      .countReservationsByStatus('cancelled', userId: userId)
                      .toString(),
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Últimas Reservaciones',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount:
                    reservationProvider.getReservationsByUser(userId).length,
                itemBuilder: (context, index) {
                  final reservation =
                      reservationProvider.getReservationsByUser(userId)[index];

                  return Dismissible(
                    key: Key(reservation.id),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Confirmar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Icon(Icons.cancel, color: Colors.white),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Deslizó hacia la derecha (Confirmar)
                        return await _showConfirmationDialog(
                          context,
                          'Confirmar reservación',
                          '¿Estás seguro de que quieres confirmar esta reservación?',
                        );
                      } else if (direction == DismissDirection.endToStart) {
                        // Deslizó hacia la izquierda (Cancelar)
                        return await _showConfirmationDialog(
                          context,
                          'Cancelar reservación',
                          '¿Estás seguro de que quieres cancelar esta reservación?',
                        );
                      }
                      return false;
                    },
                    onDismissed: (direction) async {
                      final newStatus = direction == DismissDirection.startToEnd
                          ? 'confirm'
                          : 'cancelled';
                      final updatedReservation =
                          reservation.copyWith(status: newStatus);

                      // Actualiza la reservación en el servidor
                      await reservationProvider
                          .updateReservation(updatedReservation);

                      // Elimina la reservación de la lista local
                      setState(() {
                        reservationProvider.reservations
                            .removeWhere((r) => r.id == reservation.id);
                      });

                      // Vuelve a cargar las reservaciones para reflejar los cambios en la UI
                      await reservationProvider.getReservations();
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(reservation.property.title),
                        subtitle: Text(
                            'Huéspedes: ${reservation.guests} | ${reservation.startDate.toLocal().toString().split(' ')[0]} - ${reservation.endDate.toLocal().toString().split(' ')[0]}'),
                        leading: Icon(
                          Icons.home,
                          color: _getStatusColor(reservation.status),
                        ),
                        trailing: Text(reservation.status.capitalize()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirm':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
