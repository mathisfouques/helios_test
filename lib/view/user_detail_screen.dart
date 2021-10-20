import 'package:flutter/material.dart';
import 'package:helios_test/model/user.dart';
import 'package:helios_test/utils.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: green,
        title: Text(
          "Détails",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      backgroundColor: green,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(user.picture.large),
              ),
              const SizedBox(height: 32),
              Text(
                "${user.name.first} ${user.name.last}",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "${user.location.city}, ${user.location.state}",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                user.phone,
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
