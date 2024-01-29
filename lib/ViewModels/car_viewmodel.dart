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
    void Function(String) showSuccesMessage,
    void Function(String) showErrorMessage,
  ) async {
    if (colorController.text.isEmpty ||
        brandController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        priceController.text.isEmpty) {
      showErrorMessage('Please fill in all fields');
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

        showSuccesMessage('Car added successfully');
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('Unable to add car');
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      showErrorMessage('Failed to connect to server');
    }
  }

  Future<List<Car>> getCars(
    void Function(String) showErrorMessage,
  ) async {
    try {
      final response = await apiService.getCars();

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        final cars = json.map((car) => Car.fromJson(car)).toList();

        return cars;
      } else {
        showErrorMessage('Unable to get cars');
        return [];
      }
    } catch (e) {
      showErrorMessage('Failed to connect to server');
      return [];
    }
  }

  Future<void> deleteCar(
    String id,
    void Function(String) showSuccesMessage,
    void Function(String) showErrorMessage,
  ) async {
    try {
      final response = await apiService.deleteCar(id);

      if (response.statusCode == 200) {
        showSuccesMessage('Car deleted successfully');
      } else {
        showErrorMessage('Unable to delete car');
      }
    } catch (e) {
      showErrorMessage('Failed to connect to server');
    }
  }

  Future<void> updateCar(
    String id,
    TextEditingController colorController,
    TextEditingController brandController,
    TextEditingController modelController,
    TextEditingController yearController,
    TextEditingController priceController,
    void Function(String) showSuccesMessage,
    void Function(String) showErrorMessage,
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

        showSuccesMessage('Car updated successfully');
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('Unable to update car');
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      showErrorMessage('Failed to connect to server');
    }
  }
}
