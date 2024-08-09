import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/message.dart';
import 'package:chat_app/splash.dart';
import 'package:chat_app/themeNotifier.dart';
import 'package:chat_app/themes.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  await Hive.openBox<Message>('messages');


  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
