// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:real_state/screens/list_card.dart';

class Lands extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      "image": "assets/images/land1.jpeg",
      "title": "Battaramulla Land",
      "location": "Battaramulla, Sri Lanka",
      "price": "LKR 20 Million",
      "phonenumber": "071 586 6790"
    },
    {
      "image": "assets/images/land2.jpeg",
      "title": "Kandy Valley Land",
      "location": "Kandy, Sri Lanka",
      "price": "LKR 15 Million",
      "phonenumber": "071 586 6790"
    },
    {
      "image": "assets/images/land3.jpeg",
      "title": "Coastal Beach Land",
      "location": "Galle, Sri Lanka",
      "price": "LKR 50 Million",
      "phonenumber": "071 586 6790"
    }
  ];
  Lands({super.key});

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
                            image: AssetImage("assets/images/lands_banner.png"),
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
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                  return PropertyCard(
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
        ));
  }
}
