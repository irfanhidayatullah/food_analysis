import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_analysis_gemini/presentation/loading_screen.dart';
import 'package:food_analysis_gemini/presentation/result_screen.dart';
import 'package:food_analysis_gemini/services/gemini_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? imageFile;
  final GeminiService _geminiService = GeminiService();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt_rounded),
              title: Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_rounded),
              title: Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analysisImage() async {
    if (imageFile == null) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Gambar belum ada"),
          content: Text(
            "Tambahkan gambar terlebih dahulu sebelum melakukan analisis",
          ),
        ),
      );
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoadingScreen()));

    try {
      final data = await _geminiService.analyzeImage(File(imageFile!.path));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResultScreen(data: data, imageFile: File(imageFile!.path)),
        ),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Terjadi kesalahan!"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _deleteImage() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_instructionText(), _imageArea(), _buttonSubmit()],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent,
      title: Text(
        "Food Nutrition\nComposition Analysis",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
    );
  }

  Widget _instructionText() {
    return Text(
      "Unggah gambar makanan atau minuman\nyang ingin kamu ketahui\ndan kehalalannya",
      textAlign: TextAlign.center,
    );
  }

  Widget _imageArea() {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrangeAccent,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageFile != null)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Image.file(
                    File(imageFile!.path),
                    width: 300,
                    height: 175,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: _deleteImage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: _showPickerOptions,
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.deepOrangeAccent,
                size: 100,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      onPressed: _analysisImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        fixedSize: Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Text(
            "Analisis Gambar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.rocket_launch_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
