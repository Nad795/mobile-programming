import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/flashcard.dart';

class AIService {
  static const _apiKey = 'AIzaSyCRQAo03HDn724hBcPN6jNfJsGKdqeMqkI';

  Future<List<Flashcard>> generateFlashcards(String inputText) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    
    final prompt = """
    Buatlah 5 flashcard belajar dari teks di bawah ini.
    Berikan output HANYA dalam format JSON array: [{"q": "pertanyaan", "a": "jawaban"}]
    Teks: $inputText
    """;

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    
    // Parsing String JSON ke List of Flashcard
    final List<dynamic> jsonData = jsonDecode(response.text!);
    return jsonData.map((data) => Flashcard.fromJson(data)).toList();
  }
  
}