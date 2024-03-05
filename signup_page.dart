import 'package:flutter/material.dart';
import 'authentication_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  // Initialize a list to store selected services
  List<String> selectedServices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
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
                    SizedBox(height: 12.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Password must contain at least one special character';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          print('Form is valid');
                          // Perform signup logic
                          // For demonstration purposes, we will print the form data
                          print('Name: ${_nameController.text}');
                          print('Services Offered: $selectedServices');
                          // ... Print other form fields ...

                          // Handle successful signup, e.g., navigate to home page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AuthenticationPage()),
                          );
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
