import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_feeder/pages/control_page_stream.dart';
import 'package:pet_feeder/pages/feeding_control_page.dart';
import 'package:pet_feeder/pages/home_page.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({Key? key}) : super(key: key);

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    FeedingControlPage(),
    HomePage(),
    ControlPageStream(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Pet feeder', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey,
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 40),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dining),
            label: 'Feedings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alarm_rounded),
            label: 'Schedules',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey[400],
        selectedItemColor: Colors.black54,
        selectedIconTheme: const IconThemeData(size: 32),
        onTap: _onItemTapped,
      ),
    );
  }
}
