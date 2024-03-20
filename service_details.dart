import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/login_page.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  // Initialize a list to store selected services
  List<String> selectedServices = [];
   // Validator function for checking at least one service is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1569982175971-d92b01cf8694?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGdyYWRpZW50JTIwYmFja2dyb3VuZHxlbnwwfDF8MHx8fDA%3D', // Replace with your actual image URL
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: 600.0,
            width: 300.0, // Adjust the width as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 230, 205, 240),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 194, 169, 232).withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Service Centre Name TextFormField
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Service Centre Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Name should not contain numbers';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 12.0),

                    // License Number TextFormField
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'License Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'License is required';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 12.0),

                    // Phone Number TextFormField
                    TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        } else if (value.length != 10 || int.tryParse(value) == null) {
                          return 'Phone number should have only 10 digits';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 12.0),

                    // Location TextFormField
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location is required';
                        } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                          return 'Location should only contain alphabets';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 12.0),

                    // Checkbox list for services offered
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Services Offered',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // CheckboxListTile for each service
                        CheckboxListTile(
                          title: Text('Tyre'),
                          value: selectedServices.contains('Tyre'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedServices.add('Tyre');
                              } else {
                                selectedServices.remove('Tyre');
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Oil'),
                          value: selectedServices.contains('Oil'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedServices.add('Oil');
                              } else {
                                selectedServices.remove('Oil');
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Engine'),
                          value: selectedServices.contains('Engine'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedServices.add('Engine');
                              } else {
                                selectedServices.remove('Engine');
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Chassis'),
                          value: selectedServices.contains('Chassis'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedServices.add('Chassis');
                              } else {
                                selectedServices.remove('Chassis');
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Washing'),
                          value: selectedServices.contains('Washing'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null && value) {
                                selectedServices.add('Washing');
                              } else {
                                selectedServices.remove('Washing');
                              }
                            });
                          },
                        ),
                      ], 
                    ),
                    SizedBox(height: 20.0),

                    // Submit Button
                    ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Check if at least one service is selected
                    if (selectedServices.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('At least one service should be selected')),
                      );
                    } else {
                      // Save the data to Firestore
                      try {
                        await FirebaseFirestore.instance.collection('Service_Centres').doc(_nameController.text).set({
                          'Service Center Name': _nameController.text,
                          'License Number': _usernameController.text,
                          'Phone Number': _phoneNumberController.text,
                          'location': _locationController.text,
                          'Services_offered': selectedServices,
                        });
                        // Handle successful signup, e.g., navigate to home page
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registered successfully')),
                      );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } catch (e) {
                        print('Failed to save data: $e');
                        // Handle error
                      }
                    }
                  }
                },
                child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
