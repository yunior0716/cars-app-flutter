import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static String routeName = 'NotificationScreen';
  static String routePath = '/notification';

  @override
  Widget build(BuildContext context) {
    // Ejemplo de notificaciones (puedes reemplazarlo por tu lógica)
    final List<Map<String, String>> notifications = [
      {
        'title': 'Cita confirmada',
        'text': 'Tu cita ha sido confirmada para el 10/07/2025 a las 15:00.',
        'time': 'Hace 2 horas',
      },
      {
        'title': 'Nuevo mensaje',
        'text': 'Tienes un nuevo mensaje de soporte.',
        'time': 'Hace 1 día',
      },
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          elevation: 0,
          centerTitle: true,
          title: const Text('Notificaciones'),
        ),
        body: SafeArea(
          child: notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes notificaciones',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: notifications.length,
                  itemBuilder: (context, i) {
                    final n = notifications[i];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications, color: Colors.blue, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    n['text'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Text(
                                    n['time'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue[600],
                                    ),
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
        ),
      ),
    );
  }
}
