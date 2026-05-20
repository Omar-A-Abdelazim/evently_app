import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/theme/app_color.dart';
import 'package:evently_app/data/firebase/firebase_events_database.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:evently_app/ui/home/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/core/l10n/app_localizations.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final FirebaseEventsDatabase database = FirebaseEventsDatabase();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Event> _filterEvents(List<Event> events) {
    if (_searchQuery.isEmpty) return events;
    final query = _searchQuery.toLowerCase();
    return events
        .where(
          (e) =>
              e.title.toLowerCase().contains(query) ||
              e.description.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<AppConfigProvider>(context);
    final isDark = provider.isDark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: theme.textTheme.bodyMedium,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchForEvent,
                hintStyle: TextStyle(
                  color: isDark
                      ? AppColors.secTextDark
                      : AppColors.secTextLight,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: Icon(
                          Icons.close,
                          color: isDark
                              ? AppColors.disableDark
                              : AppColors.disable,
                          size: 20,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? AppColors.inputsDark
                    : AppColors.inputsLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark
                        ? AppColors.strokeDark
                        : AppColors.strokeLight,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.mainDark : AppColors.mainLight,
                    width: 1.8,
                  ),
                ),
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),

      body: StreamBuilder<QuerySnapshot<Event>>(
        stream: database.getFavoriteEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${AppLocalizations.of(context)!.error}: ${snapshot.error}",
              ),
            );
          } else if (snapshot.hasData) {
            final allEvents =
                snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

            final filteredEvents = _filterEvents(allEvents);

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: filteredEvents.isEmpty && _searchQuery.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: isDark
                                ? AppColors.disableDark
                                : AppColors.disable,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${AppLocalizations.of(context)!.noResultsFor} "$_searchQuery"',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : allEvents.isEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.noFavoriteEvents,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return EventCard(event: filteredEvents[index]);
                      },
                    ),
            );
          }
          return Center(
            child: Text(AppLocalizations.of(context)!.noFavoriteEvents),
          );
        },
      ),
    );
  }
}
