import 'package:first_app/Models/User.dart';
import 'package:first_app/Models/auth.dart';
import 'package:first_app/Services/api_service.dart';
import 'package:flutter/material.dart';

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
    void Function(String) showSuccesMessage,
    void Function(String) showErrorMessage,
  ) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorMessage('Please fill in all fields');
      return;
    }

    if (!validatePassword(
        passwordController.text, confirmPasswordController.text)) {
      showErrorMessage('Password dont match');
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

        showSuccesMessage('User added successfully');
      } else {
        showErrorMessage('Unable to add user');
      }
    } catch (e) {
      showErrorMessage('Failed to connect to server');
    }
  }

  Future<void> loginUser(
    TextEditingController emailController,
    TextEditingController passwordController,
    void Function(String) showSuccesMessage,
    void Function(String) showErrorMessage,
    void Function() navigate,
  ) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage('Please fill in all fields');
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

        showSuccesMessage('Signin successfully');
        navigate();
      } else {
        showErrorMessage('Email or password incorrect');
      }
    } catch (e) {
      showErrorMessage('Failed to connect to server');
    }
  }
}
