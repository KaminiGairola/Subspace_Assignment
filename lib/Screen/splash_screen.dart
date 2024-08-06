import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspace_assignment/BLoC/blog_bloc.dart';
import 'package:subspace_assignment/Screen/blog_list_screen.dart';

import '../BLoC/blog_repository.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => BlogBloc(blogRepository: BlogRepository())..add(BlogFetchEvent()),
              child: BlogListScreen(),
            ),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[850]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: _animation,
                  child: Image.network(
                    'https://play-lh.googleusercontent.com/l1cu4ndpgcfawgOzOVmWS1Z-N8iVIqlfTfU3UcoYxGp3Jbjv9at5gs3dLWMR-6eWfFoW', // URL of your image
                    height: 120, // Adjust the height as needed
                    width: 120, // Adjust the width as needed
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.white); // Error icon in case image fails to load
                    },
                  ),
                ),
              ),
              SizedBox(height: 30), // Space between the image and text
              Text(
                'Blog Explorer',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 28, // Font size
                  fontWeight: FontWeight.bold, // Bold text
                  shadows: [
                    Shadow(
                      offset: Offset(3, 3),
                      blurRadius: 6,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}