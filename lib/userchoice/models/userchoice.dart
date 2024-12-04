// To parse this JSON data, do
//
//     final userChoice = userChoiceFromJson(jsonString);

import 'dart:convert';

List<UserChoice> userChoiceFromJson(String str) => List<UserChoice>.from(json.decode(str).map((x) => UserChoice.fromJson(x)));

String userChoiceToJson(List<UserChoice> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserChoice {
    String uuid;
    String category;
    String name;
    String price;
    String desc;
    String color;
    int stock;
    String shopName;
    String location;
    String imgUrl;
    int avgRating;
    String notes;

    UserChoice({
        required this.uuid,
        required this.category,
        required this.name,
        required this.price,
        required this.desc,
        required this.color,
        required this.stock,
        required this.shopName,
        required this.location,
        required this.imgUrl,
        required this.avgRating,
        required this.notes,
    });

    factory UserChoice.fromJson(Map<String, dynamic> json) => UserChoice(
        uuid: json["uuid"],
        category: json["category"],
        name: json["name"],
        price: json["price"],
        desc: json["desc"],
        color: json["color"],
        stock: json["stock"],
        shopName: json["shop_name"],
        location: json["location"],
        imgUrl: json["img_url"],
        avgRating: json["avg_rating"],
        notes: json["notes"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "category": category,
        "name": name,
        "price": price,
        "desc": desc,
        "color": color,
        "stock": stock,
        "shop_name": shopName,
        "location": location,
        "img_url": imgUrl,
        "avg_rating": avgRating,
        "notes": notes,
    };
}
