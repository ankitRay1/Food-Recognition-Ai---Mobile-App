import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:foodie_pedia/data_models/continuous_scan_model.dart';
import 'package:foodie_pedia/generic_lib/design_constants.dart';
import 'package:foodie_pedia/pages/product/common/product_dialog_helper.dart';

/// Product Card when an exception is caught
class SmoothProductCardError extends StatelessWidget {
  const SmoothProductCardError({required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: themeData.brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        borderRadius: ROUNDED_BORDER_RADIUS,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(barcode, style: Theme.of(context).textTheme.subtitle1),
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          ProductDialogHelper.getErrorMessage(
            appLocalizations.product_internet_error,
          ),
          const SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
            onPressed: () async {
              await context
                  .read<ContinuousScanModel>()
                  .retryBarcodeFetch(barcode);
            },
            child: Text(appLocalizations.retry_button_label),
          ),
        ],
      ),
    );
  }
}
