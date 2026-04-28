import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ets/services/firestore.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() =>
      _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final titleTextController =
      TextEditingController();
  final contentTextController =
      TextEditingController();
  final labelTextController =
      TextEditingController();

  final FirestoreService firestoreService =
      FirestoreService();

  final Color primary = const Color(0xFF211C84);
  final Color accent = const Color(0xFF4D55CC);
  final Color secondary = const Color(0xFF7A73D1);
  final Color soft = const Color(0xFFB5A8D5);

  void openNoteBox({
    String? docId,
    String? existingTitle,
    String? existingNote,
    String? existingLabel,
  }) {
    if (docId != null) {
      titleTextController.text =
          existingTitle ?? '';
      contentTextController.text =
          existingNote ?? '';
      labelTextController.text =
          existingLabel ?? '';
    } else {
      titleTextController.clear();
      contentTextController.clear();
      labelTextController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            docId == null
                ? "Create Note"
                : "Edit Note",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:
                    titleTextController,
                decoration: InputDecoration(
                  labelText: "Title",
                  focusedBorder:
                      UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: accent),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller:
                    contentTextController,
                decoration: InputDecoration(
                  labelText: "Content",
                  focusedBorder:
                      UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: accent),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller:
                    labelTextController,
                decoration: InputDecoration(
                  labelText: "Label",
                  focusedBorder:
                      UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: accent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (docId == null) {
                  firestoreService.addNote(
                    titleTextController.text,
                    contentTextController.text,
                    labelTextController.text,
                  );
                } else {
                  firestoreService.updateNote(
                    docId,
                    titleTextController.text,
                    contentTextController.text,
                    labelTextController.text,
                  );
                }

                titleTextController.clear();
                contentTextController.clear();
                labelTextController.clear();

                Navigator.pop(context);
              },
              child: Text(
                docId == null
                    ? "Create"
                    : "Update",
                style: TextStyle(
                  color: accent,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8F7FC),

      appBar: AppBar(
        title: const Text("Notes"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: accent,
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream:
            firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notesList =
                snapshot.data!.docs;

            return ListView.builder(
              padding:
                  const EdgeInsets.all(12),
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                final document =
                    notesList[index];
                final docId =
                    document.id;

                final data = document
                        .data()
                    as Map<String,
                        dynamic>;

                final title =
                    data['title'] ??
                        '';
                final content =
                    data['content'] ??
                        '';
                final label =
                    data['label'] ??
                        '';

                return Card(
                  margin:
                      const EdgeInsets.only(
                          bottom: 12),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(16),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                            12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          title,
                          style:
                              TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight
                                    .bold,
                            color: primary,
                          ),
                        ),

                        const SizedBox(
                            height: 6),

                        Text(
                          content,
                          style:
                              TextStyle(
                            color: Colors
                                .grey[700],
                          ),
                        ),

                        const SizedBox(
                            height: 8),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                soft.withOpacity(
                                    0.4),
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        12),
                          ),
                          child: Text(
                            "#$label",
                            style:
                                TextStyle(
                              color:
                                  secondary,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight
                                      .w600,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 10),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color:
                                    accent,
                              ),
                              onPressed: () {
                                openNoteBox(
                                  docId:
                                      docId,
                                  existingTitle:
                                      title,
                                  existingNote:
                                      content,
                                  existingLabel:
                                      label,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color:
                                    Colors.red,
                              ),
                              onPressed: () {
                                firestoreService
                                    .deleteNote(
                                        docId);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child:
                CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}