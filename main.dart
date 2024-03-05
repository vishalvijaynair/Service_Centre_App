import 'package:flutter/material.dart';
import 'authentication_page.dart';

void main() => runApp(CarServiceApp());

class CarServiceApp extends StatelessWidget {
  // Simulate some initialization process
  Future<void> _initializeApp(BuildContext context) async {
    await Future.delayed(Duration(seconds: 3)); // Simulating a delay of 2 seconds

    // After initialization is complete, navigate to AuthenticationPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthenticationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Initialization is complete, return your app's main screen
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Car Service App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              colorScheme: ColorScheme.fromSwatch(
                accentColor: Colors.amber,
              ), // Accent color directly under ThemeData
              fontFamily: 'Montserrat', // Your selected font
            ),
            home: AuthenticationPage(),
          );
        } else {
          // Show a loading indicator while waiting for initialization to complete
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1625047509252-ab38fb5c7343?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2FyJTIwc2VydmljZXxlbnwwfDF8MHx8fDA%3D', // Replace with your actual image URL
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
