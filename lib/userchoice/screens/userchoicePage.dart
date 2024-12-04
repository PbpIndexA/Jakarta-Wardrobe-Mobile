import 'package:flutter/material.dart';
import 'package:jawa_app/userchoice/models/userchoice.dart';
import 'package:jawa_app/shared/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class UserChoicePage extends StatefulWidget {
  const UserChoicePage({super.key});

  @override
  State<UserChoicePage> createState() => _UserChoicePageState();
}

class _UserChoicePageState extends State<UserChoicePage> {
  Future<List<UserChoice>> fetchUserChoices(CookieRequest request) async {
    // Fetch data from the Django backend
    final response = await request.get('http://127.0.0.1:8000/user_choices/json/');

    // Debug: Print the raw response
    print("Raw Response: $response");

    // Convert JSON data to List<UserChoice>
    List<UserChoice> userChoices = [];
    for (var d in response) {
      if (d != null) {
        userChoices.add(UserChoice.fromJson(d));
      }
    }
    return userChoices;
  }

  @override
  Widget build(BuildContext context) {
    final cookieRequest = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Choices'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchUserChoices(cookieRequest),
        builder: (context, AsyncSnapshot<List<UserChoice>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No user choices available.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final choice = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ${choice.name}",
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Category: ${choice.category}"),
                      const SizedBox(height: 10),
                      Text("Price: \$${choice.price}"),
                      const SizedBox(height: 10),
                      Text("Description: ${choice.desc}"),
                      const SizedBox(height: 10),
                      Text("Color: ${choice.color}"),
                      const SizedBox(height: 10),
                      Text("Stock: ${choice.stock}"),
                      const SizedBox(height: 10),
                      Text("Shop Name: ${choice.shopName}"),
                      const SizedBox(height: 10),
                      Text("Location: ${choice.location}"),
                      const SizedBox(height: 10),
                      Image.network(
                        choice.imgUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text("Average Rating: ${choice.avgRating}"),
                      const SizedBox(height: 10),
                      Text("Notes: ${choice.notes}"),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
