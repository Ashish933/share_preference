import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  File? _image;
  String? _existingImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? "";
      _ageController.text = (prefs.getInt('age') ?? 0).toString();
      _existingImagePath = prefs.getString('profile_image');
    });
  }

  _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setInt('age', int.parse(_ageController.text));
    if (_image != null) {
      await prefs.setString('profile_image', _image!.path);
    }
    Navigator.pop(context); // Go back to profile details screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Update your name',
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: 'Update your age',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _existingImagePath == null && _image == null
                ? Text('No image selected.')
                : _image != null
                ? Image.file(_image!, height: 100)
                : Image.file(File(_existingImagePath!), height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Profile Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Updates'),
            ),
          ],
        ),
      ),
    );
  }
}
