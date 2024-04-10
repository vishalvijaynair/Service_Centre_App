import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            icon: Icon(Icons.edit), // Edit icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserInfo()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set background color to white
body: StreamBuilder<DocumentSnapshot>(
  
  stream: FirebaseFirestore.instance
      .collection('Service_Centres')
      .doc(FirebaseAuth.instance.currentUser!.email) // Use service center name as document ID
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


    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
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
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 39, 44, 176).withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Update user information in the database
                  FirebaseFirestore.instance
                      .collection('Service_Centres')
                      .doc(FirebaseAuth.instance.currentUser!.displayName)
                      .update({
                        'Name': _nameController.text,
                        'Phone Number': _phoneNumberController.text,
                        'Location': _locationController.text,
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
