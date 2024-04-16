import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/service_center_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('User Requests'),
        backgroundColor: Color.fromARGB(255, 182, 200, 247),  
        actions: [
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
      backgroundColor: Colors.white,
      // Set background color to white
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders_placed')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              // Display order details
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User email: ${orders[index].id}'),
                    SizedBox(height: 5),
                    Text('Service: ${orderData['selectedServices'].join(', ')}'),
                    SizedBox(height: 5),
                    Text('Total Amount: ${orderData['totalAmount']}'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button tap
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor:Colors.white
                      ),
                      child: Text('Work Done')
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}