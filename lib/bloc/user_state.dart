import 'package:equatable/equatable.dart';
import 'package:helios_test/model/user.dart';

enum UsersStatus { initial, success, failure }

class UsersState extends Equatable {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const <User>[],
    this.page = 0,
  });

  final UsersStatus status;
  final List<User> users;
  final int page;

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
    int? page,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [status, users, page];
}
