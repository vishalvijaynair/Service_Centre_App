import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'login_page.dart';

class ServiceCenterDetailsPage extends StatelessWidget {
  const ServiceCenterDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centre Information'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserInfo()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Service_Centres')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            print('Document does not exist');
            return Center(child: Text('No user data found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView( // Wrap with SingleChildScrollView
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 55, 39, 176).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserInfoItem(label: 'Service Center Name', value: userData['Service Center Name'] ?? ''),
                      UserInfoItem(label: 'Email', value: userData['Email'] ?? ''),
                      UserInfoItem(label: 'Phone Number', value: userData['Phone Number'] ?? ''),
                      UserInfoItem(label: 'Location', value: userData['Location'] ?? ''),
                     SizedBox(height: 20),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Services Offered',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
    ),
    SizedBox(height: 8),
    for (String service in (userData['Services_offered'] as List<dynamic>).cast<String>())
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  service,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Amount: ${userData['Service_Amounts'][service]}',
                style: TextStyle(fontSize: 17.0),
              ),
            ],
          ),
          SizedBox(height: 4), // Adjust the spacing between service and amount
        ],
      ),
  ],
),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Sign Out', style: TextStyle(fontSize: 17.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(fontSize: 17.0),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}

class EditUserInfo extends StatefulWidget {
  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _location1Controller = TextEditingController();
  late double _latitude;
  late double _longitude;

  List<String> selectedServices = [];
  Map<String, int> serviceAmounts = {
    'Tyre': 0,
    'Oil': 0,
    'Engine': 0,
    'Chassis': 0,
    'Washing': 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Centre Information'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 55, 39, 176).withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Service Center Name',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.house_rounded),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location(Current Location)',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Location is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.phone),
                  ),
                  controller: _phoneNumberController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  // Get current location
                  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                  // Update location controller with the obtained location
                  setState(() {
                    _latitude = position.latitude; // Save latitude
                    _longitude = position.longitude; // Save longitude
                    // Update location controller with the obtained latitude and longitude
                    _location1Controller.text = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                  });
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _location1Controller,
                    decoration: InputDecoration(labelText: 'Lat&Long(Current)', prefixIcon: Icon(Icons.location_on_rounded),),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Update user information in the database
                  FirebaseFirestore.instance
                    .collection('Service_Centres')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .update({
                      'Service Center Name': _nameController.text,
                      'Phone Number': _phoneNumberController.text,
                      'Location': _locationController.text, // Save location text separately
                      'locValue': {
                        'latitude': _latitude,
                        'longitude': _longitude,
                      },
                    })
                    .then((value) {
                      Navigator.pop(context);
                    })
                    .catchError((error) => print('Failed to update user: $error'));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}