import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_feeder/pages/control_page_stream.dart';
import 'package:pet_feeder/pages/feeding_control_page.dart';
import 'package:pet_feeder/pages/home_page.dart';
import 'package:pet_feeder/service/app_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 1;
  bool _loaded = false;
  AppService appService = AppService.instance;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    FeedingControlPage(),
    HomePage(),
    ControlPageStream(),
  ];

  void loadData() async {
    await appService.initialize();
    _loaded = true;
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded) {
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
    } else {
      return Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "Loading",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator()
          ],
        ),
      );
    }
  }
}
