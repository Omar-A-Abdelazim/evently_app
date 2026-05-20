import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/date_extension.dart';
import 'package:evently_app/data/firebase/firebase_events_database.dart';
import 'package:evently_app/data/models/category.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:evently_app/ui/home/widgets/event_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseEventsDatabase database = FirebaseEventsDatabase();

  List<Category> categories = [];
  late Category selectedCategory;

  @override
  void initState() {
    super.initState();
    categories.add(
      Category(
        nameEn: "all",
        nameAr: "الكل",
        id: "",
        imageDark: "",
        imageLight: " ",
        icon: Icons.category,
      ),
    );

    categories.addAll(allCategories.values.toList());
    selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcomeBack,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? "",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              // Theme Toggle
              GestureDetector(
                onTap: () => provider.toggleTheme(),
                child: Icon(
                  provider.isDark ? Icons.dark_mode : Icons.light_mode,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Language Toggle
              GestureDetector(
                onTap: () => provider.toggleLanguage(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    provider.isEnglish ? "EN" : "ع",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(0, 80),
          child: buildCategoriesTabBar(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Event>>(
        stream: database.getEvents(selectedCategory.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${l10n.error}: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var events =
                snapshot.data?.docs
                    .map((document) => document.data())
                    .toList() ??
                [];

            if (events.isEmpty) {
              return Center(child: Text(l10n.noEvents));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return EventCard(event: events[index]);
              },
            );
          }
          return Center(child: Text(l10n.noEvents));
        },
      ),
    );
  }

  DefaultTabController buildCategoriesTabBar(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return DefaultTabController(
      length: categories.length,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        labelPadding: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        onTap: (value) {
          setState(() {
            selectedCategory = categories[value];
          });
        },
        tabs: categories
            .map(
              (category) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1,
                    color: category.id == selectedCategory.id
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary.withAlpha(20),
                  ),
                  color: category.id == selectedCategory.id
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSecondary,
                ),
                child: Row(
                  mainAxisSize: .min,
                  crossAxisAlignment: .center,
                  children: [
                    Icon(
                      category.icon,
                      color: category.id == selectedCategory.id
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    8.horizontalSpace,
                    Text(
                      provider.isEnglish ? category.nameEn : category.nameAr,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: category.id == selectedCategory.id
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
