// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/providers/auth_provider.dart';
import 'package:real_state/providers/property_provider.dart';
import 'package:real_state/screens/footer.dart';
import 'package:real_state/screens/rent_card.dart'; // Confirm this import

class rentScreen extends StatelessWidget {
  const rentScreen({super.key});

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

    if (!properties.isLoading && properties.rentProperties.isEmpty) {
      properties.fetchProperties('rent');
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
                            image: AssetImage("assets/images/rent_banner.webp"),
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
                              "Find Your Perfect Rental Space",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Explore a variety of rental properties designed to meet your needs.",
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: properties.rentProperties.length,
                    itemBuilder: (context, index) {
                      print(
                          'Rendering PropertyCards for index $index: ${properties.rentProperties[index]}'); // Debug
                      return PropertyCards(
                        id: properties.rentProperties[index]['id']!,
                        imageUrl: properties.rentProperties[index]["image"]!,
                        title: properties.rentProperties[index]["title"]!,
                        location: properties.rentProperties[index]["location"]!,
                        price: properties.rentProperties[index]["price"]!,
                        phonenumber: properties.rentProperties[index]
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
