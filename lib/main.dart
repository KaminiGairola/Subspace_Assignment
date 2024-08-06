import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspace_assignment/BLoC/blog_bloc.dart';
import 'package:subspace_assignment/BLoC/blog_repository.dart';
import 'package:subspace_assignment/Screen/blog_list_screen.dart';
import 'package:subspace_assignment/Screen/splash_screen.dart'; // Import the splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/blogList': (context) => BlocProvider(
          create: (context) => BlogBloc(blogRepository: BlogRepository())..add(BlogFetchEvent()),
          child: BlogListScreen(),
        ),
      },
    );
  }
}