import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyProvider with ChangeNotifier {
  List<Map<String, String>> _landProperties = [];
  List<Map<String, String>> _rentProperties = [];
  Map<String, dynamic>? _selectedProperty;
  bool _isLoading = false;

  List<Map<String, String>> get landProperties => _landProperties;
  List<Map<String, String>> get rentProperties => _rentProperties;
  Map<String, dynamic>? get selectedProperty => _selectedProperty;
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
                  'id': item['id']?.toString() ?? '0',
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
      print('Error fetching properties: $e');
      await _handleOfflineData(offerType);
    } finally {
      _isLoading = false;
      notifyListeners(); // Ensure UI updates after offline load
    }
  }

  Future<void> fetchPropertyDetails(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Please log in to access property details');
      }

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/properties/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _selectedProperty = {
          'id': data['id']?.toString() ?? '0',
          'image': data['image_1'] ?? 'assets/images/default.jpg',
          'image_2': data['image_2'],
          'title': data['property_name']?.toString() ?? 'Unknown',
          'location':
              data['property_address']?.toString() ?? 'Unknown Location',
          'price': data['offer_type'] == 'sale'
              ? 'LKR ${data['property_price']?.toString() ?? '0'} Million'
              : 'LKR ${data['property_price']?.toString() ?? '0'} Million/month',
          'phonenumber': data['phone_number']?.toString() ?? '071 234 5678',
          'description': data['property_description']?.toString() ??
              'No description available',
          'offer_type': data['offer_type']?.toString() ?? 'Unknown',
          'property_status': data['property_status']?.toString() ?? 'Unknown',
          'property_type': data['property_type']?.toString() ?? 'Unknown',
          'finish_status': data['finish_status']?.toString() ?? 'Unknown',
          'created_at': data['created_at']?.toString() ?? 'Unknown',
        };
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to fetch property details');
      }
    } catch (e) {
      print('Error fetching property details: $e');
      _selectedProperty = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleOfflineData(String offerType) async {
    final prefs = await SharedPreferences.getInstance();
    final offlineData = prefs.getString('${offerType}_properties');
    print('Offline data for $offerType: $offlineData'); // Debug log
    if (offlineData != null) {
      try {
        final data = jsonDecode(offlineData) as List;
        if (offerType == 'sale') {
          _landProperties =
              data.map((item) => item as Map<String, String>).toList();
        } else {
          _rentProperties =
              data.map((item) => item as Map<String, String>).toList();
        }
      } catch (e) {
        print('Error decoding offline data for $offerType: $e');
      }
    } else {
      final defaultProperties = offerType == 'sale'
          ? [
              {
                'id': '1',
                'image': 'assets/images/land1.jpeg',
                'title': 'Battaramulla Land',
                'location': 'Battaramulla, Sri Lanka',
                'price': 'LKR 20 Million',
                'phonenumber': '071 586 6790',
              },
            ]
          : [
              {
                'id': '1',
                'image': 'assets/images/rent1.jpg',
                'title': 'Luxury Apartment',
                'location': 'Colombo, Sri Lanka',
                'price': 'LKR 150,000/month',
                'phonenumber': '071 234 5678',
              },
            ];
      if (offerType == 'sale') {
        _landProperties = defaultProperties;
        await prefs.setString('land_properties', jsonEncode(defaultProperties));
      } else {
        _rentProperties = defaultProperties;
        await prefs.setString('rent_properties', jsonEncode(defaultProperties));
      }
      print('Loaded default properties for $offerType');
    }
  }
}
