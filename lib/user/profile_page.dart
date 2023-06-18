import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfaster/login/login_page.dart';
import 'package:myfaster/data/auth.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = '';
  String password = '';
  File? profileImage; // Variabel untuk menyimpan gambar profil

  AuthService _authService = AuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan data username dari shared preferences saat halaman profil dimuat
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';

      _passwordController.text = password;

      // Cek apakah ada path gambar tersimpan
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }

      _usernameController.text = username;
      _passwordController.text = password;
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username'); // Hapus data username dari shared preferences
    prefs.remove('password'); // Hapus data password dari shared preferences
    // Alihkan ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> changePassword(String newPassword) async {
    String result = await _authService.changePassword(newPassword);
    if (result == 'success') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('password',
          newPassword); // Perbarui data password di shared preferences

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Password changed successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    password =
                        newPassword; // Perbarui nilai password setelah berhasil diubah
                  });
                  _passwordController.text =
                      newPassword; // Perbarui nilai pada controller TextFormField
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(result),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadProfile() async {
    if (profileImage != null) {
      // Menentukan direktori penyimpanan lokal untuk foto profil
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, 'profile_image.jpg');

      // Menyalin foto profil ke direktori penyimpanan lokal
      await profileImage!.copy(imagePath);

      // Simpan path gambar ke shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', imagePath);

      // Tampilkan pesan sukses
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload Success'),
            content: Text('Profile picture uploaded successfully.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            if (profileImage != null) ...[
              CircleAvatar(
                radius: 80,
                backgroundImage: FileImage(profileImage!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadProfile,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text(
                      'Upload Profile',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
            ],
            TextFormField(
              controller: _usernameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Password',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newPassword = '';
                    return AlertDialog(
                      title: Text('Change Password'),
                      content: TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          newPassword = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'New Password',
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Save'),
                          onPressed: () {
                            changePassword(newPassword);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Change Password'),
            ),
            ElevatedButton(
              onPressed: logout,
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
