import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_state/providers/property_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class PropertyForm extends StatefulWidget {
  @override
  _PropertyFormState createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _offerType = 'sale';
  String _propertyType = 'Land';
  String _propertyStatus = 'Available';
  String _finishStatus = 'Completed';
  XFile? _image;
  Position? _position;
  List<double>? _acceleration;
  late StreamSubscription<List<double>> _accelerometerSubscription;
  bool _useGeolocation = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _startAccelerometer();
  }

  @override
  void dispose() {
    _accelerometerSubscription.cancel();
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _phonenumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    if (_useGeolocation) {
      final position =
          await Provider.of<PropertyProvider>(context, listen: false)
              .getCurrentLocation();
      if (position != null) {
        setState(() => _position = position);
        _locationController.text =
            'Lat: ${position.latitude}, Lon: ${position.longitude}';
      }
    }
  }

  void _startAccelerometer() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _accelerometerSubscription =
        provider.getAccelerometerData().listen((event) {
      if (mounted) setState(() => _acceleration = event);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) setState(() => _image = pickedFile);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PropertyProvider>(context, listen: false);
      final message = await provider.submitProperty(
        title: _titleController.text,
        location: _locationController.text,
        price: _priceController.text,
        phonenumber: _phonenumberController.text,
        description: _descriptionController.text,
        propertyType: _propertyType,
        propertyStatus: _propertyStatus,
        finishStatus: _finishStatus,
        offerType: _offerType,
        image: _image,
        position: _useGeolocation ? _position : null,
        acceleration: _acceleration,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Submission failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Property')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Property Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter a location' : null,
                    ),
                  ),
                  Switch(
                    value: _useGeolocation,
                    onChanged: (value) {
                      setState(() {
                        _useGeolocation = value;
                        _loadLocation();
                      });
                    },
                    activeColor: Colors.teal,
                  ),
                  Text('Use Geolocation'),
                ],
              ),
              if (_useGeolocation && _position == null)
                Text('Fetching location...',
                    style: TextStyle(color: Colors.grey)),
              TextFormField(
                controller: _priceController,
                decoration:
                    InputDecoration(labelText: 'Price (e.g., 20 Million)'),
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
              ),
              TextFormField(
                controller: _phonenumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a phone number' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              DropdownButtonFormField<String>(
                value: _propertyType,
                items: ['Land', 'Apartment', 'House', 'Commercial']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _propertyType = value!),
                decoration: InputDecoration(labelText: 'Property Type'),
              ),
              DropdownButtonFormField<String>(
                value: _propertyStatus,
                items: ['Available', 'Sold', 'Pending'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _propertyStatus = value!),
                decoration: InputDecoration(labelText: 'Property Status'),
              ),
              DropdownButtonFormField<String>(
                value: _finishStatus,
                items: ['Completed', 'Under Construction', 'Planned']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _finishStatus = value!),
                decoration: InputDecoration(labelText: 'Finish Status'),
              ),
              DropdownButtonFormField<String>(
                value: _offerType,
                items: ['sale', 'rent'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _offerType = value!),
                decoration: InputDecoration(labelText: 'Offer Type'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Capture Image'),
                  ),
                  SizedBox(
                    width: 10,
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Pick from Gallery'),
                  ),
                ],
              ),
              if (_image != null) Text('Image selected: ${_image!.name}'),
              if (_position != null && _useGeolocation)
                Text(
                    'Location: ${_position!.latitude}, ${_position!.longitude}'),
              if (_acceleration != null)
                Text('Acceleration: ${_acceleration!.join(', ')}'),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
