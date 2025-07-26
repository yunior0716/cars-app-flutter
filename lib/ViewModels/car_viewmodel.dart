import 'dart:convert';

import 'package:car_app/Models/car.dart';
import 'package:car_app/Services/api_service.dart';
import 'package:flutter/material.dart';

class CarViewModel extends ChangeNotifier {
  final apiService = ApiService();

  Future<void> addCar(
    TextEditingController colorController,
    TextEditingController brandController,
    TextEditingController modelController,
    TextEditingController yearController,
    TextEditingController priceController,
    dynamic context,
    String? imageUrl,
  ) async {
    if (colorController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos', context);
      return;
    }

    final car = Car(
      color: colorController.text,
      brand: brandController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      price: double.parse(priceController.text),
      imgURL: imageUrl,
    );

    try {
      final response = await apiService.addCar(car.toJson());

      if (response.statusCode == 200) {
        // print('Calling showSuccesMessage()');

        colorController.text = '';
        brandController.text = '';
        modelController.text = '';
        yearController.text = '';
        priceController.text = '';

        showSuccesMessage('Vehículo agregado exitosamente', context);
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('No se pudo agregar el vehículo', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<List<Car>> getCars(
    dynamic context,
  ) async {
    try {
      final response = await apiService.getCars();

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        final cars = json.map((car) => Car.fromJson(car)).toList();

        return cars;
      } else {
        showErrorMessage('No se pudo obtener los vehículos', context);
        return [];
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return [];
    }
  }

  Future<void> deleteCar(
    String id,
    dynamic context,
  ) async {
    try {
      final response = await apiService.deleteCar(id);

      if (response.statusCode == 200) {
        showSuccesMessage('Vehículo eliminado exitosamente', context);
      } else {
        showErrorMessage('No se pudo eliminar el vehículo', context);
        return;
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<void> updateCar(
    String id,
    TextEditingController colorController,
    TextEditingController brandController,
    TextEditingController modelController,
    TextEditingController yearController,
    TextEditingController priceController,
    dynamic context,
    String? imageUrl,
  ) async {
    final car = Car(
      color: colorController.text,
      brand: brandController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      price: double.parse(priceController.text),
      imgURL: imageUrl,
    );

    try {
      final response = await apiService.updateCar(car.toJson(), id);

      if (response.statusCode == 200) {
        // print('Calling showSuccesMessage()');

        colorController.text = '';
        brandController.text = '';
        modelController.text = '';
        yearController.text = '';
        priceController.text = '';

        showSuccesMessage('Vehículo actualizado exitosamente', context);
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('No se pudo actualizar el vehículo', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  showSuccesMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[300],
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showErrorMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[300],
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
