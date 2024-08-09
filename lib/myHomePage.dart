import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/message.dart';
import 'package:chat_app/themeNotifier.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late Box<Message> messageBox;
  bool _isLoading = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    messageBox = Hive.box<Message>('messages');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> callGeminiModel() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      messageBox.add(Message(
          text: _controller.text, isUser: true, imageUrl: _imageFile?.path));
      messageBox.add(Message(text: '...', isUser: false));
    });

    try {
      final model = GenerativeModel(
          model: 'gemini-pro', apiKey: dotenv.env['GOOGLE_API_KEY']!);
      final prompt = _controller.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        messageBox
            .deleteAt(messageBox.length - 1); // Remove the loading message
        messageBox.add(Message(
            text: response.text!, isUser: false, imageUrl: _imageFile?.path));
        _isLoading = false;
      });

      _controller.clear();
      _imageFile = null;
    } catch (e) {
      print("Error : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDelete(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        messageBox.deleteAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/gpt-robot.png',
                  scale: 8,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Ai Chat app',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              ],
            ),
            // GestureDetector(
            //   child: (currentTheme == ThemeMode.dark)
            //       ? Icon(
            //           Icons.light_mode,
            //           color: Theme.of(context).colorScheme.secondary,
            //         )
            //       : Icon(
            //           Icons.dark_mode,
            //           color: Theme.of(context).colorScheme.primary,
            //         ),
            //   onTap: () {
            //     ref.read(themeProvider.notifier).toggleTheme();
            //   },
            // )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Hive.box<Message>('messages').listenable(),
                builder: (context, Box<Message> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }

                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        final message = box.getAt(index)!;
                        return ListTile(
                          title: Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: message.isUser
                                      ? Theme.of(context).colorScheme.primary
                                      : currentTheme == ThemeMode.dark
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                  borderRadius: message.isUser
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20))
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: message.isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(message.text,
                                      style: message.isUser
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                          : Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                  if (message.imageUrl != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child:
                                          Image.file(File(message.imageUrl!)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          onLongPress: () => _confirmDelete(index),
                        );
                      });
                }),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 16.0, left: 16.0, right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: callGeminiModel,
                            child: Image.asset('assets/send.png'),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
