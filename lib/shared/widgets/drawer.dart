import 'package:flutter/material.dart';
import 'package:jawa_app/article/screens/listarticle.dart';
import 'package:jawa_app/home.dart';
import 'package:jawa_app/userchoice/screens/userchoice_page.dart';
import 'package:jawa_app/product/screens/list_product_page.dart';
import 'package:jawa_app/globalchat/screens/forum_screen.dart';


class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Jawa App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Ini buat biar bisa routing sementara",
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('User Choices'),
            onTap: () {
                // Route menu ke halaman mood
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserChoicePage()),
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_reaction_rounded),
            title: const Text('List Produk'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const ProductListPage(), // Rute menuju ProductListPage
                  ));
            },
          ),
          //  ListTile untuk Forum
          ListTile(
            leading: const Icon(Icons.forum),
            title: const Text('Forums'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForumScreen(),
                ),
              );
            },
          ),
          
          ListTile(
          leading: const Icon(Icons.article),
          title: const Text('Artikel'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ArticleListPage()),
            );
            },
          ),

        ],
      ),
    );
  }
}