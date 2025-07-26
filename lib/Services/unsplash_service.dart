import 'dart:convert';
import 'package:http/http.dart' as http;

class UnsplashService {
  final String _apiKey = 'Jy0T-43LSgNc8Wdt4V2ozSMR_NLlZYUh6Y7AbEk5T-c';

  Future<List<String>> searchImages(String query) async {
    final url = Uri.parse(
      'https://api.unsplash.com/search/photos?query=$query&per_page=20&client_id=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> imageUrls = [];

      for (var item in data['results']) {
        imageUrls.add(item['urls']['regular']);
      }
      return imageUrls;
    } else {
      throw Exception('Error fetching images: ${response.statusCode}');
    }
  }
}
