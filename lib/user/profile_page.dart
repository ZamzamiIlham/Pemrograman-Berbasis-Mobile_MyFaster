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

      // Cek apakah ada path gambar tersimpan
      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) {
        profileImage = File(imagePath);
      }
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
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profileImage != null) ...[
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(profileImage!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadProfile,
                child: Text('Upload Profile'),
              ),
              SizedBox(height: 20),
            ],
            Text('Welcome: $username'),
            SizedBox(height: 20),
            Text('Password: $password'),
            ElevatedButton(
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
              child: Text('Logout'),
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
