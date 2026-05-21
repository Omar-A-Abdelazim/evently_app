import 'package:evently_app/core/l10n/app_localizations.dart';
import 'package:evently_app/core/provider/app_config_provider.dart';
import 'package:evently_app/core/utils/date_extension.dart';
import 'package:evently_app/core/utils/dialog_utils.dart';
import 'package:evently_app/data/firebase/firebase_events_database.dart';
import 'package:evently_app/data/models/category.dart';
import 'package:evently_app/data/models/event.dart';
import 'package:evently_app/ui/widgets/custom_back_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  static const String routeName = "/editEventScreen";
  final Event event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  List<Category> categories = allCategories.values.toList();
  late Category selectedCategory;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    // prefill بالبيانات الموجودة
    selectedCategory =
        allCategories[widget.event.categoryId] ?? categories.first;
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(
      text: widget.event.description,
    );
    selectedDate = widget.event.date;
    selectedTime = TimeOfDay(
      hour: widget.event.time.hour,
      minute: widget.event.time.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1️⃣ إحاطة الـ Scaffold بـ GestureDetector
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 2️⃣ إغلاق الكيبورد
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Event"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.eventTitle,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.description,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.eventDescription,
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
                      AppLocalizations.of(context)!.eventDate,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) setState(() => selectedDate = date);
                      },
                      child: Text(
                        selectedDate == null
                            ? AppLocalizations.of(context)!.chooseDate
                            : selectedDate!.formatDate(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.primary,
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
                      AppLocalizations.of(context)!.eventTime,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        var time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime ?? TimeOfDay.now(),
                        );
                        if (time != null) setState(() => selectedTime = time);
                      },
                      child: Text(
                        selectedTime == null
                            ? AppLocalizations.of(context)!.chooseTime
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
                          decorationColor: Theme.of(
                            context,
                          ).colorScheme.primary,
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
                      _updateEvent();
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 0),
                  ),
                  child: Text("Edit Event"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateEvent() async {
    DialogUtils.showLoading(context);
    try {
      FirebaseEventsDatabase eventsDatabase = FirebaseEventsDatabase();
      await eventsDatabase.updateEvent(
        Event(
          widget.event.uid,
          widget.event.id,
          selectedCategory.id,
          titleController.text,
          descriptionController.text,
          selectedDate ?? DateTime.now(),
          DateTime(1, 1, 1, selectedTime!.hour, selectedTime!.minute),
          widget.event.favorites,
        ),
      );
      Navigator.pop(context); // dismiss loading
      Navigator.pop(context); // back to details
    } catch (e) {
      Navigator.pop(context);
      DialogUtils.buildDialog(
        context,
        title: AppLocalizations.of(context)!.error,
        content: e.toString(),
        negActionText: AppLocalizations.of(context)!.ok,
      );
    }
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
        onTap: (value) => setState(() => selectedCategory = categories[value]),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      color: category.id == selectedCategory.id
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 8),
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
      margin: EdgeInsets.symmetric(horizontal: 16),
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
}
