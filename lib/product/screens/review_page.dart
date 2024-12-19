import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jawa_app/product/models/sharedmodel.dart' as sharedmodel;

class RatingPage extends StatefulWidget {
  final sharedmodel.ProductEntry product;

  const RatingPage({super.key, required this.product});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final List<Rating> _ratings = [];
  double _avgRating = 0.0;
  int? _selectedRating; // Rating yang dipilih oleh pengguna

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    fetchRatings(request);
  }

  Future<void> fetchRatings(CookieRequest request) async {
    final productId = widget.product.uuid;
    final response = await request.get(
      'http://127.0.0.1:8000/products/products/$productId/ratings/',
    );

    if (response['ratings'] != null) {
      final ratingsData = response['ratings'];
      setState(() {
        _ratings.clear();
        for (var ratingJson in ratingsData) {
          _ratings.add(Rating.fromJson(ratingJson));
        }
        _avgRating = calculateAverageRating(_ratings);
      });
    } else {
      print('Failed to fetch ratings: Unexpected response format');
    }
  }

  double calculateAverageRating(List<Rating> ratings) {
    if (ratings.isEmpty) return 0.0;
    final total = ratings.fold(0, (sum, item) => sum + item.rating);
    return total / ratings.length;
  }

  Future<void> submitRating(int ratingValue, CookieRequest request) async {
    final body = {
      'product_id': widget.product.uuid,
      'rating': ratingValue.toString(),
    };

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/products/add_rating/',
        body,
      );

      if (response['message'] == 'Rating submitted successfully') {
        fetchRatings(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating submitted successfully!')),
        );
      } else {
        print("Failed to submit rating: ${response['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to submit rating')),
        );
      }
    } catch (e) {
      print("Error submitting rating: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while submitting the rating')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Column(
        children: [
          // Display product image
          ClipRRect(
            child: Image.network(
              widget.product.imgUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 250);
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Average Rating: ${_avgRating.toStringAsFixed(1)}",
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Text(
            "Select Your Rating",
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return IconButton(
                icon: Icon(
                  _selectedRating != null && _selectedRating! >= starIndex
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _selectedRating = starIndex;
                  });
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedRating != null) {
                submitRating(_selectedRating!, request);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a rating!')),
                );
              }
            },
            child: const Text('Submit Rating'),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _ratings.length,
              itemBuilder: (context, index) {
                final rating = _ratings[index];
                return ListTile(
                  title: Text(rating.user),
                  subtitle: Text("Rating: ${rating.rating}"),
                  trailing: Text(rating.timestamp),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Rating {
  final String user;
  final int rating;
  final String timestamp;

  Rating({required this.user, required this.rating, required this.timestamp});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      user: json['user'],
      rating: json['rating'],
      timestamp: json['timestamp'],
    );
  }
}

class ProductEntry {
  final String uuid;
  final String name;
  final String imgUrl;

  ProductEntry({required this.uuid, required this.name, required this.imgUrl});
}
