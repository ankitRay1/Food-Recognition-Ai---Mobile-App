import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodie_pedia/data_models/continuous_scan_model.dart';
import 'package:foodie_pedia/pages/personalized_ranking_page.dart';
import 'package:foodie_pedia/pages/product/common/product_query_page_helper.dart';

Future<void> openPersonalizedRankingPage(BuildContext context) async {
  final ContinuousScanModel model = context.read<ContinuousScanModel>();
  await model.refreshProductList();
  //ignore: use_build_context_synchronously
  await Navigator.push<Widget>(
    context,
    MaterialPageRoute<Widget>(
      builder: (BuildContext context) => PersonalizedRankingPage(
        products: model.productList.getList(),
        title: ProductQueryPageHelper.getProductListLabel(
          model.productList,
          context,
        ),
      ),
    ),
  );
  await model.refresh();
}
