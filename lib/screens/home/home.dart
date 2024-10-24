import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/model/dummy_data.dart';
import 'package:whatsapp_clone/widgets/home/chat_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedPageIndex = 0;

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
            onSelected: (value) {},
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
            ],
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ChatList(
        chats: dummy_chats,
      ),
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            elevation: 3,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {},
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
            _selectedPageIndex = 0 /* value */;
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
            icon: Icon(Icons.call),
          ),
        ],
      ),
    );
  }
}
