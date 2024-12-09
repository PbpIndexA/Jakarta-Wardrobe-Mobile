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

    // Convert JSON data to List<UserChoice>
    List<UserChoice> userChoices = [];
    for (var d in response) {
      if (d != null) {
        userChoices.add(UserChoice.fromJson(d));
      }
    }
    return userChoices;
  }

  Future<void> deleteUserChoice(CookieRequest request, String uuid) async {
    // Perform DELETE request to remove the product from user choices
    final response = await request.post(
      'http://127.0.0.1:8000/user_choices/delete_user_choices/$uuid',
      {}
    );
    if (response['status'] == 'success') {
      // Successfully deleted
      setState(() {});
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove item: ${response['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cookieRequest = context.watch<CookieRequest>();
    const String defaultImageUrl =
        'https://thenblank.com/cdn/shop/products/MenBermudaPants_Fern_2_360x.jpg?v=1665997444'; // Default image URL

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
                'Terjadi kesalahan: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada produk yang tersedia.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4.5,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final choice = snapshot.data![index];
                bool isLiked = true; // Default state since it's in user choices

                return GestureDetector(
                  onTap: () {
                    // Navigate or handle tap for user choice
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(choice.name),
                          content: Text("Details for ${choice.name}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            )
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section with Like Button
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                choice.imgUrl.isNotEmpty
                                    ? choice.imgUrl
                                    : defaultImageUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Render the default image if the image fails to load
                                  return Image.network(
                                    defaultImageUrl,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  // Perform deletion when unliked
                                  if (isLiked) {
                                    deleteUserChoice(cookieRequest, choice.uuid);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        // Content Section
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                choice.name,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              // Category
                              Text(
                                choice.category,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              // Price
                              Text(
                                "Rp ${choice.price}",
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
