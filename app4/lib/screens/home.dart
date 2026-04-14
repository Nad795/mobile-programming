import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app4/firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleTextController = TextEditingController();
  final contentTextController = TextEditingController();
  final labelController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  void openNoteBox({String? docId, String? existingTitle, String? existingNote, String? existingLabel}) async {
    // Set controller jika sedang edit
    if (docId != null) {
      titleTextController.text = existingTitle ?? '';
      contentTextController.text = existingNote ?? '';
      labelController.text = existingLabel ?? '';
    } else {
      // Kosongkan jika buat baru
      titleTextController.clear();
      contentTextController.clear();
      labelController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docId == null ? "Create new Note" : "Edit Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: titleTextController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: "Content"),
                controller: contentTextController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Label"),
                controller: labelController,
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                if (docId == null) {
                  firestoreService.addNote(
                    titleTextController.text,
                    contentTextController.text,
                    labelController.text,
                  );
                } else {
                  firestoreService.updateNote(
                    docId,
                    titleTextController.text,
                    contentTextController.text,
                    labelController.text,
                  );
                }
                
                titleTextController.clear();
                contentTextController.clear();
                labelController.clear();

                Navigator.pop(context);
              },
              child: Text(docId == null ? "Create" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Grid"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            // --- GANTI KE GRIDVIEW DI SINI ---
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Menampilkan 2 kolom
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85, // Mengatur rasio kotak (lebar/tinggi)
              ),
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteTitle = data['title'] ?? 'No Title';
                String noteContent = data['content'] ?? '';
                String noteLabel = data['label'] ?? 'General';

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noteTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Text(
                            noteContent,
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "#$noteLabel",
                          style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => openNoteBox(
                                docId: docId, 
                                existingNote: noteContent, 
                                existingTitle: noteTitle,
                                existingLabel: noteLabel,
                              ),
                              child: const Icon(Icons.edit, size: 20, color: Colors.orange),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () => firestoreService.deleteNote(docId),
                              child: const Icon(Icons.delete, size: 20, color: Colors.red),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}