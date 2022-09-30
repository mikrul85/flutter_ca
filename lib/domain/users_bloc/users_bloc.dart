import 'package:ca_example/data/models/user/user_model.dart';
import 'package:ca_example/data/services/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_bloc.freezed.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserService userService;
  UsersBloc({required this.userService}) : super(const UsersState.initial()) {
    on<OpenUsersViewEvent>(_onOpenUsers);
    on<UpdateUsersViewEvent>(_onUpdateUsers);
  }

  Future<void> _onOpenUsers(
    OpenUsersViewEvent event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(const UsersState.loading());
      List<User> listUsers = await userService.getUsers();
      emit(UsersState.received(
          listUsers: listUsers, listValues: userService.openedUsers));
    } catch (e) {
      emit(
          const UsersState.failure(error: 'Произошла ошибка получения данных'));
    }
  }

  Future<void> _onUpdateUsers(
    UpdateUsersViewEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UsersState.loading());
    try {
      userService.updateOpenedUsers(event.userId);
      emit(UsersState.received(
          listUsers: userService.listUsers,
          listValues: userService.openedUsers));
    } catch (e) {
      emit(const UsersState.failure(
          error: 'Произошла ошибка обновления данных'));
    }
  }
}
