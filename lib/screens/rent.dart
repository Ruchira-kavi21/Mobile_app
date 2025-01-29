// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class rentScreen extends StatelessWidget {
  const rentScreen({super.key});

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
        body: Column(
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
                )
              ],
            ),
          ],
        ));
  }
}
