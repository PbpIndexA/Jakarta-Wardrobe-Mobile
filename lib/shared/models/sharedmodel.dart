// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    String uuid;
    Category category;
    String name;
    int price;
    String desc;
    String color;
    int stock;
    ShopName shopName;
    String location;
    String imgUrl;

    ProductEntry({
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
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        uuid: json["uuid"],
        category: categoryValues.map[json["category"]]!,
        name: json["name"],
        price: json["price"],
        desc: json["desc"],
        color: json["color"],
        stock: json["stock"],
        shopName: shopNameValues.map[json["shop_name"]]!,
        location: json["location"],
        imgUrl: json["img_url"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "category": categoryValues.reverse[category],
        "name": name,
        "price": price,
        "desc": desc,
        "color": color,
        "stock": stock,
        "shop_name": shopNameValues.reverse[shopName],
        "location": location,
        "img_url": imgUrl,
    };
}

enum Category {
    DRESS,
    FOOTWEAR,
    MEN_BOTTOMS,
    MEN_TOPS,
    SCARF,
    WOMEN_BOTTOMS,
    WOMEN_TOPS
}

final categoryValues = EnumValues({
    "Dress": Category.DRESS,
    "Footwear": Category.FOOTWEAR,
    "Men - Bottoms": Category.MEN_BOTTOMS,
    "Men - Tops": Category.MEN_TOPS,
    "Scarf": Category.SCARF,
    "Women - Bottoms": Category.WOMEN_BOTTOMS,
    "Women - Tops": Category.WOMEN_TOPS
});

enum ShopName {
    BUTTONSCARVES,
    NAYARA_BATIK,
    PARANG_KENCANA,
    THENBLANK,
    THIS_IS_APRIL
}

final shopNameValues = EnumValues({
    "Buttonscarves": ShopName.BUTTONSCARVES,
    "Nayara Batik": ShopName.NAYARA_BATIK,
    "Parang Kencana": ShopName.PARANG_KENCANA,
    "THENBLANK": ShopName.THENBLANK,
    "THIS IS APRIL": ShopName.THIS_IS_APRIL
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
