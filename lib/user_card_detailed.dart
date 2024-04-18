import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service_centre/home_page.dart';
import 'package:service_centre/order_details.dart';

class UserCardDetailsPage extends StatelessWidget {
  final String userName;
  final String orderedDate;
  final String orderedTime;
  final String userLocation;
  final String imagePath;
  final String userPhoneNumber;
  final List<String> selectedServices;
  final double totalAmount;
  final String userEmail;

  const UserCardDetailsPage({
    required this.userName,
    required this.orderedDate,
    required this.orderedTime,
    required this.imagePath,
    required this.userLocation,
    required this.userPhoneNumber,
    required this.selectedServices,
    required this.totalAmount,
    required this.userEmail,
  });

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Order Details'),
      backgroundColor: Color.fromARGB(255, 207, 173, 210),
    ),
    body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 217, 230),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'User Name: $userName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Ordered Date: $orderedDate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Ordered Time: $orderedTime',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'User Location: $userLocation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'User Phone Number: $userPhoneNumber',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Services:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: selectedServices.map((service) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '- $service',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            Text(
              'Total Amount: $totalAmount',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "Details" button press
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                          userName: userName,
                          orderedDate: orderedDate,
                          orderedTime: orderedTime,
                          userLocation: userLocation,
                          userPhoneNumber: userPhoneNumber,
                          userEmail: userEmail,
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
                ElevatedButton(
                  onPressed: () async {
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    await firestore
                        .collection('orders_completed')
                        .doc(userEmail)
                        .collection('orders')
                        .doc((FirebaseAuth.instance.currentUser!.email))
                        .set({
                      'orderedDate': orderedDate,
                      'orderedTime': orderedTime,
                      'selectedServices': selectedServices,
                      'totalAmount': totalAmount,
                      'serviceCenterEmail': (FirebaseAuth.instance.currentUser!.email),
                    });

                    await firestore
                        .collection('orders_completed2')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('orders')
                        .doc((userEmail))
                        .set({
                      'userName': userName,
                      'userLocation': userLocation,
                      'userPhoneNumber': userPhoneNumber,
                      'orderedDate': orderedDate,
                      'orderedTime': orderedTime,
                      'selectedServices': selectedServices,
                      'totalAmount': totalAmount,
                      'UserEmail': userEmail,
                    });

                    await firestore
                        .collection('Orders_pending')
                        .doc(userEmail)
                        .collection('orders')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .delete();
                    await firestore
                        .collection('Orders_placed')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('orders')
                        .doc(userEmail)
                        .delete();
                    await firestore
                        .collection('orders_placed2')
                        .doc(userEmail)
                        .collection('orders')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .delete();
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );

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
      ),
    ),
  );
}
}