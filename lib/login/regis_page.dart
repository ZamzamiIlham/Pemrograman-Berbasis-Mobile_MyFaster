import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'login_page.dart';
import 'package:myfaster/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:myfaster/data/auth.dart';

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  AuthService _authService = AuthService();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                    logo_Sign(),
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
  Widget logo_Sign() {
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
          "Create your account",
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
                  //USERNAME
                  Container(
                    child: TextField(
                      obscureText: true,
                      decoration: ThemeHelper().textInputDecoration(
                          'Username', 'Enter your username'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 30.0),
                  //Email
                  Container(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: ThemeHelper()
                          .textInputDecoration('Email', 'Enter your email'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 30.0),
                  //PASSWORD
                  Container(
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: ThemeHelper().textInputDecoration(
                          'Password', 'Enter your password'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 30.0),
                  //No Handphone
                  //DAFTAR
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(
                      style: ThemeHelper().buttonStyle(),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          'Sign In'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      /*onPressed: () {
                        //After successful login we will redirect to profile page. Let's create profile page now
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },*/
                      onPressed: () async {
                        String username = _usernameController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String result = await _authService.signUp(
                            username, email, password);
                        if (result == 'success') {
                          // Pendaftaran berhasil, alihkan ke halaman login
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        } else {
                          // Tampilkan pesan error
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Data tidak terinput'),
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
                  SizedBox(height: 30.0),

                  //------------LOGIN---------------
                  Text(
                    "Or sign with",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: FaIcon(
                          FontAwesomeIcons.googlePlus,
                          size: 35,
                          color: HexColor("#EC2D2F"),
                        ),
                        onTap: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ThemeHelper().alartDialog(
                                    "Google Plus",
                                    "You tap on GooglePlus social icon.",
                                    context);
                              },
                            );
                          });
                        },
                      ),
                      SizedBox(width: 30.0),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                width: 5, color: HexColor("#40ABF0")),
                            color: HexColor("#40ABF0"),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 23,
                            color: HexColor("#FFFFFF"),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ThemeHelper().alartDialog("Twitter",
                                    "You tap on Twitter social icon.", context);
                              },
                            );
                          });
                        },
                      ),
                      SizedBox(width: 30.0),
                      GestureDetector(
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          size: 35,
                          color: HexColor("#3E529C"),
                        ),
                        onTap: () {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ThemeHelper().alartDialog(
                                    "Facebook",
                                    "You tap on Facebook social icon.",
                                    context);
                              },
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    //child: Text('Don\'t have an account? Create'),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Already have an accound? "),
                      TextSpan(
                        text: 'Log in Here',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
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
