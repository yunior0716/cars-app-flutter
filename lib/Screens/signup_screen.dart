import 'package:car_app/ViewModels/auth_viewmodel.dart';
import 'package:car_app/Widgets/custom_button.dart';
import 'package:car_app/Widgets/custom_text_form_field.dart';
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
          title: const Text('Registrarse'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            CustomTextFormField(
                paddingTop: 20.0,
                controller: nameController,
                hintText: "Ingresa tu nombre...",
                obscureText: false,
                icon: Icons.person,
                labelText: "Nombre"),
            CustomTextFormField(
              controller: emailController,
              hintText: "Ingresa tu correo electrónico...",
              obscureText: false,
              labelText: "Correo electrónico",
              icon: Icons.email,
            ),
            CustomTextFormField(
              controller: passwordController,
              hintText: "Ingresa tu contraseña...",
              obscureText: true,
              labelText: "Contraseña",
              icon: Icons.lock,
            ),
            CustomTextFormField(
              controller: confirmPasswordController,
              hintText: "Confirma tu contraseña...",
              obscureText: true,
              labelText: "Confirmar contraseña",
              icon: Icons.lock,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomButton(
                height: 50,
                text: "Registrarse",
                onPressed: () {
                  postUser();
                },
              ),
            ),
          ],
        ));
  }

  Future<void> postUser() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.registerUser(
      nameController,
      emailController,
      passwordController,
      confirmPasswordController,
      context,
    );
  }
}
