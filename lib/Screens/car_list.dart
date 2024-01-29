import 'package:first_app/Models/car.dart';
import 'package:first_app/Screens/add_car.dart';
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
                    title: Text('${car.brand} - ${car.model}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${car.year} - ${formatCurrency.format(car.price)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
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
    // setState(() {
    //   isLoading = true;
    // });
    getCars();
  }

  Future<void> navigateToEditCar(Car car) async {
    final route = MaterialPageRoute(
      builder: (context) => AddCarScreen(car: car),
    );

    await Navigator.push(context, route);
    getCars();
  }

  void getCars() async {
    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    final carResult = await carViewModel.getCars(showErrorMessage);

    setState(() {
      cars = carResult;
    });

    setState(() {
      isLoading = false;
    });
  }

  void deleteCar(String id) async {
    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.deleteCar(id, showSuccesMessage, showErrorMessage);

    getCars();
  }

  void showSuccesMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
