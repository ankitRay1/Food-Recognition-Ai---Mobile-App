import 'package:flutter/material.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:foodie_pedia/cards/product_cards/smooth_product_card_found.dart';
import 'package:foodie_pedia/data_models/product_list.dart';

/// Widget for a [ProductList] item (simple product list)
class ProductListItemSimple extends StatelessWidget {
  const ProductListItemSimple({
    required this.product,
    this.onTap,
    this.onLongPress,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) => SmoothProductCardFound(
        heroTag: product.barcode!,
        product: product,
        onTap: onTap,
        onLongPress: onLongPress,
      );
}
