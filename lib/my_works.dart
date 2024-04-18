import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Works'),
        backgroundColor: Color.fromARGB(255, 203, 173, 214),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders_completed2')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error retrieving orders: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                'You have Completed No Works',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderData = orders[index].data() as Map<String, dynamic>;
              String userName = orderData['userName'] ?? 'N/A';
              String userLocation = orderData['userLocation'] ?? 'N/A';
              String userPhoneNumber = orderData['userPhoneNumber'] ?? 'N/A';
              String orderedDate = orderData['orderedDate'] ?? 'N/A';
              String orderedTime = orderData['orderedTime'] ?? 'N/A';
              String totalAmount = orderData['totalAmount']?.toString() ?? 'N/A';
              List<dynamic>? selectedServicesList = orderData['selectedServices'];
              String selectedServices = selectedServicesList?.join(', ') ?? 'N/A';
            

             
                  // Now you can return the ListTile with the correct service center name
                  return ListTile(
                    title: Text(
                      'Order ${index + 1}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Name: $userName', // Display service center name
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' User Location: $userLocation',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          ' User Phone Number: $userPhoneNumber',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Selected Services: $selectedServices',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total Amount: $totalAmount',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Ordered Date: $orderedDate',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Ordered Time: $orderedTime',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
    );
        }
  }
