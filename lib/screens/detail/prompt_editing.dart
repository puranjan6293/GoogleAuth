import 'package:firenotes/model/prompt.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromptEditingScreen extends StatefulWidget {
  final Prompt prompt;

  const PromptEditingScreen({super.key, required this.prompt});

  @override
  _PromptEditingScreen createState() => _PromptEditingScreen();
}

class _PromptEditingScreen extends State<PromptEditingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.prompt.title;
    _bodyController.text = widget.prompt.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Prompt',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: GoogleFonts.lato(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  hintText: 'Contact Number',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Prompt prompt = widget.prompt;
                  prompt.title = _titleController.text;
                  prompt.body = _bodyController.text;
                  Navigator.pop(context, prompt);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
