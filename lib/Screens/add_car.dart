import 'package:car_app/Models/car.dart';
import 'package:car_app/ViewModels/car_viewmodel.dart';
import 'package:car_app/Widgets/custom_button.dart';
import 'package:car_app/Widgets/custom_text_form_field.dart';
import 'package:car_app/Services/unsplash_service.dart'; // Asegúrate de tener este import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCarScreen extends StatefulWidget {
  final Car? car;
  const AddCarScreen({
    super.key,
    this.car,
  });

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController colorController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  final UnsplashService _unsplashService = UnsplashService();

  bool isEdit = false;
  bool isLoading = false;
  bool _isSearchingImages = false;

  List<String> _imageResults = [];
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();

    final car = widget.car;

    if (car != null) {
      isEdit = true;
      brandController.text = car.brand;
      modelController.text = car.model;
      colorController.text = car.color;
      yearController.text = car.year.toString();
      priceController.text = car.price.toString();
      _selectedImageUrl = car.imgURL; // Cargar imagen si está en edición
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        title: Text(isEdit ? 'Editar Vehículo' : 'Agregar Vehículo'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CustomTextFormField(
            paddingTop: 20.0,
            controller: brandController,
            hintText: "Ingresa la marca...",
            obscureText: false,
            labelText: "Marca",
            icon: Icons.car_repair,
          ),
          CustomTextFormField(
            controller: modelController,
            hintText: "Ingresa el modelo...",
            obscureText: false,
            labelText: "Modelo",
            icon: Icons.car_repair,
          ),
          CustomTextFormField(
            controller: colorController,
            hintText: "Ingresa el color...",
            obscureText: false,
            labelText: "Color",
            icon: Icons.color_lens,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  controller: yearController,
                  hintText: "Ingresa el año...",
                  obscureText: false,
                  labelText: "Año",
                  keyboardType: TextInputType.number,
                  icon: Icons.calendar_today,
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  controller: priceController,
                  hintText: "Ingresa el precio...",
                  obscureText: false,
                  labelText: "Precio",
                  keyboardType: TextInputType.number,
                  icon: Icons.money,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.image_search),
              label: const Text("Buscar imágenes"),
              onPressed: _searchImages,
            ),
          ),
          if (_isSearchingImages)
            const Center(child: CircularProgressIndicator())
          else if (_imageResults.isNotEmpty)
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageResults.length,
                itemBuilder: (context, index) {
                  final imageUrl = _imageResults[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageUrl = imageUrl;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedImageUrl == imageUrl
                              ? Colors.blue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.network(imageUrl),
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox.shrink(),
          if (_selectedImageUrl != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Imagen seleccionada:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Image.network(_selectedImageUrl!, height: 200),
                ],
              ),
            ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : CustomButton(
                  height: 50,
                  text: isEdit ? "Actualizar vehículo" : "Agregar vehículo",
                  onPressed: () {
                    if (_selectedImageUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Por favor selecciona una imagen.")),
                      );
                      return;
                    }
                    isEdit ? editCar() : addCar();
                  },
                ),
        ],
      ),
    );
  }

  Future<void> _searchImages() async {
    final query = "${brandController.text} ${modelController.text}";
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearchingImages = true;
      _imageResults = [];
      _selectedImageUrl = null;
    });

    try {
      final results = await _unsplashService.searchImages(query);
      setState(() {
        _imageResults = results;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al buscar imágenes: $e")),
      );
    } finally {
      setState(() {
        _isSearchingImages = false;
      });
    }
  }

  void addCar() async {
    setState(() {
      isLoading = true;
    });

    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.addCar(
      colorController,
      brandController,
      modelController,
      yearController,
      priceController,
      context,
      _selectedImageUrl, // Nueva imagen
    );

    setState(() {
      isLoading = false;
    });
  }

  void editCar() async {
    setState(() {
      isLoading = true;
    });

    final carViewModel = Provider.of<CarViewModel>(context, listen: false);
    await carViewModel.updateCar(
      widget.car!.id,
      colorController,
      brandController,
      modelController,
      yearController,
      priceController,
      context,
      _selectedImageUrl, // Imagen actualizada
    );

    setState(() {
      isLoading = false;
    });
  }
}
