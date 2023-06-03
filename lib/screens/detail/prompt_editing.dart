import 'package:firenotes/model/prompt.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF0C0C14),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0C0C14),
        title: const Text(
          'Edit',
        ),
        actions: [
          TextButton(
              onPressed: () {
                Prompt prompt = widget.prompt;
                prompt.body = _bodyController.text;
                Navigator.pop(context, prompt);
              },
              child: const Text(
                "save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _titleController.text.toString(),
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _bodyController,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
                autocorrect: true,
                cursorColor: Colors.white.withOpacity(0.2),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
