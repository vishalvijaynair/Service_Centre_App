import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_card.dart';
import 'user_card_detailed.dart';

enum SortBy { Name }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> imagePaths = [
    'assets/img1.png',
    'assets/img2.png',
    'assets/img3.png',
    'assets/img4.png',
    'assets/img5.png',
    'assets/img6.png',
    'assets/img7.png',
  ];
  int imageIndex = 0;
  SortBy _sortBy = SortBy.Name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        backgroundColor: Color.fromARGB(255, 250, 223, 255),
        actions: [
          PopupMenuButton<SortBy>(
            onSelected: (SortBy result) {
              setState(() {
                _sortBy = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
              const PopupMenuItem<SortBy>(
                value: SortBy.Name,
                child: Text('Sort by Name'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 207, 173, 210),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Orders_placed')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection('orders')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final serviceCenters = snapshot.data!.docs.where((doc) {
                  final name = doc['userName'].toString().toLowerCase();
                  return name.contains(_searchQuery);
                });

                if (serviceCenters.isEmpty) {
                  return Center(child: Text('No Users.'));
                }

                return ListView.builder(
                  itemCount: serviceCenters.length,
                  itemBuilder: (context, index) {
                    final userData = serviceCenters.elementAt(index).data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserCardDetailsPage(
                              userName: userData['userName'] ?? '',
                              userLocation: userData['userLocation'] ?? '',
                              userPhoneNumber: userData['userPhoneNumber'] ?? '',
                              imagePath: imagePaths[index % imagePaths.length],
                              selectedServices: List<String>.from(userData['selectedServices'] ?? []),
                              userEmail: userData['userEmail'] ?? '',
                              orderedDate: userData['orderedDate'] ?? '',
                              orderedTime: userData['orderedTime'] ?? '',
                              totalAmount: userData['totalAmount'] ?? 0,
                            ),
                          ),
                        );
                      },
                      child: UserCard(
                        userName: userData['userName'] ?? '',
                        userLocation: userData['userLocation'] ?? '',
                        userPhoneNumber: userData['userPhoneNumber'] ?? '',
                        imagePath: imagePaths[index % imagePaths.length],
                        selectedServices: List<String>.from(userData['selectedServices'] ?? []),
                        userEmail: userData['userEmail'] ?? '',
                        orderedDate: userData['orderedDate'] ?? '',
                        orderedTime: userData['orderedTime'] ?? '',
                        totalAmount: userData['totalAmount'] ?? 0,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
