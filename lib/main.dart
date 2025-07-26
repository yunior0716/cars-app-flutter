import 'package:car_app/Screens/home_screen.dart';
import 'package:car_app/Screens/login_screen.dart';
import 'package:car_app/ViewModels/auth_viewmodel.dart';
import 'package:car_app/ViewModels/car_viewmodel.dart';
import 'package:car_app/ViewModels/client_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
        ChangeNotifierProvider(create: (context) => CarViewModel()),
        ChangeNotifierProvider(create: (context) => ClientViewModel()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
