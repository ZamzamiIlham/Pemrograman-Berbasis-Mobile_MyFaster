import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:myfaster/theme/theme.dart';
import 'package:myfaster/user/bottom_bar.dart';
import 'regis_page.dart';
import 'package:myfaster/data/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _header = 200;
  Key _formKey = GlobalKey<FormState>();

  AuthService _authService = AuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    // Gunakan ekspresi reguler untuk validasi alamat email
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    logo_Login(),
                    title_Description(),
                    text_Field(),
                    //build_Button(context),
                  ],
                ),
              )
            ],
          )),
    );
  }

  //Logo
  Widget logo_Login() {
    return Image.asset(
      "assets/images/logo_ori.png",
      width: 150.0,
      height: 150.0,
    );
  }

  //Title
  Widget title_Description() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        Text(
          "Welcome Back",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.0),
        ),
        Text(
          "Login to your account",
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  //TEXT KOLOM
  Widget text_Field() {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: ThemeHelper()
                          .textInputDecoration('Email', 'Enter your email'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: ThemeHelper().textInputDecoration(
                          'Password', 'Enter your password'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          'Log In'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      /*onPressed: () {
                        //After successful login we will redirect to profile page. Let's create profile page now
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => NavBar()));
                      },*/
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();

                        //lakukan validasi email
                        if (!_isValidEmail(email)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Email atau password yang anda masukkan salah'),
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
                          return; // Menghentikan eksekusi lebih lanjut jika alamat email tidak valid
                        }

                        String result =
                            await _authService.logIn(email, password);
                        if (result == 'success') {
                          // Login berhasil, alihkan ke halaman berikutnya
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBar()));
                        } else {
                          // Tampilkan pesan error
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
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    //child: Text('Don\'t have an account? Create'),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Don\'t have an account? "),
                      TextSpan(
                        text: 'Create',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Registration()));
                          },
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      ),
                    ])),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
