import 'package:car_app/Screens/book_appointment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarDetailScreen extends StatelessWidget {
  // Datos ficticios, luego puedes reemplazar por los del modelo Car
  final List<String> images;
  final String brand;
  final String model;
  final int year;
  final String color;
  final double price;
  final String description;
  final String transmission;
  final int seats;
  final int horsepower;
  final String fuelType;
  final int topSpeed;
  final double acceleration;

  const CarDetailScreen({
    super.key,
    this.images = const [
      'images/logo.png',
      'images/logo.png',
      'images/logo.png',
      'images/logo.png',
    ],
    this.brand = 'Toyota',
    this.model = 'Fortuner Legender',
    this.year = 2022,
    this.color = 'Negro',
    this.price = 3200000,
    this.description =
        'Vehículo SUV familiar, cómodo y potente. Motor diésel, ideal para ciudad y carretera.',
    this.transmission = 'Automática',
    this.seats = 7,
    this.horsepower = 3420,
    this.fuelType = 'Diésel',
    this.topSpeed = 190,
    this.acceleration = 11.2,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
        locale: 'en_US', symbol: 'RD\$', decimalDigits: 0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del vehículo'),
        backgroundColor: Colors.blue[200],
        elevation: 0,
      ),
      backgroundColor: Colors.blue[50],
      body: ListView(
        children: [
          // Imagen única del vehículo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: images.first.startsWith('http')
                  ? Image.network(
                      images.first,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      images.first,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Título y precio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$brand $model',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text('$year · $color',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700])),
                  ],
                ),
                Text(
                  formatter.format(price),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Características principales en grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.25,
              children: [
                _FeatureBox(
                  icon: Icons.settings,
                  label: 'Transmisión',
                  value: transmission,
                ),
                _FeatureBox(
                  icon: Icons.event_seat,
                  label: 'Asientos',
                  value: '$seats',
                ),
                _FeatureBox(
                  icon: Icons.speed,
                  label: 'HP',
                  value: '$horsepower',
                ),
                _FeatureBox(
                  icon: Icons.local_gas_station,
                  label: 'Combustible',
                  value: fuelType,
                ),
                _FeatureBox(
                  icon: Icons.directions_car,
                  label: 'Vel. Máx',
                  value: '$topSpeed km/h',
                ),
                _FeatureBox(
                  icon: Icons.flash_on,
                  label: '0-100 km/h',
                  value: '$acceleration s',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Descripción',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Botón para agendar cita
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookAppointmentScreen(
                      carName: '$brand $model',
                      carImage: images.first,
                    ),
                  ),
                );
              },
              child: const Text('Agendar cita', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FeatureBox(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 13, color: Colors.black54)),
        Text(value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
