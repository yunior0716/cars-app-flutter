import 'package:first_app/Screens/car_list.dart';
import 'package:first_app/Screens/signup_screen.dart';
import 'package:first_app/ViewModels/auth_viewmodel.dart';
import 'package:first_app/Widgets/custom_button.dart';
import 'package:first_app/Widgets/custom_text_form_field.dart';
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
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset('images/rentcar.jpg'),
              ),
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
                      text: 'Login',
                      onPressed: () {
                        login();
                      },
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  child: Text("Don't have an account? Sign up!",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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

  void navigateToCarList() {
    final route = MaterialPageRoute(
      builder: (context) => const CarListScreen(),
    );

    // Navigator.push(context, route);
    Navigator.pushReplacement(context, route);
  }

  void navigateToSignup() {
    final route = MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    );

    Navigator.push(context, route);
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.loginUser(emailController, passwordController, context,
        () {
      navigateToCarList();
    });

    setState(() {
      isLoading = false;
    });
  }
}
