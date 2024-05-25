import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes/Controller/ThemeController.dart';
import 'package:notes/Model/NoteModel.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  const NoteCard({super.key, required this.note, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    DateTime displayTime = note.updatedAt.isBefore(note.createdAt)
        ? note.updatedAt
        : note.createdAt;
    String formattedDate = DateFormat('h:mm a MMMM d, y').format(displayTime);

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Color(note.color),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 2,
                style: themeController.isDarkMode.value
                    ? Theme.of(context).textTheme.bodyLarge
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Text(
                  note.note,
                  maxLines: 4,
                  style: themeController.isDarkMode.value
                      ? Theme.of(context).textTheme.bodyMedium
                      : TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
              Row(
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
