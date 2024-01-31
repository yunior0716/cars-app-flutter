import 'dart:convert';

import 'package:first_app/Models/car.dart';
import 'package:first_app/Services/api_service.dart';
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
  ) async {
    if (colorController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty) {
      await showErrorMessage('Please fill in all fields', context);
      return;
    }

    final car = Car(
      color: colorController.text,
      brand: brandController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      price: double.parse(priceController.text),
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

        await showSuccesMessage('Car added successfully', context);
      } else {
        // print('Calling showErrorMessage()');
        await showErrorMessage('Unable to add car', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      await showErrorMessage('Failed to connect to server', context);
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
        await showErrorMessage('Unable to get cars', context);
        return [];
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
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
        await showSuccesMessage('Car deleted successfully', context);
      } else {
        await showErrorMessage('Unable to delete car', context);
        return;
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
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
  ) async {
    final car = Car(
      color: colorController.text,
      brand: brandController.text,
      model: modelController.text,
      year: int.parse(yearController.text),
      price: double.parse(priceController.text),
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

        await showSuccesMessage('Car updated successfully', context);
      } else {
        // print('Calling showErrorMessage()');
        await showErrorMessage('Unable to update car', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      await showErrorMessage('Failed to connect to server', context);
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
