import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/order_details.dart';
import 'package:service_centre/service_center_details_page.dart';
import 'package:intl/intl.dart';
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
              // Accessing fields from the order data
              String userName = orderData['userName'];
              Timestamp createdAt = orderData['createdAt'] as Timestamp;
              String userLocation = orderData['userLocation'];
              String userPhoneNumber = orderData['userPhoneNumber'];
              List<String> selectedServices = List<String>.from(orderData['selectedServices']);
              double totalAmount = orderData['totalAmount'];

               // Format ordered date and time
              DateTime orderedDateTime = createdAt.toDate();
              String orderedDate = DateFormat.yMMMMd().format(orderedDateTime);
              String orderedTime = DateFormat.jm().format(orderedDateTime); // Formats time with AM/PM


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
      SizedBox(height: 5),
      Text(
        'User Name:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$userName',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'Ordered Date:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$orderedDate',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'Ordered Time:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$orderedTime',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'User Location:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$userLocation',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'User Phone Number:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$userPhoneNumber',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'User Email:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '${orders[index].id}',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'Service:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '${selectedServices.join(', ')}',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        'Total Amount:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      SizedBox(height: 5),
      Text(
        '$totalAmount',
        style: TextStyle(fontSize: 14),
      ),
      SizedBox(height: 10),
          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailsPage(
                                  userName: userName,
                                  orderedDate: orderedDate,
                                  orderedTime: orderedTime,
                                  userLocation: userLocation,
                                  userPhoneNumber: userPhoneNumber,
                                  userEmail: orders[index].id,
                                  selectedServices: selectedServices,
                                  totalAmount: totalAmount,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 89, 40, 142),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Details'),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: () {
                            // Handle "Work Done" button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 46, 159, 53),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Work Done'),
                           ),
                      ],
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