import 'package:flutter/material.dart';
import 'package:habits_app/habits/ReportPage.dart';
import 'package:habits_app/today.dart';
import 'package:habits_app/weekly.dart';
import 'habits/AccountPage.dart';
import 'HomePage.dart';
import 'monthly.dart';
import 'habits/MyHabitsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _selectedIndex = 0; // Track the currently selected bottom navigation tab

  // List of pages to navigate
  final List<Widget> _pages = [
    HomePage(),
    ReportPage(),
    MyHabitsPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  // Function to handle navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        leading: Icon(Icons.checklist),
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: _selectedIndex == 0  ? TabBar(  // Show TabBar only on Home Page
          indicator: BoxDecoration(
            color: Color(0xFFBA68C8),
            borderRadius: BorderRadius.circular(10),
          ),
          controller: _tabController,
          tabs: [
            Tab(text: '     Today      '),
            Tab(text: '     Weekly     '),
            Tab(text: '     Monthly    '),
          ],
        )
            : null, // Remove TabBar on other pages
      ),
      body: _selectedIndex == 0
          ? TabBarView(
        controller: _tabController,
        children: [
          Today(), // Custom widget for 'Today' tab
          Weekly(), // Custom widget for 'Weekly' tab
          Monthly(), // Custom widget for 'Monthly' tab
        ],
      )
          : _pages[_selectedIndex], // Display the page based on selected tab

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        currentIndex: _selectedIndex, // Update the selected index
        onTap: _onItemTapped, // Add the onTap callback
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home, color: Colors.purple),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.purple),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined, color: Colors.purple),
            label: 'My Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.purple),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton:_selectedIndex==0? FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 30,
        ), // The + icon
        backgroundColor: Color(0xFFBA68C8),
        shape: CircleBorder(),
      ): SizedBox.shrink(),
    );
  }
}







