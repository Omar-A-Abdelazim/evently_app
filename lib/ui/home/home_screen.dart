import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/ui/events_management/events_management_screen.dart';
import 'package:evently_app/ui/home/tabs/favorite/favorite_tab.dart';
import 'package:evently_app/ui/home/tabs/home/home_tab.dart';
import 'package:evently_app/ui/home/tabs/profile/profile_tab.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [HomeTab(), FavoriteTab(), ProfileTab()];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, EventsManagementScreen.routeName);
          },
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            if (index == selectedIndex) return;
            setState(() {
              selectedIndex = index;
            });
          },

          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite),
              label: AppLocalizations.of(context)!.favorites,
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.person),
              icon: Icon(Icons.person),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
      body: tabs[selectedIndex],
    );
  }
}
