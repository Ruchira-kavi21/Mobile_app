// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:real_state/screens/about_us.dart';
import 'package:real_state/screens/home_screen.dart';
import 'package:real_state/screens/lands.dart';
import 'package:real_state/screens/rent.dart';
import 'package:real_state/screens/settings.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    Lands(),
    rentScreen(),
    Aboutus(),
    Settings(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal.shade600,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: "Lands",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: "Rent",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "About Us",
          ),
        ],
      ),
    );
  }
}
