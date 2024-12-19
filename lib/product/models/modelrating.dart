import 'dart:convert';
import 'package:http/http.dart' as http;

List<Rating> ratingFromJson(String str) => List<Rating>.from(json.decode(str).map((x) => Rating.fromJson(x)));

String ratingToJson(List<Rating> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rating {
    List<List<dynamic>> ratingChoices;
    String uuid;
    String product;
    int user;
    int rating;
    DateTime timestamp;

    Rating({
        required this.ratingChoices,
        required this.uuid,
        required this.product,
        required this.user,
        required this.rating,
        required this.timestamp,
    });

    factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        ratingChoices: List<List<dynamic>>.from(json["RATING_CHOICES"].map((x) => List<dynamic>.from(x.map((x) => x)))),
        uuid: json["uuid"],
        product: json["product"],
        user: json["user"],
        rating: json["rating"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "RATING_CHOICES": List<dynamic>.from(ratingChoices.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "uuid": uuid,
        "product": product,
        "user": user,
        "rating": rating,
        "timestamp": timestamp.toIso8601String(),
    };

    // Fungsi untuk mendapatkan daftar rating dari API
    static Future<List<Rating>> fetchRatings() async {
      final response = await http.get(Uri.parse('http://your-django-api-url/ratings/'));

      if (response.statusCode == 200) {
        // Jika server mengembalikan response OK, kita parse data JSON
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((rating) => Rating.fromJson(rating)).toList();
      } else {
        // Jika gagal, throw exception
        throw Exception('Failed to load ratings');
      }
    }

    // Getter untuk nama user
    int get getUser => user;

    // Getter untuk timestamp
    DateTime get getTimestamp => timestamp;
}
