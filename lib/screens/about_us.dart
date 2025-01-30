// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:real_state/screens/footer.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Why Choos Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "At Haven Homes, we prioritize your needs,\n"
              "offering trusted services to buy, rent, \n"
              "or \n"
              " sell properties seamlessly.\n"
              " With a proven track record, personalized support,\n"
              " and\n"
              " transparent processes,\n"
              " we ensure your property journey is smooth and rewarding.\n "
              "Discover the difference with us today",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Keep the Focus on Property Search and Buying",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Column(
                  children: [
                    Image.asset("assets/images/search-property.png",
                        height: 50, width: 50),
                    SizedBox(height: 10),
                    Text(
                      "Search Property",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Find Your Dream Home With Our Easy-To-Use Search Engine",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Image.asset("assets/images/rent-house.png",
                        height: 50, width: 50),
                    SizedBox(height: 10),
                    Text(
                      "Contact Agents",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Connect With Experienced Agents Who Can Guide You Through The Buying Process.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  children: [
                    Image.asset("assets/images/sell-property.png",
                        height: 50, width: 50),
                    SizedBox(height: 10),
                    Text(
                      "Enjoy Property",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Move Into Your New Home And Start Living Your Best Life.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Footer()
          ],
        ),
      ),
    );
  }
}
