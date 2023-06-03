import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenotes/model/prompt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPromptsScreen extends StatefulWidget {
  const AddPromptsScreen({super.key});

  @override
  State<AddPromptsScreen> createState() => _AddPromptsScreenState();
}

class _AddPromptsScreenState extends State<AddPromptsScreen> {
  final TextEditingController _bodyController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    String body = _bodyController.text;
                    Prompt prompt = Prompt(
                        body: body,
                        title: user!.email!.length > 6
                            ? '@${user.email!.substring(0, 6)}'
                            : '@${user.email!.substring(0, (user.email!.length) % 2)}');
                    Navigator.pop(context, prompt);
                    setState(() {
                      Fluttertoast.showToast(
                          msg: "Your prompt has been posted",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.transparent,
                          textColor: Colors.white,
                          fontSize: 10.0);
                    });
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
                hintText: 'I want to...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              controller: _bodyController,
              autocorrect: true,
              cursorColor: Colors.white.withOpacity(0.2),
              maxLines: null,
              onTapOutside: (event) {
                setState(() {
                  _bodyController.clear();
                  Navigator.pop(context);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
