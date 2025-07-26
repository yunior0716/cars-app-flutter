import 'package:car_app/Models/car.dart';
import 'package:car_app/ViewModels/car_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:car_app/Screens/car_detail.dart';

class CarCatalogScreen extends StatefulWidget {
  const CarCatalogScreen({super.key});

  @override
  State<CarCatalogScreen> createState() => _CarCatalogScreenState();
}

class _CarCatalogScreenState extends State<CarCatalogScreen> {
  List<Car> cars = [];
  List<Car> filteredCars = [];
  String searchQuery = '';
  String? selectedBrand;
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
        final matchesQuery =
            car.brand.toLowerCase().contains(searchQuery.toLowerCase()) ||
                car.model.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesBrand =
            selectedBrand == null || car.brand == selectedBrand;
        return matchesQuery && matchesBrand;
      }).toList();
    });
  }

  List<String> getPopularBrands() {
    final brands = cars.map((car) => car.brand).toSet().toList();
    brands.sort();
    return brands.take(4).toList();
  }

  @override
  Widget build(BuildContext context) {
    final brands = getPopularBrands();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: const Text('Catálogo de vehículos'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar por marca o modelo',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      searchQuery = value;
                      filterCars();
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Todos'),
                        selected: selectedBrand == null,
                        onSelected: (_) {
                          setState(() {
                            selectedBrand = null;
                            filterCars();
                          });
                        },
                      ),
                      ...brands.map((brand) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(brand),
                              selected: selectedBrand == brand,
                              onSelected: (_) {
                                setState(() {
                                  selectedBrand = brand;
                                  filterCars();
                                });
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filteredCars.isEmpty
                      ? const Center(
                          child: Text('No hay vehículos disponibles'))
                      : ListView.builder(
                          itemCount: filteredCars.length,
                          itemBuilder: (context, index) {
                            final car = filteredCars[index];
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
                                        fuelType: 'Diésel',
                                        topSpeed: 190,
                                        acceleration: 11.2,
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
}
