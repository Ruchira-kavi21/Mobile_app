// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:real_state/screens/rent_card.dart';

class rentScreen extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      "image": "assets/images/rent1.jpg",
      "title": "Luxury Apartment",
      "location": "Colombo, Sri Lanka",
      "price": "LKR 150,000/month",
      "phonenumber": "071 234 5678"
    },
    {
      "image": "assets/images/rent2.jpg",
      "title": "Modern Condo",
      "location": "Kandy, Sri Lanka",
      "price": "LKR 120,000/month",
      "phonenumber": "071 876 5432"
    },
    {
      "image": "assets/images/rent3.jpg",
      "title": "Family House",
      "location": "Galle, Sri Lanka",
      "price": "LKR 90,000/month",
      "phonenumber": "071 345 6789"
    },
    {
      "image": "assets/images/rent4.jpeg",
      "title": "Cozy Studio Apartment",
      "location": "Negombo, Sri Lanka",
      "price": "LKR 80,000/month",
      "phonenumber": "071 456 7890"
    },
    {
      "image": "assets/images/rent5.jpg",
      "title": "Seaside Villa",
      "location": "Trincomalee, Sri Lanka",
      "price": "LKR 200,000/month",
      "phonenumber": "071 567 8901"
    },
    {
      "image": "assets/images/rent6.jpg",
      "title": "Furnished Townhouse",
      "location": "Nuwara Eliya, Sri Lanka",
      "price": "LKR 110,000/month",
      "phonenumber": "071 678 9012"
    },
    {
      "image": "assets/images/rent7.jpg",
      "title": "Penthouse Apartment",
      "location": "Colombo 07, Sri Lanka",
      "price": "LKR 300,000/month",
      "phonenumber": "071 789 0123"
    }
  ];
  rentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heven Homes"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/rent_banner.webp"),
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
                        "Find Your Perfect Rental Space",
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
                        "Explore a variety of rental properties designed to meet your needs whether it's residential, commercial, or vacation spaces. Let us help you find your ideal home or business location.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                return PropertyCards(
                  imageUrl: properties[index]["image"]!,
                  title: properties[index]["title"]!,
                  location: properties[index]["location"]!,
                  price: properties[index]["price"]!,
                  phonenumber: properties[index]["phonenumber"]!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
