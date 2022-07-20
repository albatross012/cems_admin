import 'dart:developer';

import 'package:cems_admin/activeEvent.dart';
import 'package:cems_admin/activefeed.dart';
import 'package:cems_admin/register_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({Key? key}) : super(key: key);
  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ActiveEvent(),
    ActiveFeed(),
    RegisterDetail(),
    Text(
      'History',
      style: optionStyle,
    ),
    Text(
      'Results',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    log(index.toString());
    setState(() {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 10),
        curve: Curves.ease,
      );
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xff36CDC6),
                ),
                child: Center(
                  child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/eventmanagement-7d33f.appspot"
                      ".com/o/logocms_page-0001__1_-removebg-preview.png?alt=media&token=1444175f-e5ee-4a2f-bea1-9c4a020d25af"),
                ),
              ),
              ListTile(
                title: const Text('Events'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              const ListTile(title: Text('mbits'))
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color(0xff36CDC6),
          title: const Text('CEMS ADMIN'),
        ),
        body: Center(
          child: PageView(
            onPageChanged: ((value) {
              setState(() {
                _selectedIndex = value.toInt();
              });
            }),
            controller: _pageController,
            children: const [..._widgetOptions],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feed),
              label: 'Feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: 'Manage',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Report',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.badge), label: 'Results')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff36CDC6),
          unselectedItemColor: const Color(0xff36CDC6),
          onTap: _onItemTapped,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
