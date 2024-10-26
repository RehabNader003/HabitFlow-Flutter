import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_app/chartPage.dart';
import 'package:project_app/create_new_habit.dart';
import 'package:project_app/profile.dart';
import 'package:project_app/today.dart';
import 'package:project_app/weeklyscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserData(); // Fetch user data in the background
  }

  // Function to fetch user data
  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userData =
              snapshot.data() as Map<String, dynamic>?; // Storing user data
        });
      } catch (e) {
        print('Error fetching user data: $e'); // Handle errors if needed
      }
    }
  }

  // Function to handle navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const HomePage(),
      Chartpage(),
      const Scaffold(
        body: ProfilePage(),
      ),
    ];

    return Scaffold(
      appBar: _selectedIndex == 0 // Show app bar only for the Home page
          ? AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
              leading: const Icon(Icons.checklist),
              centerTitle: true,
              title: const Text(
                "Home",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              bottom: _selectedIndex == 0
                  ? TabBar(
                      indicator: BoxDecoration(
                        color: const Color(0xFFBA68C8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      controller: _tabController,
                      tabs: const [
                        Tab(text: '     Today      '),
                        Tab(text: '     Weekly     '),
                      ],
                    )
                  : null, // Remove TabBar on other pages
            )
          : null, // No app bar for other pages
      body: _selectedIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                const Today(),
                WeeklyHabitsScreen(),
              ],
            )
          : Padding(
              padding:
                  const EdgeInsets.only(top: 20.0), // Add space from the top
              child: _pages[
                  _selectedIndex], // Display the page based on selected tab
            ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            icon: Icon(Icons.account_circle, color: Colors.purple),
            label: 'Account',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreateHabitScreen()));
              },
              backgroundColor: const Color(0xFFBA68C8),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
