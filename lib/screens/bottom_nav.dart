import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/providers/auth_provider.dart';
import 'package:real_state/screens/about_us.dart';
import 'package:real_state/screens/home_screen.dart';
import 'package:real_state/screens/lands.dart';
import 'package:real_state/screens/rent.dart';
import 'package:real_state/screens/settings.dart';

class Bottomnav extends StatelessWidget {
  const Bottomnav({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.token == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return SizedBox();
        }
        return _BottomNavContent();
      },
    );
  }
}

class _BottomNavContent extends StatefulWidget {
  @override
  _BottomNavContentState createState() => _BottomNavContentState();
}

class _BottomNavContentState extends State<_BottomNavContent> {
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.landscape), label: "Lands"),
          BottomNavigationBarItem(icon: Icon(Icons.apartment), label: "Rent"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About Us"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
