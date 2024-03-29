import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:foodie_pedia/database/local_database.dart';
import 'package:foodie_pedia/generic_lib/design_constants.dart';
import 'package:foodie_pedia/generic_lib/dialogs/smooth_alert_dialog.dart';
import 'package:foodie_pedia/helpers/product_cards_helper.dart';
import 'package:foodie_pedia/pages/product/common/product_refresher.dart';
import 'package:foodie_pedia/pages/product/simple_input_page_helpers.dart';

/// Simple input page: we have a list of terms, we add, we remove, we save.
class SimpleInputPage extends StatefulWidget {
  const SimpleInputPage(this.helper) : super();

  final AbstractSimpleInputPageHelper helper;

  @override
  State<SimpleInputPage> createState() => _SimpleInputPageState();
}

class _SimpleInputPageState extends State<SimpleInputPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    final LocalDatabase localDatabase = context.watch<LocalDatabase>();
    // that's a bit tricky here.
    // 1. we want to decide if we can go out of this page.
    // 1a. for this, we return an async bool, according to onWillPop.
    // 2. but we also want to return the changed Product.
    return WillPopScope(
      onWillPop: () async {
        final Product? changedProduct = widget.helper.getChangedProduct();
        if (changedProduct == null) {
          return true;
        }
        final bool? pleaseSave = await showDialog<bool>(
          context: context,
          builder: (final BuildContext context) => SmoothAlertDialog(
            close: true,
            body:
                Text(appLocalizations.edit_product_form_item_exit_confirmation),
            title: widget.helper.getTitle(),
            negativeAction: SmoothActionButton(
              text: appLocalizations.ignore,
              onPressed: () => Navigator.pop(context, false),
            ),
            positiveAction: SmoothActionButton(
              text: appLocalizations.save,
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
        );
        if (pleaseSave == null) {
          return false;
        }
        if (pleaseSave == false) {
          return true;
        }
        final Product? savedAndRefreshed =
            await ProductRefresher().saveAndRefresh(
          context: context,
          localDatabase: localDatabase,
          product: changedProduct,
        );
        if (savedAndRefreshed == null) {
          // it failed: we stay on the same page
          return false;
        }
        // tricky part (cf. https://stackoverflow.com/questions/53995673/willpopscope-should-i-use-return-future-valuetrue-after-navigator-pop)
        // 1. we return true to get out of this page.
        // 2. we pop the product because the calling page needs it.
        //ignore: use_build_context_synchronously
        Navigator.pop(context, savedAndRefreshed);
        return Future<bool>(() => true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            getProductName(widget.helper.product, appLocalizations),
            maxLines: 2,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(SMALL_SPACE),
          child: ListView(
            children: <Widget>[
              Text(
                widget.helper.getTitle(),
                style: themeData.textTheme.headline1,
              ),
              if (widget.helper.getSubtitle() != null)
                Text(widget.helper.getSubtitle()!),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (widget.helper.addTerm(_controller.text)) {
                        setState(() => _controller.text = '');
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                  Flexible(
                    flex: 1, // maximum size, as the other guy has no flex
                    child: Padding(
                      padding: const EdgeInsets.all(LARGE_SPACE),
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: CIRCULAR_BORDER_RADIUS,
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: SMALL_SPACE,
                            vertical: SMALL_SPACE,
                          ),
                          hintText: widget.helper.getAddHint(),
                        ),
                        controller: _controller,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: themeData.colorScheme.onBackground),
              Wrap(
                direction: Axis.horizontal,
                spacing: LARGE_SPACE,
                runSpacing: VERY_SMALL_SPACE,
                children: List<Widget>.generate(
                  widget.helper.terms.length,
                  (final int index) {
                    final String term = widget.helper.terms[index];
                    return ElevatedButton.icon(
                      icon: const Icon(Icons.clear),
                      label: Text(term),
                      onPressed: () async {
                        if (widget.helper.removeTerm(term)) {
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
