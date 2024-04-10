import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

    double? _latitude;
  double? _longitude;

    List<String> selectedServices = [];
  Map<String, String> serviceAmounts = {
    'Tyre': '',
    'Oil': '',
    'Engine': '',
    'Chassis': '',
    'Washing': '',
  };
  // Function to request and handle location permissions
  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // Permissions granted, proceed to get the location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      print('Location: ${position.latitude}, ${position.longitude}');
    } else {
      // Permissions not granted, handle accordingly (show a message, ask again, etc.)
      print('Location permission denied.');
    }
  }
  @override
  void initState() {
    super.initState();
     getLocation(); // Call _getLocation() method when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      backgroundColor:Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Service Centre Name',
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
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                   child: TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'License Number',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.numbers_rounded),
                  ),
                  validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'License is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
              ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone),
                    ),
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
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.password_rounded),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                    SizedBox(height: 12.0),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Services Offered',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    for (String service in serviceAmounts.keys)
      Column(
        children: [
          CheckboxListTile(
            title: Text(service),
            value: selectedServices.contains(service),
            onChanged: (value) {
              setState(() {
                                if (value != null && value) {
                  selectedServices.add(service);
                  // If the service was not previously in the map, initialize its amount
                  if (!serviceAmounts.containsKey(service)) {
                    serviceAmounts[service] = '';
                  }
                } else {
                  selectedServices.remove(service);
                  // Remove the service from the map when unchecked
                }
              });
            },
          ),
          SizedBox(height: 8),
          if (selectedServices.contains(service)) // Only show the TextFormField for selected services
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextFormField(
                initialValue: serviceAmounts[service], // Set initial value from the map
                decoration: InputDecoration(
                  labelText: '$service Service Amount',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required for $service';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    serviceAmounts[service] = value;
                  });
                },
              ),
            ),
        ],
      ),
    SizedBox(height: 8),
    if (selectedServices.isEmpty) // Show the Snackbar if no service is selected
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          'Select at least one service',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
  ],
),
SizedBox(height: 32.0),
ElevatedButton(
  onPressed: () async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if at least one service is selected
      if (selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Select at least one service'),
          ),
        );
      } else {
          await FirebaseFirestore.instance.collection('Service_Centres').doc(_emailController.text).set({
            'Service Center Name': _nameController.text,
            'License Number': _usernameController.text,
            'Email': _emailController.text,
            'Phone Number': _phoneNumberController.text,
            'Location': _locationController.text,
            'Services_offered': selectedServices,
            'Service_Amounts': serviceAmounts,
            'locValue': {
                  'latitude': _latitude,
                  'longitude': _longitude,
                },
          });

          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registered successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        } 
  }
  },
  style: ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    backgroundColor: Colors.purple,
  ),
  child: Text(
    'Sign Up',
    style: TextStyle(color: Colors.white),
  ),
),
],
),
),
),
    ),
    );
}


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
