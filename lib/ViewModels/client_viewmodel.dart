import 'dart:convert';

import 'package:first_app/Models/client.dart';
import 'package:first_app/Services/api_service.dart';
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
      await showErrorMessage('Please fill in all fields', context);
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

        await showSuccesMessage('Client added successfully', context);
      } else {
        // print('Calling showErrorMessage()');
        await showErrorMessage('Unable to add client', context);
        return;
      }
    } catch (e) {
      // print('Caught exception: $e');
      // print('Calling showErrorMessage()');
      await showErrorMessage('Failed to connect to server', context);
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
        await showErrorMessage('Unable to get cars', context);
        return [];
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
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
        await showSuccesMessage('Client deleted successfully', context);
      } else {
        await showErrorMessage('Unable to delete client', context);
        return;
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
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

        await showSuccesMessage('Client updated successfully', context);
      } else {
        // print('Calling showErrorMessage()');
        await showErrorMessage('Unable to update client', context);
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
