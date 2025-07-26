import 'package:car_app/Models/user.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Perfil de usuario'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Aquí puedes navegar a una pantalla de edición de perfil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función de editar próximamente')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/profile.jpg'),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nombre',
                        style: TextStyle(color: Colors.black54)),
                    Text(user.name, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Correo electrónico',
                        style: TextStyle(color: Colors.black54)),
                    Text(user.email, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            // Si tienes teléfono, descomenta y agrega el campo en el modelo User
            // const SizedBox(height: 16),
            // Card(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text('Teléfono', style: TextStyle(color: Colors.black54)),
            //         Text(user.phone ?? '-', style: const TextStyle(fontSize: 18)),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
