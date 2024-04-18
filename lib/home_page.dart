import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/my_works.dart';
import 'package:service_centre/search_page.dart';
import 'package:service_centre/service_center_details_page.dart';
import 'package:service_centre/user_card.dart'; // Import your OrderCard widget

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<DocumentSnapshot>> _ordersPlaced;
  List<String> imagePaths = [
    'assets/img1.png',
    'assets/img2.png',
    'assets/img3.png',
    'assets/img4.png',
    'assets/img5.png',
    'assets/img6.png',
    'assets/img7.png',
  ];
  int imageIndex = 0;


  @override
  void initState() {
    super.initState();
    _ordersPlaced = _fetchOrdersPlaced();
  }

Future<List<DocumentSnapshot>> _fetchOrdersPlaced() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Orders_placed')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('orders')
        .get();
    List<DocumentSnapshot> ordersPlaced = querySnapshot.docs;
    return ordersPlaced;
  } catch (e) {
    print('Error fetching orders placed: $e');
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 250, 223, 255),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceCenterDetailsPage()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 80, // Adjust the height of the DrawerHeader
              child: DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 116, 47, 129),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Services',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Adjust the font size as needed
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('My Works'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyWorks()),
              );
              },
            ),
            // Add more ListTiles for additional items in the drawer
          ],
        ),
      ),
    body: Container(
      color: Color.fromARGB(255, 207, 173, 210),
      child: FutureBuilder<List<DocumentSnapshot>>(
        future: _ordersPlaced,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<DocumentSnapshot> ordersPlaced = snapshot.data!;

          if (ordersPlaced.isEmpty) {
      return Center(child: Text('No orders placed currently.'));
    }
    
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Users Requested',
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              // Display sorted service centers
              for (var ordersPlaced in ordersPlaced)
                UserCard(
    userName: ordersPlaced['userName'],
    userLocation: ordersPlaced['userLocation'],
    userPhoneNumber: ordersPlaced['userPhoneNumber'],
    imagePath: imagePaths[
        imageIndex++ % imagePaths.length],
    selectedServices: List<String>.from(ordersPlaced['selectedServices']),
    userEmail: ordersPlaced['userEmail'],
    orderedDate:ordersPlaced['orderedDate'],
    orderedTime:ordersPlaced['orderedTime'],
    totalAmount:ordersPlaced['totalAmount']
  ),
            ],
          );
        },
      ),
    ),
  );
}
}