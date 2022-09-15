import 'package:ca_example/data/services/user_service.dart';
import 'package:ca_example/domain/users_bloc/users_bloc.dart';
import 'package:ca_example/view/user_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = GetIt.instance<UserService>();
    return BlocProvider(
      create: (context) => UsersBloc(
        userService: userService,
      )..add(const UsersEvent.start()),
      child: const UsersViewBody(),
    );
  }
}

class UsersViewBody extends StatelessWidget {
  const UsersViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Список пользователей'),
        ),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              received: (list) => Center(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: ((context, index) => InkWell(
                        onTap: () => Navigator.of(context).push<void>(
                          UserDetailView.route(user: list[index]),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1))),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Text(list[index].username),
                              Text(list[index].name),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
              failure: (e) => Center(child: Text(e)),
            );
          },
        ));
  }
}
