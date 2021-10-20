// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:helios_test/utils.dart';
import 'package:helios_test/model/user.dart';
import 'package:helios_test/view/user_detail_screen.dart';

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
      child: Ink(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: lightGreenHalfOpacity,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: green,
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          splashColor: lightGreen,
          hoverColor: lightGreen,
          focusColor: lightGreenHalfOpacity,
          highlightColor: lightGreenHalfOpacity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.name.first} ${user.name.last}",
                  style: textTheme.headline1,
                ),
                const SizedBox(height: 8),
                Text(
                  "Phone : ${user.phone}",
                  style: textTheme.headline2,
                ),
                const SizedBox(height: 4),
                Text(
                  "Email : ${user.email}",
                  style: textTheme.headline2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
