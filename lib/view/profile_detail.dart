import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_update.dart';
import 'dart:io';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String _name = "";
  int _age = 0;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "";
      _age = prefs.getInt('age') ?? 0;
      _profileImagePath = prefs.getString('profile_image');
    });
  }

  _navigateToUpdate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileUpdate()),
    );
    _loadProfile(); // Reload the profile details after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _profileImagePath == null
                ? Text('No image selected.')
                : Image.file(File(_profileImagePath!), height: 100),
            Text('Name: $_name'),
            Text('Age: $_age'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToUpdate,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
