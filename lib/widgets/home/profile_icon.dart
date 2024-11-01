import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
    required this.user,
    required this.radius,
  });

  final User user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Widget fallbackImage = CircleAvatar(
      radius: radius,
      backgroundColor: const Color.fromARGB(29, 158, 158, 158),
      child: const Icon(Icons.person_outline_rounded,
          size: 30, color: Color.fromARGB(86, 102, 102, 102)),
    );

    if (user.imageUrl == null) {
      return fallbackImage;
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          placeholder: (context, url) => fallbackImage,
          errorWidget: (context, url, error) => fallbackImage,
          imageUrl: user.imageUrl!,
          fadeInCurve: Curves.easeIn,
        ));
  }
}
