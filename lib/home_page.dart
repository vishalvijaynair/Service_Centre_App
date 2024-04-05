import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: [
                    Text(
                      'User Requests',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: buildDataTable(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Services Requested').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data!;
        
        // Use data.docs to iterate through each document in the collection
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 0, 0, 0)), // Add border
            ),
            child: DataTable(
              headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
              columns: [
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Phone Number')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Selected Services')),
              ],
              rows: data.docs.map((doc) {
                final userData = doc.data() as Map<String, dynamic>;
                
                // Extract email from the document ID
                final userEmail = doc.id;

                // Access fields within each document
                final name = userData['Name'] ?? ''; // Provide default value if null
                final phoneNumber = userData['Phone Number'] ?? ''; // Provide default value if null
                final location = userData['Location'] ?? ''; // Provide default value if null
                final selectedServices = (userData['Selected Services'] as List<dynamic>?) ?? []; // Provide default value if null

                // Return a DataRow for each user
                return DataRow(cells: [
                  DataCell(Text(name)),
                  DataCell(Text(phoneNumber)),
                  DataCell(Text(location)),
                  DataCell(Text(selectedServices.join(', '))),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
