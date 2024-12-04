class ProductEntry {
  final String uuid;
  final String category;
  final String name;
  final double price;
  final String? desc;
  final String color;
  final int stock;
  final String shopName;
  final String location;
  final String imgUrl;

  ProductEntry({
    required this.uuid,
    required this.category,
    required this.name,
    required this.price,
    this.desc,
    required this.color,
    required this.stock,
    required this.shopName,
    required this.location,
    required this.imgUrl,
  });

  factory ProductEntry.fromJson(Map<String, dynamic> json) {
    return ProductEntry(
      uuid: json['uuid'] ?? '',
      category: json['category'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      desc: json['desc'],
      color: json['color'] ?? '',
      stock: json['stock'] ?? 0,
      shopName: json['shop_name'] ?? '',
      location: json['location'] ?? '',
      imgUrl: json['img_url'] ?? '',
    );
  }
}
