import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_test/bloc/user_repository.dart';
import 'package:http/http.dart';

import 'package:helios_test/bloc/user_bloc.dart';
import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/utils.dart';
import 'package:helios_test/view/users_list.dart';
import 'package:helios_test/widgets/page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: green,
        title: Text(
          "Utilisateurs",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: BlocProvider<UsersBloc>(
        create: (_) {
          final Client httpClient = Client();
          final repository = UsersAPIRepository(httpClient);

          return UsersBloc(repository)..add(UsersFetched());
        },
        child: Stack(
          children: const [
            Positioned(
              top: 0,
              bottom: 68,
              left: 0,
              right: 0,
              child: UsersList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: PageIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
