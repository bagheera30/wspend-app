import 'package:Wspend/Add/addExpends.dart';
import 'package:Wspend/Add/addIncome.dart';
import 'package:Wspend/navbar/homePage.dart';
import 'package:Wspend/navbar/laporan.dart';
import 'package:Wspend/navbar/limitPage.dart';
import 'package:Wspend/navbar/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  final _pgc = PageController(initialPage: 0);
  final List<Widget> _pages = const [
    HomePage(),
    LimitPage(),
    AddIncomePage(),
    LaporanPage(),
    ProfilePage(),
  ];
  final auth = FirebaseAuth.instance;
  bool _isAddExpanded = false;

  void _goToPage(int page) {
    setState(() {
      _current = page;
      _isAddExpanded = false;
    });
    _pgc.jumpToPage(page);
  }

  void _goToAddIncomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIncomePage()),
    );
  }

  void _goToExpandedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpendesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: PageView(
            controller: _pgc,
            onPageChanged: (i) {
              setState(() {
                _current = i;
                _isAddExpanded =
                    false; // Hide the expanded buttons when changing pages
              });
            },
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (index) {
          if (index == 2) {
            setState(() {
              _isAddExpanded = !_isAddExpanded;
            });
          } else {
            _goToPage(index);
          }
        },
        selectedItemColor: const Color.fromARGB(255, 131, 109, 0),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 253, 216, 52),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'limit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_outlined),
            label: 'add',
            backgroundColor: Color.fromARGB(255, 253, 216, 52),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'laporan',
            backgroundColor: Color.fromARGB(255, 253, 216, 52),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Color.fromARGB(255, 253, 216, 52),
          ),
        ],
      ),
      floatingActionButton: _isAddExpanded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 170, 148, 43),
                  onPressed: () {
                    _goToAddIncomePage();
                  },
                  heroTag: null,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  backgroundColor: const Color.fromARGB(255, 170, 148, 43),
                  onPressed: _goToExpandedPage,
                  heroTag: null,
                  child: const Icon(Icons.expand, color: Colors.white),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
