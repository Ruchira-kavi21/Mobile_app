import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await _handleOfflineData(offerType);
      return;
    }

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
      notifyListeners();
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final offlineData = prefs.getString('${offerType}_properties');
      print('Offline data for $offerType: $offlineData');
      if (offlineData != null) {
        final data = jsonDecode(offlineData) as List;
        if (offerType == 'sale') {
          _landProperties =
              data.map((item) => item as Map<String, String>).toList();
        } else {
          _rentProperties =
              data.map((item) => item as Map<String, String>).toList();
        }
        print('Successfully loaded offline data for $offerType');
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
          await prefs.setString(
              'land_properties', jsonEncode(defaultProperties));
        } else {
          _rentProperties = defaultProperties;
          await prefs.setString(
              'rent_properties', jsonEncode(defaultProperties));
        }
        print('Loaded default properties for $offerType');
      }
    } catch (e) {
      print('Error in _handleOfflineData for $offerType: $e');
    }
  }

  Future<String?> submitProperty({
    required String title,
    required String location,
    required String price,
    required String phonenumber,
    String? description,
    String? propertyType,
    String? propertyStatus,
    String? finishStatus,
    required String offerType,
    XFile? image,
    Position? position,
    List<double>? acceleration,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Please log in to submit a property');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/api/properties'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['property_name'] = title;
      request.fields['property_address'] = location;
      request.fields['property_price'] = price.replaceAll(RegExp(r'[^\d.]'), '');
      request.fields['phone_number'] = phonenumber;
      if (description != null) request.fields['property_description'] = description;
      if (propertyType != null) request.fields['property_type'] = propertyType;
      if (propertyStatus != null) request.fields['property_status'] = propertyStatus;
      if (finishStatus != null) request.fields['finish_status'] = finishStatus;
      request.fields['offer_type'] = offerType;
      if (position != null) {
        request.fields['latitude'] = position.latitude.toString();
        request.fields['longitude'] = position.longitude.toString();
      }
      if (acceleration != null) {
        request.fields['acceleration_x'] = acceleration[0].toString();
        request.fields['acceleration_y'] = acceleration[1].toString();
        request.fields['acceleration_z'] = acceleration[2].toString();
      }
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image_1', image.path));
      }

      print('Request Fields: ${request.fields}');
      if (image != null) print('Image File: ${image.path}');

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${responseData.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(responseData.body);
        print('Property submitted successfully: $data');
        return data['message'];
      } else {
        throw Exception('Failed to submit property: ${responseData.body}');
      }
    } catch (e) {
      print('Error submitting property: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Stream<List<double>> getAccelerometerData() {
    return accelerometerEvents.map((event) => [event.x, event.y, event.z]);
  }
}
