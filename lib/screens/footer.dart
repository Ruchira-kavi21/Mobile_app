// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      'assets/images/main_icon.png',
                      height: 60,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Stay in touch",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.teal.shade600,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text("+94 71 586 6790")
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.teal.shade600,
                          size: 10,
                        ),
                        SizedBox(width: 5),
                        Text("+94 71 588 7240")
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: Colors.teal.shade600,
                          size: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Homes@gmail.com",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Quick Links",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Home"),
                    Text("Lands"),
                    Text("Rent"),
                    Text("Sell"),
                    Text("About Us"),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Connect With Us",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.facebook,
                            color: Colors.teal.shade600, size: 18),
                        SizedBox(width: 5),
                        Text("Facebook"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.tiktok,
                            color: Colors.teal.shade600, size: 18),
                        SizedBox(width: 5),
                        Text("Tiktok"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.camera_alt,
                            color: Colors.teal.shade500, size: 18),
                        SizedBox(width: 5),
                        Text("Instagram"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
