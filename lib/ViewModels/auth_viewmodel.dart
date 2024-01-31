import 'package:first_app/Models/User.dart';
import 'package:first_app/Models/auth.dart';
import 'package:first_app/Services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  final apiService = ApiService();

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
      await showErrorMessage('Please fill in all fields', context);
      return;
    }

    if (!validatePassword(
        passwordController.text, confirmPasswordController.text)) {
      await showErrorMessage('Password dont match', context);
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

        await showSuccesMessage('User added successfully', context);
      } else {
        await showErrorMessage('Unable to add user', context);
        return;
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
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
      await showErrorMessage('Please fill in all fields', context);
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
        emailController.text = '';
        passwordController.text = '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        // await showSuccesMessage('Signin successfully', context);
        navigate();
      } else {
        await showErrorMessage('Email or password incorrect', context);
        return;
      }
    } catch (e) {
      await showErrorMessage('Failed to connect to server', context);
      return;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  showSuccesMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[300],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showErrorMessage(String message, dynamic context) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[300],
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
