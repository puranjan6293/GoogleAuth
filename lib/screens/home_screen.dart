import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenotes/model/prompt.dart';
import 'package:firenotes/screens/add/add_prompts_screen.dart';
import 'package:firenotes/screens/auth/login_screen.dart';
import 'package:firenotes/services/prompt_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

import 'detail/prompt_editing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //all database related
  List<Prompt> _prompts = [];
  final PromptService _promptService = PromptService();

  @override
  void initState() {
    super.initState();
    _promptService.getPromptsStream().listen((prompts) {
      setState(() {
        _prompts = prompts;
      });
    });
  }

  //add Prompts
  void _addPrompt() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPromptsScreen()),
    ).then((prompt) {
      if (prompt != null) {
        _promptService.addPrompts(prompt).then((id) {
          prompt.id = id;
          setState(() {
            _prompts.add(prompt);
          });
        });
      }
    });
  }

  // edit or update
  void _editPrompt(Prompt prompt) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PromptEditingScreen(prompt: prompt)),
    ).then((editedPrompt) {
      if (editedPrompt != null) {
        _promptService.updatePrompt(editedPrompt).then((_) {
          setState(() {
            _prompts[_prompts.indexWhere((n) => n.id == prompt.id)] =
                editedPrompt;
          });
        });
      }
    });
  }

  //delete prompt
  void _deletePromptByUser(String id) {
    _promptService.deletePromptById(id).then((_) {
      setState(() {
        _prompts.removeWhere((prompt) => prompt.id == id);
      });
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return Scaffold(
      // backgroundColor: const Color(0xFF1C1C1E),
      backgroundColor: const Color(0xFF0C0C14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0C14),
        elevation: 0,
        title: const Row(
          children: [
            Text("Prompts"),
            SizedBox(
              width: 5,
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/profile_image.png'),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 18, 18, 52),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 18, 18, 52),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.blue,
                    child: Text(
                      user!.email!.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Set the desired background color for the avatar
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      user.email!.length > 6
                          ? '@${user.email!.substring(0, 6)}'
                          : '@${user.email!.substring(0, (user.email!.length) % 2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      user.email!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Prompt>>(
        stream: _promptService.getPromptsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Prompt> prompts = snapshot.data!;
            return ListView.builder(
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      prompts[index].title.substring(1, 2).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Set the desired background color for the avatar
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          prompts[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            const Text(
                              '0',
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  subtitle: Text(
                    prompts[index].body,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                  // onTap: () {
                  //   _editPrompt(prompts[index]);
                  // },
                  trailing: PopupMenuButton<String>(
                    color: const Color(0xFF1C1C1E),
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 18,
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'copy',
                          child: Text(
                            'Copy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ];
                    },
                    onSelected: (String option) {
                      if (option == 'delete') {
                        if (user.email!.length > 6) {
                          if ('@${user.email!.substring(0, 6)}' ==
                              prompts[index].title) {
                            _deletePromptByUser(_prompts[index].id);
                          } else {
                            setState(() {
                              Fluttertoast.showToast(
                                msg: "You cannot delete another user's post",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.transparent,
                                // textColor: const Color(0xFF1C1C1E),
                                textColor: Colors.white,
                                fontSize: 10.0,
                              );
                            });
                          }
                        }
                      } else if (option == 'copy') {
                        final String promptText = prompts[index].body;
                        Clipboard.setData(ClipboardData(text: promptText));
                        Fluttertoast.showToast(
                          msg: "Prompt copied to clipboard",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.transparent,
                          // textColor: const Color(0xFF1C1C1E),
                          textColor: Colors.white,
                          fontSize: 10.0,
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPrompt,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
