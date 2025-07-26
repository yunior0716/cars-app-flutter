import 'package:car_app/Screens/appointments_admin.dart';
import 'package:car_app/Screens/car_catalog.dart';
import 'package:car_app/Models/car.dart';
import 'package:car_app/Screens/car_list.dart';
import 'package:car_app/ViewModels/car_viewmodel.dart';
import 'package:car_app/Screens/car_detail.dart';
import 'package:car_app/Screens/client_list.dart';
import 'package:car_app/Screens/login_screen.dart';
import 'package:car_app/Screens/user_profile.dart';
import 'package:car_app/Screens/notification_screen.dart';
import 'package:car_app/ViewModels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> cars = [];
  List<Car> filteredCars = [];
  String searchQuery = '';
  bool isLoading = true;

  final formatCurrency = NumberFormat.currency(
    locale: 'en_US', // Coma para miles, sin decimales
    symbol: 'RD\$',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    getCars();
  }

  void getCars() async {
    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    final carResult = await carViewModel.getCars(context);
    setState(() {
      cars = carResult;
      filteredCars = carResult;
      isLoading = false;
    });
  }

  void filterCars() {
    setState(() {
      filteredCars = cars.where((car) {
        return car.brand.toLowerCase().contains(searchQuery.toLowerCase()) ||
            car.model.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context).currentUser;
    final userName = user?.name ?? 'Usuario';

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: const Text('Inicio'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                  child: Text('Menú',
                      style: TextStyle(
                        fontSize: 24,
                      ))),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Mi perfil', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);
                  // Obtiene el usuario actual desde UserViewModel
                  final userViewModel =
                      Provider.of<UserViewModel>(context, listen: false);
                  final user = userViewModel.currentUser;
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen(user: user)),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No hay usuario en sesión')),
                    );
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Catálogo de vehículos',
                        style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CarCatalogScreen()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Vehículos', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  navigateToCarList(context);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Clientes', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  navigateToClientList(context);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Citas agendadas',
                        style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppointmentsAdminScreen()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child:
                        Text('Cerrar sesión', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  logout(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // HEADER: saludo, notificaciones y buscador
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Hola, $userName 👋',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none,
                                color: Colors.indigo, size: 28),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Buscar por marca o modelo',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                            filterCars();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Tarjeta de bienvenida
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '¡Bienvenido a CarApp!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Aquí podrás explorar nuestros vehículos, agendar citas y más.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Últimos vehículos
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Últimos vehículos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredCars.isEmpty
                      ? const Center(
                          child: Text('No hay vehículos disponibles'))
                      : ListView.builder(
                          itemCount:
                              filteredCars.length > 3 ? 3 : filteredCars.length,
                          itemBuilder: (context, index) {
                            final car =
                                filteredCars[filteredCars.length - 1 - index];
                            return Card(
                              color: Colors.blue[50],
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: car.imgURL != null && car.imgURL != ''
                                    ? Image.network(car.imgURL!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover)
                                    : Image.asset('images/rentcar.jpg',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover),
                                title: Text('${car.brand} ${car.model}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Año: ${car.year}'),
                                    Text('Color: ${car.color}'),
                                  ],
                                ),
                                trailing: Text(
                                  formatCurrency.format(car.price),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[600],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CarDetailScreen(
                                        images: [
                                          car.imgURL != null &&
                                                  car.imgURL!.isNotEmpty
                                              ? car.imgURL!
                                              : 'images/logo.png',
                                        ],
                                        brand: car.brand,
                                        model: car.model,
                                        year: car.year,
                                        color: car.color,
                                        price: car.price.toDouble(),
                                        description:
                                            'Descripción de ejemplo para el vehículo ${car.brand} ${car.model}.',
                                        transmission: 'Automática',
                                        seats: 7,
                                        horsepower: 3420,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final authViewModel = Provider.of<UserViewModel>(context, listen: false);
    authViewModel.logout();

    final route = MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );

    await Navigator.pushReplacement(context, route);
  }

  Future<void> navigateToClientList(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => const ClientListScreen(),
    );

    await Navigator.push(context, route);
  }

  Future<void> navigateToCarList(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => const CarListScreen(),
    );

    await Navigator.push(context, route);
  }
}
