import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_app/Services/unsplash_service.dart';

class ImageSearchScreen extends StatefulWidget {
  final Function(String imageUrl) onImageSelected;

  const ImageSearchScreen({required this.onImageSelected, super.key});

  @override
  ImageSearchScreenState createState() => ImageSearchScreenState();
}

class ImageSearchScreenState extends State<ImageSearchScreen> {
  final UnsplashService _unsplashService = UnsplashService();
  final TextEditingController _searchController = TextEditingController();

  List<String> _images = [];
  bool _loading = false;

  void _search() async {
    setState(() => _loading = true);
    try {
      final results =
          await _unsplashService.searchImages(_searchController.text);
      setState(() {
        _images = results;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Vehicle Images")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                labelText: "Enter vehicle model...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          _loading
              ? const CircularProgressIndicator()
              : Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.onImageSelected(_images[index]);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CachedNetworkImage(
                            imageUrl: _images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }
}
