import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/order_details.dart';
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Service_Centres').doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
        builder: (context, serviceCenterSnapshot) {
          if (serviceCenterSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!serviceCenterSnapshot.hasData || !serviceCenterSnapshot.data!.exists) {
            // Document ID (email) not found in Service_Centres collection
            // Check if it exists in Requested_Centres collection
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('Requested_Centres').doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
              builder: (context, requestedCenterSnapshot) {
                if (requestedCenterSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!requestedCenterSnapshot.hasData || !requestedCenterSnapshot.data!.exists) {
                  // Document ID (email) not found in Requested_Centres collection either
                  // Display message for rejected request
                  return Center(child: Text('The service center request has been rejected.'));
                } else {
                  // Document ID (email) found in Requested_Centres collection
                  // Display message for request being processed
                  return Center(child: Text('The service center request is being processed.'));
                }
              },
            );
          }

          // Document ID (email) found in Service_Centres collection
          // Continue with other functionalities
          return StreamBuilder<QuerySnapshot>(
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
                  String orderedDate = orderData['orderedDate'];
                  String orderedTime = orderData['orderedTime'];
                  String userLocation = orderData['userLocation'];
                  String userPhoneNumber = orderData['userPhoneNumber'];
                  List<String> selectedServices = List<String>.from(orderData['selectedServices']);
                  double totalAmount = orderData['totalAmount'];

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
                              onPressed: () async {
                                // Handle "Work Done" button press
                                String UserEmail = orders[index].id;
                                // Replace with actual service center email
                                FirebaseFirestore firestore = FirebaseFirestore.instance;

                                // Store data in nested "orders" subcollection
                                await firestore
                                    .collection('orders_completed')
                                    .doc(UserEmail) // Use user email as parent document ID
                                    .collection('orders')
                                    .doc((FirebaseAuth.instance.currentUser!.email)) // Use service center email as document ID
                                    .set({
                                  'orderedDate': orderedDate,
                                  'orderedTime': orderedTime,
                                  'selectedServices': selectedServices,
                                  'totalAmount': totalAmount,
                                  'serviceCenterEmail': (FirebaseAuth.instance.currentUser!.email),
                                });
                                // Delete the document from the nested subcollection
                                await firestore
                                    .collection('Orders_pending')
                                    .doc(orders[index].id)
                                    .collection('orders')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .delete();
                                await firestore
                                    .collection('Orders_placed')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .collection('orders')
                                    .doc(orders[index].id)
                                    .delete();
                                    await firestore
                                    .collection('orders_placed2')
                                    .doc(orders[index].id)
                                    .collection('orders')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .delete();
                                // Optionally show a success message
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Order marked as completed. Pending Details deleted.'),
                                ));
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
          );
        },
      ),
    );
  }
}
