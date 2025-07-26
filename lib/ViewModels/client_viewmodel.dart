import 'dart:convert';

import 'package:car_app/Models/client.dart';
import 'package:car_app/Services/api_service.dart';
import 'package:flutter/material.dart';

class ClientViewModel extends ChangeNotifier {
  final apiService = ApiService();

  Future<void> addClient(
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController addressController,
    dynamic context,
  ) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos', context);
      return;
    }

    final client = Client(
      name: nameController.text,
      email: emailController.text,
      phone: double.parse(phoneController.text),
      address: addressController.text,
    );

    try {
      final response = await apiService.addClient(client.toJson());

      if (response.statusCode == 200) {
        // print('Calling showSuccesMessage()');

        nameController.text = '';
        emailController.text = '';
        phoneController.text = '';
        addressController.text = '';

        showSuccesMessage('Cliente agregado exitosamente', context);
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('No se pudo agregar el cliente', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<List<Client>> getClients(
    dynamic context,
  ) async {
    try {
      final response = await apiService.getClients();

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        final clients = json.map((client) => Client.fromJson(client)).toList();

        return clients;
      } else {
        showErrorMessage('No se pudo obtener los clientes', context);
        return [];
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return [];
    }
  }

  Future<void> deleteClient(
    String id,
    dynamic context,
  ) async {
    try {
      final response = await apiService.deleteClient(id);

      if (response.statusCode == 200) {
        showSuccesMessage('Cliente eliminado exitosamente', context);
      } else {
        showErrorMessage('No se pudo eliminar el cliente', context);
        return;
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<void> updateClient(
    String id,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
    TextEditingController addressController,
    dynamic context,
  ) async {
    final client = Client(
      name: nameController.text,
      email: emailController.text,
      phone: double.parse(phoneController.text),
      address: addressController.text,
    );

    try {
      final response = await apiService.updateClient(client.toJson(), id);

      if (response.statusCode == 200) {
        // print('Calling showSuccesMessage()');

        nameController.text = '';
        emailController.text = '';
        phoneController.text = '';
        addressController.text = '';

        showSuccesMessage('Cliente actualizado exitosamente', context);
      } else {
        // print('Calling showErrorMessage()');
        showErrorMessage('No se pudo actualizar el cliente', context);
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
