import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  buildDataTable(),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Text(
                    'Batches',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  buildDataTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('User A')),
          DataColumn(label: Text('User B')),
          DataColumn(label: Text('User C')),
          DataColumn(label: Text('User D')),
          // Add more DataColumn widgets as needed
        ],
        rows: [
          DataRow(cells: [
            buildDataCell('tyre'),
            buildDataCell('engine'),
            buildDataCell('oil'),
            buildDataCell('wash'),
            // Add more DataCell widgets as needed
          ]),
          DataRow(cells: [
            buildDataCell('chasis'),
            buildDataCell('wash'),
            buildDataCell('engine'),
            buildDataCell('tyre'),
            // Add more DataCell widgets as needed
          ]),
          // Add more DataRow widgets as needed
        ],
      ),
    );
  }

  DataCell buildDataCell(String value) {
    return DataCell(
      Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black),
        ),
        child: Text(value),
      ),
    );
  }
}
