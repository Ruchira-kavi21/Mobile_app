// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  bool _isLoading = false;

  String? get token => _token;
  String? get userId => _userId;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    if (!_validateInputs(email, password)) {
      throw Exception('Invalid email or password');
    }
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['user']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', email);
        await prefs.setString('user_id', _userId!);
        await prefs.setString('auth_token', _token!);
      } else {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    if (!_validateInputs(email, password)) {
      throw Exception('Invalid input');
    }
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'role': 'customer',
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _userId = data['user']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_id', _userId!);
      } else {
        throw Exception(
            jsonDecode(response.body)['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userId = prefs.getString('user_id');
    notifyListeners();
  }

  bool _validateInputs(String email, String password) {
    if (!email.contains('@') || email.isEmpty) return false;
    if (password.length < 6) return false;
    return true;
  }
}
