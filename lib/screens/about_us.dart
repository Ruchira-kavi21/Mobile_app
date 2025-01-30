// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
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
            )
          ],
        ),
      ),
    );
  }
}
