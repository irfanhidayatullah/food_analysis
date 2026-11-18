import 'dart:convert';
import "dart:io";

import 'package:food_analysis_gemini/core/constants/api_key.dart';
import 'package:food_analysis_gemini/core/constants/prompt.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-3.8-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final response = await _model.generateContent([
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageFile.readAsBytesSync()),
      ]),
    ]);
    if (response.text == null) throw Exception('Gagal mendapatkan response');
    return jsonDecode(response.text!);
  }
}
