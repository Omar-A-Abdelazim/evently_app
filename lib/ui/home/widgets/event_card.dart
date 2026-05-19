import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/data/firebase/firebase_events_database.dart';
import 'package:evently_app/data/models/category.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  final Event event;
  late Category category;
  FirebaseEventsDatabase database = FirebaseEventsDatabase();
  EventCard({super.key, required this.event}) {
    category = allCategories[event.categoryId]!;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var provider = Provider.of<AppConfigProvider>(context);
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(
              provider.isDark ? category.imageDark : category.imageLight,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  DateFormat("dd MMM").format(event.date),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        database.updateEventFavoriteState(
                          event,
                          event.favorites.contains(
                            FirebaseAuth.instance.currentUser?.uid,
                          ),
                        );
                      },
                      child: Icon(
                        event.favorites.contains(
                              FirebaseAuth.instance.currentUser?.uid,
                            )
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
