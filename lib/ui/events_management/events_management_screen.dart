import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/date_extension.dart';
import 'package:evently_app/core/utils/dialog_utils.dart';
import 'package:evently_app/data/firebase/firebase_auth_service.dart';
import 'package:evently_app/data/firebase/firebase_events_database.dart';
import 'package:evently_app/data/models/category.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:evently_app/ui/widgets/custom_back_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsManagementScreen extends StatefulWidget {
  static const String routeName = "/eventsManagementScreen";
  const EventsManagementScreen({super.key});

  @override
  State<EventsManagementScreen> createState() => _EventsManagementScreenState();
}

class _EventsManagementScreenState extends State<EventsManagementScreen> {
  List<Category> categories = allCategories;
  late Category selectedCategory;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Event"),
        leading: CustomBackButton(),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            SizedBox(),
            eventImageCover(context),
            buildCategoriesTabBar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: .start,
                children: [
                  Text("Title", style: Theme.of(context).textTheme.titleSmall),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Event Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Event Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    Icons.date_range,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    "Event Date",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 100)),
                      );
                      print(date);
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text(
                      selectedDate == null
                          ? "Choose Date"
                          : selectedDate!.formatDate(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    "Event Time",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () async {
                      var time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      print(time);
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Text(
                      selectedTime == null
                          ? "Choose Time"
                          : DateFormat("hh:mm a").format(
                              DateTime(
                                1,
                                1,
                                1,
                                selectedTime!.hour,
                                selectedTime!.minute,
                              ),
                            ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilledButton(
                onPressed: () {
                  if (selectedDate != null &&
                      selectedTime != null &&
                      titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    _createEvent();
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 0),
                ),

                child: Text("Add Event"),
              ),
            ),
          ],
        ),
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

  Container eventImageCover(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Container(
      margin: .symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          provider.isDark
              ? selectedCategory.imageDark
              : selectedCategory.imageLight,
          width: double.infinity,
          fit: BoxFit.cover,
          height: 200,
        ),
      ),
    );
  }

  Future<void> _createEvent() async {
    DialogUtils.showLoading(context);
    try {
      FirebaseEventsDatabase eventsDatabase = FirebaseEventsDatabase();
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      await eventsDatabase.createEvent(
        Event(
          "",
          firebaseAuth.currentUser?.uid ?? "",
          selectedCategory.id,
          titleController.text,
          descriptionController.text,
          selectedDate ?? DateTime.now(),
          DateTime(1, 1, 1, selectedTime!.hour, selectedTime!.minute),
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      DialogUtils.buildDialog(
        context,
        title: "Error",
        content: "Failed to create event: $e",
        negActionText: "ok",
      );
    }
  }
}
