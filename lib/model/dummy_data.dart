import 'package:whatsapp_clone/model/chat.dart';

final dummy_chats = [
  // Chat(
  //   name: 'Elias',
  //   number: '0718894672',
  //   imageUrl: 'assets/images/user-icon.jpg',
  //   unreadCount: 0,
  //   messages: [
  //     Message(
  //         text: 'Please remember to drink water!',
  //         status: Status.received,
  //         dateTime: DateTime.parse('2024-10-24 17:42:00')),
  //     Message(
  //         text: 'This is also a test message!',
  //         status: Status.received,
  //         dateTime: DateTime.parse('2024-10-24 17:43:00')),
  //     Message(
  //         text: 'Indeed, this is another test message!',
  //         status: Status.received,
  //         dateTime: DateTime.parse('2024-10-24 17:44:00')),
  //   ],
  // ),
  Chat(
    name: 'Ma',
    number: '0825313404',
    imageUrl: 'assets/images/user-icon.jpg',
    unreadCount: 1,
    messages: [
      Message(
          text: 'Hi daar! 👋',
          status: Status.received,
          dateTime: DateTime.parse('2024-10-24 16:07:00')),
      Message(
          text: 'This is also a test message!',
          status: Status.received,
          dateTime: DateTime.parse('2024-10-24 16:08:00')),
      Message(
          text: 'Indeed, this is another test message!',
          status: Status.received,
          dateTime: DateTime.parse('2024-10-24 16:09:00')),
    ],
  ),
  Chat(
    name: 'Pa',
    number: '0828530219',
    imageUrl: 'assets/images/user-icon.jpg',
    unreadCount: 0,
    messages: [
      Message(
          text: 'Kyk na hierdie artikel wat ek gevind het:',
          status: Status.delivered,
          dateTime: DateTime.parse('2024-10-24 10:32:00')),
      Message(
          text: 'This is also a test message!',
          status: Status.delivered,
          dateTime: DateTime.parse('2024-10-24 10:33:00')),
      Message(
          text: 'Indeed, this is another test message!',
          status: Status.delivered,
          dateTime: DateTime.parse('2024-10-24 10:34:00')),
    ],
  ),
  Chat(
    name: 'Alma',
    number: '0761643804',
    imageUrl: 'assets/images/user-icon.jpg',
    unreadCount: 0,
    messages: [
      Message(
          text: 'Omw hierdie movie lyk epic! 🎉',
          status: Status.read,
          dateTime: DateTime.parse('2024-10-24 09:14:00')),
      Message(
          text: 'This is also a test message!',
          status: Status.read,
          dateTime: DateTime.parse('2024-10-24 09:15:00')),
      Message(
          text: 'Indeed, this is another test message!',
          status: Status.read,
          dateTime: DateTime.parse('2024-10-24 09:16:00')),
    ],
  ),
];
