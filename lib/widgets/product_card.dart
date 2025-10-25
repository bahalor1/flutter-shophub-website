import 'package:alisveris_sitesi/views/product_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alisveris_sitesi/services/favorite_service.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);

    final defaultShadow = BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 2,
      blurRadius: 8,
      offset: const Offset(0, 4),
    );
    final hoverShadow = BoxShadow(
      // ignore: deprecated_member_use
      color: Colors.grey.withOpacity(0.4),
      spreadRadius: 4,
      blurRadius: 12,
      offset: const Offset(0, 6),
    );

    return Consumer<FavoriteService>(
      builder: (context, favoriteService, child) {
        final bool isFavorite = favoriteService.isFavorite(widget.product);
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product: widget.product),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: duration,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [_isHovered ? hoverShadow : defaultShadow],
                  ),
                  transform: _isHovered
                      // ignore: deprecated_member_use
                      ? (Matrix4.identity()..translate(0, -5, 0))
                      : Matrix4.identity(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          duration: duration,
                          scale: _isHovered ? 1.05 : 1.0,
                          child: Image.network(
                            widget.product['image'],
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const SizedBox(height: 20),
                              Text(
                                widget.product['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product['brand'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.product['price'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    widget.product['stock'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: widget.product['stock'] == 'Stokta'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.product['tag'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      favoriteService.toggleFavorite(widget.product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.grey[600],
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
