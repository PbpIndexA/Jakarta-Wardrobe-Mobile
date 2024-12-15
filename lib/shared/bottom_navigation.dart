import 'package:flutter/material.dart';
import 'package:jawa_app/product/screens/list_product_page.dart';
import 'package:jawa_app/userchoice/screens/userchoice_page.dart';
import 'package:jawa_app/home.dart'; // Pastikan untuk mengimpor file home.dart

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Color.fromARGB(255, 53, 52, 52),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag,
            color: Color.fromARGB(255, 53, 52, 52),
          ),
          label: 'Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_reaction_rounded,
            color: Color.fromARGB(255, 53, 52, 52),
          ),
          label: 'User Choice',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Color.fromARGB(255, 53, 52, 52),
          ),
          label: 'Global Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: Color.fromARGB(255, 53, 52, 52),
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 33, 32, 31),
      onTap: widget.onItemTapped,
    );
  }
}
