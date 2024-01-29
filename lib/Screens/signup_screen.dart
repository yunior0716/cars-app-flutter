import 'package:first_app/Screens/car_list.dart';
import 'package:first_app/ViewModels/auth_viewmodel.dart';
import 'package:first_app/Widgets/custom_button.dart';
import 'package:first_app/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: const Text('Sign up'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            CustomTextFormField(
                paddingTop: 20.0,
                controller: nameController,
                hintText: "Enter your name...",
                obscureText: false,
                icon: Icons.person,
                labelText: "Name"),
            CustomTextFormField(
              controller: emailController,
              hintText: "Enter your email...",
              obscureText: false,
              labelText: "Email",
              icon: Icons.email,
            ),
            CustomTextFormField(
              controller: passwordController,
              hintText: "Enter your password...",
              obscureText: true,
              labelText: "Password",
              icon: Icons.lock,
            ),
            CustomTextFormField(
              controller: confirmPasswordController,
              hintText: "Confirm your password...",
              obscureText: true,
              labelText: "Confirm password",
              icon: Icons.lock,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomButton(
                height: 50,
                text: "Sign up",
                onPressed: () {
                  postUser();
                },
              ),
            ),
          ],
        ));
  }

  void navigateToCarList() {
    final route = MaterialPageRoute(
      builder: (context) => const CarListScreen(),
    );

    Navigator.push(context, route);
  }

  Future<void> postUser() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.registerUser(
        nameController,
        emailController,
        passwordController,
        confirmPasswordController,
        showSuccesMessage,
        showErrorMessage);
  }

  void showSuccesMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.blue[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[300],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
