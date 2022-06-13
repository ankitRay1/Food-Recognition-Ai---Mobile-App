import 'package:flutter/material.dart';
import 'package:foodie_pedia/pages/history_page.dart';
import 'package:foodie_pedia/pages/page_manager.dart';
import 'package:foodie_pedia/pages/preferences/user_preferences_page.dart';
import 'package:foodie_pedia/pages/scan/scan_page.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavigationTab tabItem;

  @override
  Widget build(BuildContext context) {
    final Widget child;

    switch (tabItem) {
      case BottomNavigationTab.Profile:
        child = const UserPreferencesPage();
        break;
      case BottomNavigationTab.History:
        child = const HistoryPage();
        break;
      case BottomNavigationTab.Scan:
        child = const ScanPage();
        break;
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => child,
        );
      },
    );
  }
}
