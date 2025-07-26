import 'package:car_app/Models/user.dart';
import 'package:car_app/Models/auth.dart';
import 'package:car_app/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserViewModel extends ChangeNotifier {
  final apiService = ApiService();
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool validatePassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return false;
    }

    return true;
  }

  Future<void> registerUser(
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
    dynamic context,
  ) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos', context);
      return;
    }

    if (!validatePassword(
        passwordController.text, confirmPasswordController.text)) {
      showErrorMessage('Las contraseñas no coinciden', context);
      return;
    }

    final user = User(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      final response = await apiService.registerUser(user.toJson());

      if (response.statusCode == 200) {
        // print('User registered successfully');
        nameController.text = '';
        emailController.text = '';
        passwordController.text = '';
        confirmPasswordController.text = '';

        showSuccesMessage('Usuario agregado exitosamente', context);
      } else {
        showErrorMessage('No se pudo agregar el usuario', context);
        return;
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<void> loginUser(
    TextEditingController emailController,
    TextEditingController passwordController,
    dynamic context,
    void Function() navigate,
  ) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage('Por favor, complete todos los campos', context);
      return;
    }
    final user = Auth(
      email: emailController.text,
      password: passwordController.text,
    );

    try {
      final response = await apiService.loginUser(user.toJson());

      if (response.statusCode == 200) {
        // print('User logged in successfully');

        final data = jsonDecode(response.body);
        _currentUser =
            User.fromJson(data['user']); // <-- OJO: accede a la clave 'user'
        notifyListeners();

        emailController.text = '';
        passwordController.text = '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // showSuccesMessage('Signin successfully', context);
        navigate();
      } else {
        showErrorMessage('Email o contraseña incorrectos', context);
        return;
      }
    } catch (e) {
      showErrorMessage('Error al conectar al servidor', context);
      return;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  void showSuccesMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[300],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[300],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
