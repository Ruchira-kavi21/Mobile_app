import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyProvider with ChangeNotifier {
  List<Map<String, String>> _landProperties = [];
  List<Map<String, String>> _rentProperties = [];
  bool _isLoading = false;

  List<Map<String, String>> get landProperties => _landProperties;
  List<Map<String, String>> get rentProperties => _rentProperties;
  bool get isLoading => _isLoading;

  Future<void> fetchProperties(String offerType) async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Please log in to access properties');
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/properties?offer_type=$offerType'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        final fetchedProperties = data
            .map((item) => {
                  'image': item['image_1'] != null
                      ? 'http://127.0.0.1:8000/storage/${item['image_1']}'
                      : 'assets/images/${offerType == 'sale' ? 'land1.jpeg' : 'rent1.jpg'}',
                  'title': item['property_name']?.toString() ?? 'Unknown',
                  'location': item['property_address']?.toString() ??
                      'Unknown Location',
                  'price': offerType == 'sale'
                      ? 'LKR ${item['property_price']?.toString() ?? '0'} Million'
                      : 'LKR ${item['property_price']?.toString() ?? '0'} Million/month',
                  'phonenumber':
                      item['phone_number']?.toString() ?? '071 234 5678',
                })
            .toList()
            .cast<Map<String, String>>();

        if (offerType == 'sale') {
          _landProperties = fetchedProperties;
          await prefs.setString(
              'land_properties', jsonEncode(fetchedProperties));
        } else {
          _rentProperties = fetchedProperties;
          await prefs.setString(
              'rent_properties', jsonEncode(fetchedProperties));
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to fetch properties');
      }
    } catch (e) {
      await _handleOfflineData(offerType);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleOfflineData(String offerType) async {
    final prefs = await SharedPreferences.getInstance();
    final offlineData = prefs.getString('${offerType}_properties');
    if (offlineData != null) {
      final data = jsonDecode(offlineData) as List;
      if (offerType == 'sale') {
        _landProperties =
            data.map((item) => item as Map<String, String>).toList();
      } else {
        _rentProperties =
            data.map((item) => item as Map<String, String>).toList();
      }
    } else {
      final defaultProperties = offerType == 'sale'
          ? [
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
            ]
          : [
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
              },
            ];
      if (offerType == 'sale') {
        _landProperties = defaultProperties;
      } else {
        _rentProperties = defaultProperties;
      }
    }
  }
}
