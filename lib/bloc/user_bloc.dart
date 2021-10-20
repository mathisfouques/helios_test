import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helios_test/bloc/user_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:helios_test/bloc/user_event.dart';
import 'package:helios_test/bloc/user_state.dart';

const usersLimit = 20;
const _throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(this.repository) : super(const UsersState()) {
    on<UsersFetched>(_onUsersFetched,
        transformer: throttleDroppable(_throttleDuration));

    on<PageChanged>(_onPageChanged,
        transformer: throttleDroppable(_throttleDuration));

    on<NextPage>(_onNextPage,
        transformer: throttleDroppable(_throttleDuration));
  }

  final UsersRepository repository;

  Future<void> _onPageChanged(
      PageChanged event, Emitter<UsersState> emit) async {
    try {
      final int maxPage =
          (state.users.length + 1) ~/ repository.getLimitUsersFetched;
      if (event.page > maxPage) return;

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
      final int maxPage =
          (state.users.length + 1) ~/ repository.getLimitUsersFetched;
      if (state.page + 1 > maxPage) return;
      emit(state.copyWith(
        status: UsersStatus.success,
        users: state.users,
        page: state.page + 1,
      ));
    } catch (_) {
      emit(state.copyWith(status: UsersStatus.failure));
    }
  }

  Future<void> _onUsersFetched(
      UsersFetched event, Emitter<UsersState> emit) async {
    try {
      final int maxPage =
          (state.users.length - 1) ~/ repository.getLimitUsersFetched;

      if (state.page + 1 == maxPage) return;

      if (state.status == UsersStatus.initial) {
        final users = await repository.fetchUsers();
        return emit(state.copyWith(
          status: UsersStatus.success,
          users: users,
          page: 0,
        ));
      }
      final users = await repository.fetchUsers();

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
}
