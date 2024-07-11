import 'package:flutter/material.dart';
import 'package:shared_preference/view/profile_create.dart';
import 'package:shared_preference/view/profile_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> _checkProfileExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    int? age = prefs.getInt('age');
    return name != null && age != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter SharedPreferences Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkProfileExists(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return ProfileDetails();
            } else {
              return ProfileCreate();
            }
          }
        },
      ),
    );
  }
}
