import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';

import 'package:transparent_image/transparent_image.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    Widget fallbackImage = const CircleAvatar(
      radius: 24,
      backgroundColor: Color.fromARGB(29, 158, 158, 158),
      child: Icon(Icons.person_outline_rounded,
          size: 30, color: Color.fromARGB(86, 102, 102, 102)),
    );

    if (user.imageUrl == null) {
      return fallbackImage;
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: 48,
          height: 48,
          placeholder: (context, url) => fallbackImage,
          errorWidget: (context, url, error) => fallbackImage,
          imageUrl: user.imageUrl!,
          fadeInCurve: Curves.easeIn,
        ));
  }
}
