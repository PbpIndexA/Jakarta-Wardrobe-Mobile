import 'package:flutter/material.dart';
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
  int? _selectedRating;

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

      if (response['message'] == 'Rating added successfully') {
        fetchRatings(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rating added successfully')),
        );
      } else {
        print("${response['message']}");
        fetchRatings(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? '')),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: widget.product.imgUrl.isEmpty
                    ? const Icon(Icons.image_not_supported, size: 150)
                    : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text(
                    "Average Rating:",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < _avgRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "(${_avgRating.toStringAsFixed(1)})",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromARGB(255, 58, 56, 56),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text('Submit Rating'),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Rating Overview",
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('User', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Rating', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Timestamp', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _ratings
                            .map(
                              (rating) => DataRow(
                                cells: [
                                  DataCell(Text(rating.user)),
                                  DataCell(Text(rating.rating.toString())),
                                  DataCell(Text(rating.timestamp)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
