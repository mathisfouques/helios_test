// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helios_test/bloc/user_bloc.dart';
import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/bloc/user_state.dart';

import 'mock_users_bloc.dart';

void main() {
  // TEST BLoC
  group("Bloc", () {
    final repository = MockUsersRepository();
    final sut = UsersBloc(repository);

    blocTest(
      "UsersBloc have 20 users after UsersFetched has been fired.",
      build: () {
        sut.emit(const UsersState(
          page: 0,
          users: [],
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(UsersFetched()),
      wait: const Duration(milliseconds: 51),
      expect: () => [
        UsersState(
          page: 0,
          users: repository.mockUsers,
          status: UsersStatus.success,
        )
      ],
    );

    blocTest(
      "UsersBloc go to next page When enough users are fetched And NextPage has been fired.",
      build: () {
        sut.emit(UsersState(
          page: 0,
          users: repository.mockUsers,
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(NextPage()),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        UsersState(
          page: 1,
          users: repository.mockUsers,
          status: UsersStatus.success,
        )
      ],
    );

    blocTest(
      "UsersBloc stays on the same page When not enough users are fetched And NextPage has been fired.",
      build: () {
        sut.emit(const UsersState(
          page: 0,
          users: [],
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(NextPage()),
      expect: () => [],
    );

    blocTest(
      "UsersBloc does not emit when enough users are already fetched and UsersFetched is fired. ",
      build: () {
        sut.emit(UsersState(
          page: 0,
          users: repository.mockUsers,
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(UsersFetched()),
      wait: const Duration(milliseconds: 51),
      expect: () => [],
    );

    blocTest(
      "UsersBloc does emit failure state when not enough users are fetched and PageChanged is fired with a page number too high.",
      build: () {
        sut.emit(UsersState(
          page: 0,
          users: repository.mockUsers,
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(PageChanged(2)),
      expect: () => [],
    );

    blocTest(
      "UsersBloc change page when enough users are already fetched and PageChanged is fired.",
      build: () {
        sut.emit(UsersState(
          page: 0,
          users: repository.mockUsers,
          status: UsersStatus.success,
        ));

        return sut;
      },
      act: (UsersBloc bloc) => bloc.add(PageChanged(1)),
      wait: const Duration(milliseconds: 50),
      expect: () => [
        UsersState(
          page: 1,
          users: repository.mockUsers,
          status: UsersStatus.success,
        )
      ],
    );
  });
}
