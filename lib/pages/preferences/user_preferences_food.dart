import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:openfoodfacts/model/AttributeGroup.dart';
import 'package:provider/provider.dart';
import 'package:foodie_pedia/data_models/product_preferences.dart';
import 'package:foodie_pedia/data_models/user_preferences.dart';
import 'package:foodie_pedia/generic_lib/design_constants.dart';
import 'package:foodie_pedia/pages/preferences/abstract_user_preferences.dart';
import 'package:foodie_pedia/pages/preferences/user_preferences_attribute_group.dart';
import 'package:foodie_pedia/pages/preferences/user_preferences_page.dart';

/// Collapsed/expanded display of attribute groups for the preferences page.
class UserPreferencesFood extends AbstractUserPreferences {
  UserPreferencesFood({
    required this.productPreferences,
    required final Function(Function()) setState,
    required final BuildContext context,
    required final UserPreferences userPreferences,
    required final AppLocalizations appLocalizations,
    required final ThemeData themeData,
  }) : super(
          setState: setState,
          context: context,
          userPreferences: userPreferences,
          appLocalizations: appLocalizations,
          themeData: themeData,
        );

  final ProductPreferences productPreferences;

  static const List<String> _ORDERED_ATTRIBUTE_GROUP_IDS = <String>[
    AttributeGroup.ATTRIBUTE_GROUP_NUTRITIONAL_QUALITY,
    AttributeGroup.ATTRIBUTE_GROUP_INGREDIENT_ANALYSIS,
    AttributeGroup.ATTRIBUTE_GROUP_ENVIRONMENT,
    AttributeGroup.ATTRIBUTE_GROUP_PROCESSING,
    AttributeGroup.ATTRIBUTE_GROUP_LABELS,
    AttributeGroup.ATTRIBUTE_GROUP_ALLERGENS,
  ];

  @override
  PreferencePageType? getPreferencePageType() => PreferencePageType.FOOD;

  @override
  String getTitleString() => appLocalizations.myPreferences_food_title;

  @override
  Widget? getSubtitle() => Text(appLocalizations.myPreferences_food_subtitle);

  @override
  IconData getLeadingIconData() => Icons.ramen_dining;

  @override
  String? getHeaderAsset() => 'assets/app/food.png';

  @override
  Color? getHeaderColor() => const Color(0xFFEBF1FF);

  @override
  List<Widget> getBody() {
    final List<Widget> result = <Widget>[
      // we don't want this on the onboarding
      ListTile(
        leading: const Icon(Icons.rotate_left),
        title: Text(appLocalizations.reset_food_prefs),
        onTap: () => _confirmReset(context),
      ),
    ];
    result.addAll(_getOnboardingBody());
    return result;
  }

  List<AttributeGroup> _reorderGroups(List<AttributeGroup> groups) {
    final List<AttributeGroup> result = <AttributeGroup>[];
    for (final String id in _ORDERED_ATTRIBUTE_GROUP_IDS) {
      result.addAll(groups.where((AttributeGroup g) => g.id == id));
    }
    result.addAll(groups.where(
        (AttributeGroup g) => !_ORDERED_ATTRIBUTE_GROUP_IDS.contains(g.id)));
    return result;
  }

  void _confirmReset(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.confirmResetPreferences),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.yes),
              onPressed: () async {
                await context.read<ProductPreferences>().resetImportances();
                //ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(localizations.no),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  /// Returns a slightly different version of [getContent] for the onboarding.
  List<Widget> getOnboardingContent() => <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LARGE_SPACE),
          child: Text(
            getTitleString(),
            style: themeData.textTheme.headline2,
          ),
        ),
        ..._getOnboardingBody(),
      ];

  List<Widget> _getOnboardingBody() {
    final List<AttributeGroup> groups =
        _reorderGroups(productPreferences.attributeGroups!);
    final List<Widget> result = <Widget>[
      ListTile(
        title: Text(appLocalizations.myPreferences_food_comment),
      ),
    ];
    for (final AttributeGroup group in groups) {
      final AbstractUserPreferences abstractUserPreferences =
          UserPreferencesAttributeGroup(
        productPreferences: productPreferences,
        group: group,
        setState: setState,
        context: context,
        userPreferences: userPreferences,
        appLocalizations: appLocalizations,
        themeData: themeData,
      );

      result.addAll(abstractUserPreferences.getContent());
    }
    return result;
  }
}
