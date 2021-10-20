import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersFetched extends UsersEvent {}

class NextPage extends UsersEvent {}

class PageChanged extends UsersEvent {
  PageChanged(this.page);

  final int page;
}
