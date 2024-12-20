
import 'package:flutter/material.dart';
import 'package:jawa_app/product/screens/comment_page.dart';
import 'package:jawa_app/product/screens/review_page.dart';
import 'package:jawa_app/product/models/sharedmodel.dart' as sharedmodel;

class DetailDialog extends StatelessWidget {
  final sharedmodel.ProductEntry product;

  const DetailDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const String defaultImageUrl =
    'https://thenblank.com/cdn/shop/products/MenBermudaPants_Fern_2_360x.jpg?v=1665997444'; // Default image URL



    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: screenWidth * 0.85, // 85% dari lebar layar
        height: screenHeight * 0.8, // 80% dari tinggi layar
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dan detail
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bagian gambar
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.imgUrl.isNotEmpty
                          ? product.imgUrl
                          : defaultImageUrl,

                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            defaultImageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },

                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bagian detail
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama produk
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 24, // Ukuran lebih besar
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Detail produk
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Category: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: product.category.name),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Price: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "Rp${product.price}"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Description: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: product.desc),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Color: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: product.color),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Stock: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "${product.stock}"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Shop Name: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: product.shopName.name),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Location: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: product.location),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tombol Review dan Comment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol Review
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Review
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RatingPage(product: product)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor:  Color.fromARGB(255, 58, 56, 56),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Review"),
                ),
                // Tombol Comment
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman Comment
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CommentPage(product: product)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor:  Color.fromARGB(255, 58, 56, 56),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Comment"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

