import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:car_app/Screens/booking_success.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String carName;
  final String carImage;
  const BookAppointmentScreen({
    super.key,
    required this.carName,
    required this.carImage,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  bool? isAvailable;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd-MM-yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cita'),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      backgroundColor: Colors.blue[50],
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Card con datos del auto
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.carImage.startsWith('http')
                      ? Image.network(widget.carImage,
                          width: 90, height: 80, fit: BoxFit.cover)
                      : Image.asset(widget.carImage,
                          width: 90, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.carName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Selecciona la fecha de tu cita',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.blue.shade200,
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: Colors.black87,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                  // Simula disponibilidad aleatoria
                  isAvailable = picked.day % 2 == 0;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.indigo),
                  const SizedBox(width: 16),
                  Text(
                    selectedDate != null
                        ? formatter.format(selectedDate!)
                        : 'Elegir fecha',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (selectedDate != null)
            Row(
              children: [
                Icon(
                  isAvailable == true ? Icons.check_circle : Icons.cancel,
                  color: isAvailable == true ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  isAvailable == true
                      ? '¡Fecha disponible!'
                      : 'No disponible en esa fecha',
                  style: TextStyle(
                    color: isAvailable == true ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 36),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: selectedDate != null && isAvailable == true
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingSuccessScreen(),
                      ),
                    );
                  }
                : null,
            child: const Text('Confirmar cita', style: TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
