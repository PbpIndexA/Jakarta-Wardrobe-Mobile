import 'package:flutter/material.dart';
import 'package:jawa_app/shared/models/sharedmodel.dart';

class ReviewPage extends StatelessWidget {
  final ProductEntry product;

  const ReviewPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Review")),
      body: Center(
        child: Text("Halaman Review untuk produk: ${product.name}"),
      ),
    );
  }
}
