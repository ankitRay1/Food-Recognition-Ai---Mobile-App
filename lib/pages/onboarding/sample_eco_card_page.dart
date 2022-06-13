import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:foodie_pedia/database/local_database.dart';
import 'package:foodie_pedia/pages/onboarding/knowledge_panel_page_template.dart';
import 'package:foodie_pedia/pages/onboarding/onboarding_flow_navigator.dart';

class SampleEcoCardPage extends StatelessWidget {
  const SampleEcoCardPage(this._localDatabase, this.backgroundColor);

  final LocalDatabase _localDatabase;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => KnowledgePanelPageTemplate(
        headerTitle: AppLocalizations.of(context).ecoCardUtility,
        page: OnboardingPage.ECO_CARD_EXAMPLE,
        panelId: 'environment_card',
        localDatabase: _localDatabase,
        backgroundColor: backgroundColor,
        svgAsset: 'assets/onboarding/eco.svg',
      );
}
