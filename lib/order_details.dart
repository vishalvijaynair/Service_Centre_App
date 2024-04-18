import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_centre/home_page.dart';

class OrderDetailsPage extends StatefulWidget {
   final String userName;
  final String orderedDate;
  final String orderedTime;
  final String userLocation;
  final String userPhoneNumber;
  final String userEmail;
  final List<String> selectedServices;
  final double totalAmount;
  
  const OrderDetailsPage({
    Key? key,
    required this.userName,
    required this.orderedDate,
    required this.orderedTime,
    required this.userLocation,
    required this.userPhoneNumber,
    required this.userEmail,
    required this.selectedServices,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late TextEditingController _workerNameController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TextEditingController _messageController;
  


  @override
  void initState() {
    super.initState();
    _workerNameController = TextEditingController();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _workerNameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _submitOrder() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = user.uid;

   // Formulate the data to be stored
    Map<String, dynamic> orderData = {
      'userName': widget.userName,
      'orderedDate': widget.orderedDate,
      'orderedTime': widget.orderedTime,
      'userLocation': widget.userLocation,
      'userPhoneNumber': widget.userPhoneNumber,
      'userEmail': widget.userEmail,
      'selectedServices': widget.selectedServices,
      'totalAmount': widget.totalAmount,
      'workerName': _workerNameController.text,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'time': _selectedTime.format(context),
      'message': _messageController.text,
    };

      try {
        // Store data in Firestore
        await firestore
            .collection('Orders_pending')
            .doc(widget.userEmail)
            .collection('orders')
            .doc(user.email)
            .set(orderData);

        // Clear text fields after successful submission
        _workerNameController.clear();
        _messageController.clear();

        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Details submitted successfully'),
          ));
          // Navigate back to the homepage
     Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
      } catch (e) {
        print('Error submitting order: $e');
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit Details. Please try again later.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Color.fromARGB(255, 251, 212, 255),
         actions: [
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(215, 236, 193, 226),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _workerNameController,
                decoration: InputDecoration(labelText: 'Worker Name'),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(_selectedDate),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: _selectedTime.format(context),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Time',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message to User'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 170, 89, 199),
                  foregroundColor: Colors.white,
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
