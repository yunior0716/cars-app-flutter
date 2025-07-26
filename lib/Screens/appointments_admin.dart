import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsAdminScreen extends StatelessWidget {
  const AppointmentsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de prueba
    final List<Map<String, dynamic>> appointments = [
      {
        'carImage': 'images/logo.png',
        'brand': 'Toyota',
        'model': 'Corolla',
        'year': 2021,
        'date': DateTime.now().add(const Duration(days: 2)),
        'user': 'Juan Pérez',
      },
      {
        'carImage': 'images/logo.png',
        'brand': 'Honda',
        'model': 'Civic',
        'year': 2020,
        'date': DateTime.now().add(const Duration(days: 4)),
        'user': 'Angel Gómez',
      },
      {
        'carImage': 'images/logo.png',
        'brand': 'Ford',
        'model': 'Focus',
        'year': 2019,
        'date': DateTime.now().add(const Duration(days: 6)),
        'user': 'Carlos Ruiz',
      },
    ];
    final dateFormat = DateFormat('dd-MM-yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas agendadas'),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      backgroundColor: Colors.blue[50],
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final appt = appointments[index];
          return Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 120),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      appt['carImage'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${appt['brand']} ${appt['model']} (${appt['year']})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 18, color: Colors.indigo),
                            const SizedBox(width: 6),
                            Text(
                              dateFormat.format(appt['date']),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.indigo,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Colors.indigo, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              appt['user'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
