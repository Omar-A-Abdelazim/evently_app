import 'package:flutter/material.dart';

class Category {
  String nameEn;
  String nameAr;
  String id;
  String imageDark;
  String imageLight;
  IconData icon;

  Category({
    required this.nameEn,
    required this.nameAr,
    required this.id,
    required this.imageDark,
    required this.imageLight,
    required this.icon,
  });
}

List<Category> get allCategories => [
  Category(
    id: 'birthday',
    nameEn: 'Birthday',
    nameAr: 'عيد ميلاد',
    imageDark: 'assets/images/dark/Birthday.png',
    imageLight: 'assets/images/light/Birthday.png',
    icon: Icons.cake,
  ),
  Category(
    id: 'book_club',
    nameEn: 'Book Club',
    nameAr: 'نادي الكتاب',
    imageDark: 'assets/images/dark/Book Club.png',
    imageLight: 'assets/images/light/Book Club.png',
    icon: Icons.menu_book,
  ),
  Category(
    id: 'exhibition',
    nameEn: 'Exhibition',
    nameAr: 'معرض',
    imageDark: 'assets/images/dark/Exhibition.png',
    imageLight: 'assets/images/light/Exhibition.png',
    icon: Icons.art_track,
  ),
  Category(
    id: 'meeting',
    nameEn: 'Meeting',
    nameAr: 'اجتماع',
    imageDark: 'assets/images/dark/Meeting.png',
    imageLight: 'assets/images/light/Meeting.png',
    icon: Icons.meeting_room,
  ),
  Category(
    id: 'sport',
    nameEn: 'Sport',
    nameAr: 'رياضة',
    imageDark: 'assets/images/dark/Sport.png',
    imageLight: 'assets/images/light/Sport.png',
    icon: Icons.sports_soccer,
  ),
];
