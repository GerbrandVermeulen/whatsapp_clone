import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';
import 'package:whatsapp_clone/widgets/home/profile_icon.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<User> users = [];

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Add loaded users as they arrive
          final userData = snapshot.data!.docs;
          users.addAll(userData.map((user) => User.fromJson(user.data())));
        }

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select contact',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        // color: Colors.black,
                        )),
                Text('${users.length} contacts',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        // color: Colors.black,
                        )),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(2.0), // Height of the line
              child: Container(
                height: 1.0, // Height of the line
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.1), // Color of the line
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
                  user.username ?? '',
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
                  Navigator.of(context).pop(user);
                },
              );
            },
          ),
        );
      },
    );
  }
}
