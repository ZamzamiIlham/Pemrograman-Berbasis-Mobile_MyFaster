import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfaster/user/bottom_bar.dart';
import 'package:myfaster/login/login_page.dart';
import 'package:myfaster/data/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan data username dari shared preferences saat halaman profile dimuat
    getUsername();
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ambil nilai username dari shared preferences
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username'); // Hapus data username dari shared preferences
    // Alihkan ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $username!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
