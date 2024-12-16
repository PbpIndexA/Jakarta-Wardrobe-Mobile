import 'package:flutter/material.dart';
import 'package:jawa_app/auth/screens/login.dart';
import 'package:jawa_app/userchoice/screens/userchoice_page.dart';
import 'package:jawa_app/product/screens/list_product_page.dart';
import 'package:jawa_app/globalchat/screens/forum_screen.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ProductListPage(),
    UserChoicePage(),
    GlobalChatPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 53, 52, 52),
              ),
              label: 'Home'),
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 33, 32, 31),
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<ItemHomepage> items = [
    ItemHomepage("Categories", Icons.category),
    ItemHomepage("Product", Icons.shopping_bag),
    ItemHomepage("User Choice", Icons.add_reaction_rounded),
    ItemHomepage("About Us", Icons.info),
    ItemHomepage("Global Chat", Icons.chat),
    ItemHomepage("FAQ", Icons.help),
    ItemHomepage("Article", Icons.article),
    ItemHomepage("More", Icons.more_horiz),
  ];

  final List<String> brands = [
    "Brand 1",
    "Brand 2",
    "Brand 3",
    "Brand 4",
    "Brand 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/hero.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Grid of Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                shrinkWrap: true,
                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ),
            // Brands Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Best Picks in Town",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: brands.map((String brand) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[200],
                            ),
                            child: Center(
                              child: Text(
                                brand,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Logout") {
            final response =
                await request.logout("http://127.0.0.1:8000/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: const Color.fromARGB(255, 54, 52, 52),
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 57, 54, 54), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

// Dummy pages for navigation
// class GlobalChatPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text('Global Chat Page')),
//     );
//   }
// }
class GlobalChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ForumScreen(); // Menggunakan ForumScreen yang sudah dibuat
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Profile Page')),
    );
  }
}
