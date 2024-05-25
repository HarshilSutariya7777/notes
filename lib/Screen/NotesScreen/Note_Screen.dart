import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Model/NoteModel.dart';

import '../../Controller/ThemeController.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final CollectionReference mynotes =
      FirebaseFirestore.instance.collection('notes');
  TextEditingController title = TextEditingController();
  TextEditingController Content = TextEditingController();
  late Note note;
  String titleString = '';
  String noteString = '';
  late int color;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    note = widget.note;
    titleString = note.title;
    noteString = note.note;
    color = note.color == 0xFFFFFFFF ? gernerateRandomLightColor() : note.color;
    title = TextEditingController(text: titleString);
    Content = TextEditingController(text: noteString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    note.id.isEmpty ? 'Add note' : 'Edit note',
                    style: themeController.isDarkMode.value
                        ? Theme.of(context).textTheme.labelLarge
                        : TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            saveNotes();
                            Get.back();
                          },
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 2),
                        if (note.id.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              mynotes.doc(note.id).delete();
                              Get.back();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
              TextField(
                controller: title,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Note Title",
                  hintStyle: themeController.isDarkMode.value
                      ? Theme.of(context).textTheme.labelMedium
                      : TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                ),
                onChanged: (value) {
                  titleString = value;
                },
                style: themeController.isDarkMode.value
                    ? Theme.of(context).textTheme.labelLarge
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
              ),
              Expanded(
                child: TextField(
                  controller: Content,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Note Content",
                    hintStyle: themeController.isDarkMode.value
                        ? Theme.of(context).textTheme.labelMedium
                        : TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                  ),
                  onChanged: (value) {
                    noteString = value;
                  },
                  style: themeController.isDarkMode.value
                      ? Theme.of(context).textTheme.labelMedium
                      : TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveNotes() async {
    DateTime now = DateTime.now();
    String userid = auth.currentUser!.uid;

    if (note.id.isEmpty) {
      await mynotes.add({
        'userId': userid,
        'title': titleString,
        'note': noteString,
        'color': color,
        'createdAt': now,
      });
    } else {
      await mynotes.doc(note.id).update({
        'title': titleString,
        'note': noteString,
        'color': color,
        'updatedAt': now,
      });
    }
  }
}
