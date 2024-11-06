import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/providers/contact_provider.dart';
import 'package:whatsapp_clone/screens/chat/chat.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

class NewChatScreen extends ConsumerWidget {
  const NewChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactStream = ref.watch(contactProvider);

    return contactStream.when(
      data: (users) {
        return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select contact',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text('${users.length} contacts',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2.0),
                child: Container(
                  height: 1.0,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text('Contacts on WhatsUpp',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.85),
                            )),
                  );
                }

                final user = users[index - 1];
                return ListTile(
                  leading: ProfileIcon(
                    user: user,
                    radius: 20,
                  ),
                  title: Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text(
                    user.about ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        user: user,
                      ),
                    ));
                  },
                );
              },
            ));
      },
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    );
  }
}
