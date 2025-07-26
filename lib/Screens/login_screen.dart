import 'package:car_app/Screens/home_screen.dart';
import 'package:car_app/Screens/signup_screen.dart';
import 'package:car_app/ViewModels/auth_viewmodel.dart';
import 'package:car_app/Widgets/custom_button.dart';
import 'package:car_app/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Image.asset('images/logo.png'),
              ),
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
              isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomButton(
                      height: 50,
                      text: 'Iniciar sesión',
                      onPressed: () {
                        login();
                      },
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  child: Text("¿No tienes cuenta? ¡Regístrate!",
                      style: TextStyle(color: Colors.blue[600], fontSize: 14)),
                  onTap: () {
                    navigateToSignup();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToSignup() {
    final route = MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    );

    Navigator.push(context, route);
  }

  void navigateToHomeScreen() {
    final route = MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
    Navigator.pushReplacement(context, route);
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.loginUser(emailController, passwordController, context,
        () {
      navigateToHomeScreen();
    });

    setState(() {
      isLoading = false;
    });
  }
}
