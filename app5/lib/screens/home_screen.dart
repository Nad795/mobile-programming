import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../services/ai_services.dart';
import '../models/flashcard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Flashcard> _cards = [];
  bool _isLoading = false;

  void _createCards() async {
    setState(() => _isLoading = true);
    try {
      final cards = await AIService().generateFlashcards(_controller.text);
      setState(() => _cards = cards);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FlashAI Generator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Tempel materi kuliah di sini...", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _createCards,
              child: _isLoading ? CircularProgressIndicator() : Text("Generate Flashcards ✨"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cards.length,
                itemBuilder: (context, index) => _buildFlipCard(_cards[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipCard(Flashcard card) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FlipCard(
        front: Card(
          color: Colors.blueAccent,
          child: Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(card.question, style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center),
          ),
        ),
        back: Card(
          color: Colors.green,
          child: Container(
            height: 150,
            alignment: Alignment.center,
            child: Text(card.answer, style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}