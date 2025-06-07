// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:real_state/screens/footer.dart';
import 'package:real_state/screens/rent_card.dart'; // Update import to rent_card.dart
import 'package:shared_preferences/shared_preferences.dart';

class Lands extends StatefulWidget {
  Lands({super.key});

  @override
  _LandsState createState() => _LandsState();
}

class _LandsState extends State<Lands> {
  List<Map<String, String>> properties = [];
  List<Map<String, String>> filteredProperties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to access properties')),
        );
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/properties?offer_type=sale'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        final fetchedProperties = data
            .map((item) => {
                  'id': item['id']?.toString() ?? '0',
                  'image': item['image_1'] != null
                      ? 'http://127.0.0.1:8000/storage/${item['image_1']}'
                      : 'assets/images/land1.jpeg',
                  'title': item['property_name']?.toString() ?? 'Unknown Land',
                  'location': item['property_address']?.toString() ??
                      'Unknown Location',
                  'price':
                      'LKR ${item['property_price']?.toString() ?? '0'} Million',
                  'phonenumber':
                      item['phone_number']?.toString() ?? '071 586 6790',
                })
            .toList()
            .cast<Map<String, String>>();

        setState(() {
          properties = fetchedProperties;
          filteredProperties = fetchedProperties;
          _isLoading = false;
        });

        await prefs.setString('land_properties', jsonEncode(fetchedProperties));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unauthorized: Please log in again')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch properties')),
        );
        _handleOfflineData();
      }
    } catch (e) {
      print('Error fetching properties: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to connect to server')),
      );
      _handleOfflineData();
    }
  }

  Future<void> _handleOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    final offlineData = prefs.getString('land_properties');
    if (offlineData != null) {
      setState(() {
        properties = (jsonDecode(offlineData) as List)
            .map((item) => item as Map<String, String>)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        properties = [
          {
            "id": "1",
            "image": "assets/images/land1.jpeg",
            "title": "Battaramulla Land",
            "location": "Battaramulla, Sri Lanka",
            "price": "LKR 20 Million",
            "phonenumber": "071 586 6790"
          },
          {
            "id": "2",
            "image": "assets/images/land2.jpeg",
            "title": "Kandy Valley Land",
            "location": "Kandy, Sri Lanka",
            "price": "LKR 15 Million",
            "phonenumber": "071 586 6790"
          },
          {
            "id": "3",
            "image": "assets/images/land3.jpeg",
            "title": "Coastal Beach Land",
            "location": "Galle, Sri Lanka",
            "price": "LKR 50 Million",
            "phonenumber": "071 586 6790"
          }
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Heven Homes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Image.asset(
              'assets/images/main_icon.png',
              height: 60,
            ),
          )
        ],
        backgroundColor: Colors.grey[300],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/lands_banner.png"),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Positioned(
                        top: 80,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Discover Your Ideal Land Today",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Explore a wide range of lands tailored for your needs—residential, commercial, or agricultural. Find the perfect location to bring your vision to life.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Our Lands",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade600,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return PropertyCards(
                        id: properties[index]["id"]!, // Pass id
                        imageUrl: properties[index]["image"]!,
                        title: properties[index]["title"]!,
                        location: properties[index]["location"]!,
                        price: properties[index]["price"]!,
                        phonenumber: properties[index]["phonenumber"]!,
                      );
                    },
                  ),
                  Footer(),
                ],
              ),
            ),
    );
  }
}