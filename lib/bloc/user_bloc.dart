import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:http/http.dart';

import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/bloc/user_state.dart';
import 'package:helios_test/model/user.dart';

const usersLimit = 20;
const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({required this.httpClient}) : super(const UsersState()) {
    on<UsersFetched>(_onUsersFetched,
        transformer: throttleDroppable(_throttleDuration));

    on<PageChanged>(_onPageChanged,
        transformer: throttleDroppable(_throttleDuration));

    on<NextPage>(_onNextPage,
        transformer: throttleDroppable(_throttleDuration));
  }

  final Client httpClient;

  Future<void> _onPageChanged(
      PageChanged event, Emitter<UsersState> emit) async {
    try {
      final int maxPage = (state.users.length - 1) ~/ usersLimit;
      if (event.page > maxPage) throw Exception;

      emit(state.copyWith(
        status: UsersStatus.success,
        users: state.users,
        page: event.page,
      ));
    } catch (_) {
      emit(state.copyWith(status: UsersStatus.failure));
    }
  }

  Future<void> _onNextPage(NextPage event, Emitter<UsersState> emit) async {
    try {
      final int maxPage = (state.users.length - 1) ~/ usersLimit;
      if (state.page < maxPage) {
        emit(state.copyWith(
          status: UsersStatus.success,
          users: state.users,
          page: state.page + 1,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: UsersStatus.failure));
    }
  }

  Future<void> _onUsersFetched(
      UsersFetched event, Emitter<UsersState> emit) async {
    try {
      final int maxPage = (state.users.length - 1) ~/ usersLimit;

      if (state.page + 1 == maxPage) return;

      if (state.status == UsersStatus.initial) {
        final users = await _fetchUsers();
        return emit(state.copyWith(
          status: UsersStatus.success,
          users: users,
          page: 0,
        ));
      }
      final users = await _fetchUsers();

      emit(
        state.copyWith(
          status: UsersStatus.success,
          users: List.of(state.users)..addAll(users),
          page: state.page,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: UsersStatus.failure));
    }
  }

  Future<List<User>> _fetchUsers() async {
    final request = await httpClient
        .get(Uri.parse("https://randomuser.me/api/?results=$usersLimit"));

    if (request.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(request.body);
      final List<dynamic> results = response['results'];

      return results.map<User>((result) => User.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
