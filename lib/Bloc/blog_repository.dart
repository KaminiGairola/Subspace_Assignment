import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:subspace_assignment/Models/blog.dart';

import '../db_helper.dart';

class BlogRepository {
  final String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  final String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Blog>> fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('blogs')) {
          final List<dynamic> blogsJson = jsonResponse['blogs'];
          final List<Blog> blogs = blogsJson.map((blogJson) => Blog.fromJson(blogJson)).toList();

          // Cache blogs in SQLite
          for (var blog in blogs) {
            await _databaseHelper.insertBlog(blog);
          }

          return blogs;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load blogs');
      }
    } catch (e) {
      // Fetch from SQLite if network call fails
      return _databaseHelper.blogs();
    }
  }

  Future<void> updateBlog(Blog blog) async {
    await _databaseHelper.updateBlog(blog);
  }

  Future<void> addBlog(Blog blog) async {
    await _databaseHelper.insertBlog(blog);
  }

  Future<void> deleteBlog(String id) async {
    await _databaseHelper.deleteBlog(id);
  }
}
