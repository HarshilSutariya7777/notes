import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes/Model/NoteModel.dart';

import '../../Controller/ThemeController.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  // final CollectionReference mynotes =
  //     FirebaseFirestore.instance.collection('notes');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
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
                              // mynotes.doc(note.id).delete();
                              deleteNote();
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
              //show created and updated time
              if (note.createdAt != null || note.updatedAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      if (note.createdAt != null)
                        Text(
                          'Created: ${DateFormat.MMMd().add_jm().format(note.createdAt)}',
                          style: themeController.isDarkMode.value
                              ? Theme.of(context).textTheme.labelMedium
                              : TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                        ),
                      if (note.updatedAt != null)
                        Text(
                          'Updated: ${DateFormat.MMMd().add_jm().format(note.updatedAt)}',
                          style: themeController.isDarkMode.value
                              ? Theme.of(context).textTheme.labelMedium
                              : TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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

//when user save notes that time store notes in user collection accoding to user.
  void saveNotes() async {
    DateTime now = DateTime.now();
    String userid = auth.currentUser!.uid;

    if (note.id.isEmpty) {
      await users.doc(userid).collection('notes').add({
        'userId': userid,
        'title': titleString,
        'note': noteString,
        'color': color,
        'createdAt': now,
      });
    } else {
      await users.doc(userid).collection('notes').doc(note.id).update({
        'title': titleString,
        'note': noteString,
        'color': color,
        'createdAt': now,
      });
    }
  }

//delete notes
  void deleteNote() async {
    String userid = auth.currentUser!.uid;
    await users.doc(userid).collection('notes').doc(note.id).delete();
  }
}
