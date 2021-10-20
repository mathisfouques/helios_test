import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_test/bloc/user_bloc.dart';
import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/bloc/user_state.dart';
import 'package:helios_test/utils.dart';
import 'package:helios_test/widgets/user_card.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final ScrollController _controller = ScrollController();
  final int _extentBeforeFetch = 200;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_controller.position.extentBefore < _extentBeforeFetch) {
      context.read<UsersBloc>().add(UsersFetched());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        switch (state.status) {
          case UsersStatus.failure:
            return SingleChildScrollView(
              controller: _controller,
              child: const Center(child: Text('Failed to fetch users')),
            );
          case UsersStatus.initial:
            return SingleChildScrollView(
              controller: _controller,
              child: const Center(child: Text('initial')),
            );
          case UsersStatus.success:
            if (state.users.isEmpty) {
              return SingleChildScrollView(
                  controller: _controller,
                  child: const Center(child: Text('Empty list')));
            }

            SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
              final int maxPage = (state.users.length - 1) ~/ usersLimit;
              if (_controller.offset != 0 && state.page != maxPage) {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            });

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: RefreshIndicator(
                color: green,
                backgroundColor: lightBlue,
                onRefresh: () {
                  return Future.delayed(
                    const Duration(milliseconds: 100),
                    () {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                      context.read<UsersBloc>().add(NextPage());
                    },
                  );
                },
                child: ListView.builder(
                  itemCount: usersLimit,
                  controller: _controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    int currentIndex = state.page * usersLimit + index;

                    return UserCard(user: state.users[currentIndex]);
                  },
                ),
              ),
            );
        }
      },
    );
  }
}
