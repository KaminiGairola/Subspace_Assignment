import 'package:flutter/material.dart';
import '../Models/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          blog.title,
          style: TextStyle(
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, // Ensure the icon and text are white
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            blog.imageUrl != null
                ? Container(
              width: double.infinity,
              height: 250, // Adjust height as needed
              child: Image.network(
                blog.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return Icon(Icons.broken_image, size: 50, color: Colors.white);
                },
              ),
            )
                : Container(
              width: double.infinity,
              height: 250, // Adjust height as needed
              color: Colors.grey[300], // Placeholder color
              child: Icon(Icons.broken_image, size: 50, color: Colors.white),
            ),
            // Text section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                blog.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Add more details here if available
          ],
        ),
      ),
    );
  }
}
