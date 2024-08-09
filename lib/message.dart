// class Message {
//   final String text;
//   final bool isUser;

//   Message({required this.text, required this.isUser});
// // }

import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isUser;

  @HiveField(2)
  String? imageUrl;

  Message({required this.text, required this.isUser, this.imageUrl});
}
