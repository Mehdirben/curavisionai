import 'package:curavisionai/screens/xray_page.dart';
import 'package:flutter/material.dart';
import '../account_page.dart';
import 'medication_page.dart';
import 'services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Content'), // Replace with your actual home content
    XRayPage(),
    MedicationPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CuraVision AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure fixed type
        backgroundColor: Colors.grey[300], // Set your desired grey color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio), // You might need a custom icon for X-Ray
            label: 'X-Ray',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication), // You might need a custom icon for Medication
            label: 'Medication',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800], // Customize the selected item color
        onTap: _onItemTapped,
      ),
    );
  }
}