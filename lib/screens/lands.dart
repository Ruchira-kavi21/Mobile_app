// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/providers/auth_provider.dart';
import 'package:real_state/providers/property_provider.dart';
import 'package:real_state/screens/footer.dart';
import 'package:real_state/screens/list_card.dart';

class Lands extends StatelessWidget {
  const Lands({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final properties = Provider.of<PropertyProvider>(context);

    if (auth.token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to access properties')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox();
    }

    if (!properties.isLoading && properties.landProperties.isEmpty) {
      properties.fetchProperties('sale');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Heven Homes",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Image.asset('assets/images/main_icon.png', height: 60),
          ),
        ],
        backgroundColor: Colors.grey[300],
      ),
      body: properties.isLoading
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
                            image: AssetImage("assets/images/lands_banner.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                            SizedBox(height: 10),
                            Text(
                              "Explore a wide range of lands tailored for your needs—residential, commercial, or agricultural.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Our Lands",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade600),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: properties.landProperties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(
                        imageUrl: properties.landProperties[index]["image"]!,
                        title: properties.landProperties[index]["title"]!,
                        location: properties.landProperties[index]["location"]!,
                        price: properties.landProperties[index]["price"]!,
                        phonenumber: properties.landProperties[index]
                            ["phonenumber"]!,
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
