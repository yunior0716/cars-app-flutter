import 'package:first_app/Models/car.dart';
import 'package:first_app/Screens/add_car.dart';
import 'package:first_app/Screens/add_client.dart';
import 'package:first_app/Screens/client_list.dart';
import 'package:first_app/Screens/login_screen.dart';
import 'package:first_app/ViewModels/auth_viewmodel.dart';
import 'package:first_app/ViewModels/car_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List<Car> cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCars();
  }

  final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: const Text('Car List'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                logout();
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
                  child: Text('Menu',
                      style: TextStyle(
                        fontSize: 24,
                      ))),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Customers', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  navigateToClientList();
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                border: Border.all(color: Colors.indigoAccent, width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: const Center(
                    child: Text('Logout', style: TextStyle(fontSize: 18))),
                onTap: () {
                  Navigator.pop(context);

                  logout();
                },
              ),
            ),
          ],
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: () async {
            getCars();
          },
          child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                final id = car.id;
                return Card(
                  color: Colors.blue[50],
                  child: ListTile(
                    leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: car.imgURL != "" && car.imgURL != null
                              ? NetworkImage(car.imgURL!)
                              : const AssetImage('images/rentcar.jpg')
                                  as ImageProvider<Object>,
                        ),
                      ),
                    ),
                    title: Text('${car.brand} ${car.model}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(car.year.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 7),
                        Text(formatCurrency.format(car.price),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[600]))
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditCar(car);
                        } else if (value == 'delete') {
                          deleteCar(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: navigateToCarRegister,
        label: const Text('Add Car'),
      ),
    );
  }

  Future<void> navigateToCarRegister() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddCarScreen(),
    );

    await Navigator.push(context, route);
    getCars();
  }

  Future<void> navigateToClientList() async {
    final route = MaterialPageRoute(
      builder: (context) => const ClientListScreen(),
    );

    await Navigator.push(context, route);
  }

  Future<void> navigateToClientRegister() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddClientScreen(),
    );

    await Navigator.push(context, route);
  }

  Future<void> navigateToEditCar(Car car) async {
    final route = MaterialPageRoute(
      builder: (context) => AddCarScreen(car: car),
    );

    await Navigator.push(context, route);
    getCars();
  }

  Future<void> logout() async {
    final authViewModel = Provider.of<UserViewModel>(context, listen: false);
    authViewModel.logout();

    final route = MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );

    await Navigator.pushReplacement(context, route);
  }

  void getCars() async {
    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    final carResult = await carViewModel.getCars(context);

    setState(() {
      cars = carResult;
    });

    setState(() {
      isLoading = false;
    });
  }

  void deleteCar(String id) async {
    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.deleteCar(id, context);

    getCars();
  }
}
