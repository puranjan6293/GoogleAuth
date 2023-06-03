import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenotes/model/prompt.dart';
import 'package:firenotes/screens/add/add_prompts_screen.dart';
import 'package:firenotes/screens/auth/login_screen.dart';
import 'package:firenotes/services/prompt_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'detail/prompt_editing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String admin = "mallik.puranjan@gmail.com";
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

  //! Clear all database
  void _clearDatabase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear Database"),
          content: const Text(
              "Are you sure you want to clear the database? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Clear"),
              onPressed: () {
                _promptService.clearDatabase().then((_) {
                  setState(() {
                    _prompts.clear();
                  });
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: "Database cleared successfully.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.white,
                    fontSize: 10.0,
                  );
                });
              },
            ),
          ],
        );
      },
    );
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
  void _editPromptPost(Prompt prompt) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PromptEditingScreen(prompt: prompt)),
    ).then((editedPrompt) {
      if (editedPrompt != null) {
        _promptService.updatePromptPost(editedPrompt).then((_) {
          setState(() {
            _prompts[_prompts.indexWhere((n) => n.id == prompt.id)] =
                editedPrompt;
          });
        });
      }
    });
  }

  //! vote function
  void _votePrompt(Prompt prompt) {
    setState(() {
      prompt.votes++;
    });
    // Update the votes in the database
    _promptService.updatePrompt(prompt);
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
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D2B),
        elevation: 0,
        title: Text(
          "Prompts",
          style: GoogleFonts.pacifico(
            color: Colors.white.withOpacity(0.9),
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0D0D2B),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0D0D2B),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CircleAvatar(
                      radius: 34,
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
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      user.email!.length > 6
                          ? '@${user.email!.substring(0, 6)}'
                          : '@${user.email!.substring(0, (user.email!.length) % 2)}',
                      style: GoogleFonts.poppins(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 17,
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
            //!admin
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                ),
                title: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  if (user.email == admin) {
                    _clearDatabase();
                  } else {
                    setState(() {
                      Fluttertoast.showToast(
                        msg: "You are not the admin.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.transparent,
                        textColor: Colors.white,
                        fontSize: 10.0,
                      );
                    });
                  }
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
                          style: GoogleFonts.poppins(
                            color: Colors.blue.withOpacity(0.9),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          children: [
                            Text(
                              prompts[index].votes > 100
                                  ? '100+'
                                  : prompts[index].votes.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            IconButton(
                              //!vote logic
                              onPressed: () {
                                if (prompts[index].votes <= 100) {
                                  _votePrompt(prompts[index]);
                                }
                                //!copy function
                                final String promptText = prompts[index].body;
                                Clipboard.setData(
                                    ClipboardData(text: promptText));
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
                              },
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    prompts[index].body,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 15,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    color: const Color(0xFF1C1C1E),
                    icon: const Icon(
                      Icons.more_vert,
                      // Icons.help,
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
                          value: 'edit',
                          child: Text(
                            'edit',
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
                      } else if (option == 'edit') {
                        if (user.email!.length > 6) {
                          if ('@${user.email!.substring(0, 6)}' ==
                              prompts[index].title) {
                            _editPromptPost(prompts[index]);
                          } else {
                            setState(() {
                              Fluttertoast.showToast(
                                msg: "You cannot edit another user's post",
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
