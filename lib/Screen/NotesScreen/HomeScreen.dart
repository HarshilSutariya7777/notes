import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Controller/AuthController.dart';
import 'package:notes/Controller/ThemeController.dart';
import 'package:notes/Model/NoteModel.dart';
import 'package:notes/Screen/NotesScreen/Note_Screen.dart';
import 'package:notes/Screen/NotesScreen/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference mynotes =
      FirebaseFirestore.instance.collection('notes');
  final ThemeController themeController = Get.find();
  AuthController authController = Get.put(AuthController());
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text(
          "Note APP",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeController.toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
          ),
          IconButton(
            onPressed: () {
              authController.logoutUser();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Get.to(NoteScreen(
            note: Note(
              id: '',
              title: '',
              note: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                hintStyle: themeController.isDarkMode.value
                    ? Theme.of(context).textTheme.labelMedium
                    : TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                setState(() {});
              },
              style: themeController.isDarkMode.value
                  ? Theme.of(context).textTheme.labelLarge
                  : TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: mynotes.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!.docs;
                List<NoteCard> noteCards = [];
                for (var note in notes) {
                  var data = note.data() as Map<String, dynamic>;
                  if (data != null) {
                    String title = data['title'] ?? "";
                    if (_searchController.text.isEmpty ||
                        title
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase())) {
                      Note noteObject = Note(
                        id: note.id,
                        title: data['title'] ?? "",
                        note: data['note'] ?? "",
                        createdAt: data.containsKey('createdAt')
                            ? (data['createdAt'] as Timestamp).toDate()
                            : DateTime.now(),
                        updatedAt: data.containsKey('updatedAt')
                            ? (data['updatedAt'] as Timestamp).toDate()
                            : DateTime.now(),
                        color: data.containsKey('color')
                            ? data['color']
                            : 0xFFFFFFFF,
                      );
                      noteCards.add(NoteCard(
                          note: noteObject,
                          onPressed: () {
                            Get.to(NoteScreen(note: noteObject));
                          }));
                    }
                  }
                }
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: noteCards.length,
                  itemBuilder: (context, index) {
                    return noteCards[index];
                  },
                  padding: EdgeInsets.all(3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
