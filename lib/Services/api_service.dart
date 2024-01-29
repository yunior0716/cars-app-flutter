import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.6:3001';

  //Cars routes

  Future<http.Response> addCar(Map<String, dynamic> carData) {
    return http.post(
      Uri.parse('$baseUrl/car'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(carData),
    );
  }

  Future<http.Response> getCars() {
    return http.get(Uri.parse('$baseUrl/cars'));
  }

  Future<http.Response> deleteCar(String id) {
    return http.delete(Uri.parse('$baseUrl/car/$id'));
  }

  Future<http.Response> updateCar(Map<String, dynamic> carData, String id) {
    return http.put(
      Uri.parse('$baseUrl/car/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(carData),
    );
  }

  //Auth routes
  Future<http.Response> registerUser(Map<String, dynamic> userData) {
    return http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
  }

  Future<http.Response> loginUser(Map<String, dynamic> userData) {
    return http.post(
      Uri.parse('$baseUrl/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
  }
}
