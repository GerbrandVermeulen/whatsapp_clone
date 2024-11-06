import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/screens/home/new_chat/new_chat.dart';
import 'package:whatsapp_clone/widgets/home/chat_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedPageIndex = 0;

  void _deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;

    final conversations = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: user!.uid)
        .get();
    // Delete all conversations with this user
    WriteBatch conversationBatch = FirebaseFirestore.instance.batch();
    for (var conversation in conversations.docs) {
      // Delete all messages for this conversation
      WriteBatch messageBatch = FirebaseFirestore.instance.batch();
      final messages = await FirebaseFirestore.instance
          .collection('messages')
          .where('conversation_id', isEqualTo: conversation.id)
          .get();
      for (var message in messages.docs) {
        messageBatch.delete(message.reference);
      }
      await messageBatch.commit();

      conversationBatch.delete(conversation.reference);
    }
    await conversationBatch.commit();

    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    // TODO User needs to be re-authenticated to delete from FirebaseAuth
    // await user.reauthenticateWithCredential(credential);
    await user.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WhatsUpp',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          PopupMenuButton(
            offset: const Offset(0, 54),
            color: Colors.white,
            onSelected: (value) {
              if (value == 5) {
                _deleteUser();
              }
              if (value == 6) {
                FirebaseAuth.instance.signOut();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('New group'),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text('New broadcast'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Linked devices'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('Starred messages'),
              ),
              const PopupMenuItem(
                value: 4,
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 5,
                child: Text('*Delete user (debug)'),
              ),
              const PopupMenuItem(
                value: 6,
                child: Text('*Sign out (debug)'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: const ChatList(),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'add_chat',
            elevation: 3,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const NewChatScreen(),
              ));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.chat_bubble,
                  color: Theme.of(context).colorScheme.surface,
                ),
                Positioned(
                  bottom: 4.5,
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton.small(
            heroTag: 'mate',
            elevation: 3,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            onPressed: () {},
            child: Image.asset(
              'assets/images/meta-ai.png',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _selectedPageIndex = value /* value */;
          });
        },
        currentIndex: _selectedPageIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        items: const [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: 'Updates',
            icon: Icon(Icons.slow_motion_video_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Communities',
            icon: Icon(Icons.people_outline_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Calls',
            icon: Icon(Icons.call_outlined),
          ),
        ],
      ),
    );
  }
}
