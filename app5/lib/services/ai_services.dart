import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/flashcard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<List<Flashcard>> generateFlashcards(String inputText) async {
    final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: _apiKey);
    
    // Prompt diperkuat untuk memaksa format JSON murni
    final prompt = """
    Create 5 study flashcards from the text below. 
    Return ONLY a raw JSON array of objects with "q" and "a" keys.
    Format example: [{"q": "Question here", "a": "Answer here"}]
    No markdown, no backticks, no explanations.
    
    Text: $inputText
    """;

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      String rawText = response.text ?? '';
      print("RAW RESPONSE: $rawText"); // Untuk cek di debug console

      String cleanJson = "";

      // 1. Coba cari teks di dalam block markdown ```json ... ```
      if (rawText.contains('```')) {
        final regExp = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
        final match = regExp.firstMatch(rawText);
        if (match != null) {
          cleanJson = match.group(1)!.trim();
        }
      } 
      
      // 2. Jika langkah 1 gagal atau tidak ada markdown, cari berdasarkan kurung siku [ ]
      if (cleanJson.isEmpty) {
        int startIndex = rawText.indexOf('[');
        int endIndex = rawText.lastIndexOf(']');
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          cleanJson = rawText.substring(startIndex, endIndex + 1);
        } else {
          cleanJson = rawText.trim();
        }
      }

      // 3. Decode JSON
      final List<dynamic> jsonData = jsonDecode(cleanJson);
      return jsonData.map((data) => Flashcard.fromJson(data)).toList();

    } catch (e) {
      print("Error detail: $e");
      // Memberikan pesan error yang lebih informatif untuk debugging
      throw "Gagal memproses data AI: ${e.toString().split('\n').first}";
    }
  }
}