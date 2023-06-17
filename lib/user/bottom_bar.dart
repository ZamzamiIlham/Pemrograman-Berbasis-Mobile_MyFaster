import 'package:flutter/material.dart';
import 'home_page.dart';
import 'list_paket.dart';
import 'profile_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const Home(),
    PaketList(),
    Profile(),
  ];
// 9
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      //-------------- Bottom Navigation ---------------//
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50,
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        color: Color.fromARGB(
            255, 243, 159, 33), // Warna latar belakang item yang aktif
        buttonBackgroundColor: Color.fromARGB(
            255, 243, 159, 33), // Warna latar belakang item ketika di tap
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.check_box, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
