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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.teal.shade600,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "+94715866790",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.teal.shade600,
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "+94715887240",
                          style: TextStyle(fontSize: 12),
                        ),
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
                          "H@gmail.com",
                          style: TextStyle(fontSize: 12),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Lands",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Rent",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Sell",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "About Us",
                      style: TextStyle(fontSize: 12),
                    ),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.facebook,
                            color: Colors.teal.shade600, size: 18),
                        SizedBox(width: 5),
                        Text(
                          "Facebook",
                          style: TextStyle(fontSize: 12),
                        ),
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
