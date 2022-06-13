import 'package:flutter/material.dart';
import 'package:foodie_pedia/cards/category_cards/abstract_cache.dart';

/// Empty image cache: the url was null, there is not much we can display.
class NullCache extends AbstractCache {
  const NullCache({
    final double? width,
    final double? height,
  }) : super(
          null,
          width: width,
          height: height,
        );

  @override
  Widget build(BuildContext context) => getDefaultUnknown();
}
