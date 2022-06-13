import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:provider/provider.dart';
import 'package:foodie_pedia/data_models/continuous_scan_model.dart';
import 'package:foodie_pedia/generic_lib/design_constants.dart';
import 'package:foodie_pedia/helpers/extension_on_text_helper.dart';
import 'package:foodie_pedia/helpers/product_cards_helper.dart';
import 'package:foodie_pedia/pages/product/add_basic_details_page.dart';

class ProductTitleCard extends StatelessWidget {
  const ProductTitleCard(
    this.product,
    this.isSelectable, {
    this.dense = false,
    this.isRemovable = true,
  });

  final Product product;
  final bool dense;
  final bool isSelectable;
  final bool isRemovable;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final String subtitleText;
    final Widget trailingWidget;
    final String brands = product.brands ?? appLocalizations.unknownBrand;
    final String quantity = product.quantity ?? '';
    if (isRemovable && !isSelectable) {
      final ContinuousScanModel model = context.watch<ContinuousScanModel>();
      subtitleText = '$brands${quantity == '' ? '' : ', $quantity'}';
      trailingWidget = InkWell(
        onTap: () async => model.removeBarcode(product.barcode!),
        child: const Icon(
          Icons.clear_rounded,
          size: MINIMUM_TOUCH_SIZE,
        ),
      );
    } else {
      subtitleText = brands;
      trailingWidget = Text(
        quantity,
        style: themeData.textTheme.headline3,
      ).selectable(isSelectable: isSelectable);
    }
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: (getProductName(product, appLocalizations) ==
                appLocalizations.unknownProductName)
            ? () async {
                await Navigator.push<Product?>(
                  context,
                  MaterialPageRoute<Product>(
                    builder: (BuildContext context) =>
                        AddBasicDetailsPage(product),
                  ),
                );
              }
            : null,
        child: ListTile(
          dense: dense,
          contentPadding: EdgeInsets.zero,
          title: Text(
            getProductName(product, appLocalizations),
            style: themeData.textTheme.headline4,
          ).selectable(isSelectable: isSelectable),
          subtitle: Text(
            subtitleText,
          ).selectable(isSelectable: isSelectable),
          trailing: trailingWidget,
        ),
      ),
    );
  }
}
