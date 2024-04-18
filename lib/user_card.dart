import "package:flutter/material.dart";
import "package:service_centre/user_card_detailed.dart";

class UserCard extends StatelessWidget {
  final String userName;
  final String orderedDate;
  final String orderedTime;
  final String userLocation;
  final String imagePath;
  final String userPhoneNumber;
  final List<String> selectedServices;
  final double totalAmount;
  final String userEmail;

  UserCard({
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
    return GestureDetector(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserCardDetailsPage(
              userName: userName,
              userLocation: userLocation,
              selectedServices: selectedServices,
              userPhoneNumber: userPhoneNumber,
              imagePath: imagePath,
              orderedDate: orderedDate,
              orderedTime: orderedTime,
              totalAmount: totalAmount,
              userEmail:userEmail // Pass service amounts to the details page
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userLocation,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    selectedServices.join(', '),
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
