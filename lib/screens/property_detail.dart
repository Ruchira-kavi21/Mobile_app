import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/providers/auth_provider.dart';
import 'package:real_state/providers/property_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Map<String, String> property;

  const PropertyDetailScreen({super.key, required this.property});

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final propertyProvider = Provider.of<PropertyProvider>(context);

    if (auth.token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to view property details')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      });
      return SizedBox();
    }

    // Fetch details if ID is available and no data loaded
    if (property['id'] != null && propertyProvider.selectedProperty == null) {
      propertyProvider.fetchPropertyDetails(property['id']!);
    }

    final displayProperty = propertyProvider.selectedProperty ?? property;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          displayProperty['title']!,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: propertyProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Primary Image
                  Image.network(
                    displayProperty['image']!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/default.jpg',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Secondary Image (if available)
                  if (displayProperty['image_2'] != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Image.network(
                        displayProperty['image_2']!,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => SizedBox(),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayProperty['title']!,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          displayProperty['location']!,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          displayProperty['price']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.teal.shade600),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  await _launchPhoneCall(displayProperty['phonenumber']!);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              },
                              child: Text(
                                displayProperty['phonenumber']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Offer Type: ${displayProperty['offer_type'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Status: ${displayProperty['property_status'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Property Type: ${displayProperty['property_type'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Finish Status: ${displayProperty['finish_status'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          displayProperty['description'] ?? 'No description available',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Listed On: ${displayProperty['created_at'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}