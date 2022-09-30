import 'package:ca_example/domain/users_bloc/users_bloc.dart';
import 'package:ca_example/view/user_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  late UsersBloc userBloc;

  @override
  void initState() {
    userBloc = context.read<UsersBloc>();
    userBloc.add(const UsersEvent.start());
    super.initState();
  }

  bool getUserOpenedValue(Map<String, bool> openedUsers, int userId) {
    bool resultValue = false;
    openedUsers.forEach((key, value) {
      if (key == userId.toString()) {
        resultValue = value;
      }
    });
    return resultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Список пользователей'),
        ),
        body: BlocBuilder<UsersBloc, UsersState>(
          bloc: userBloc,
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox(),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              received: (listUsers, listOpenedUsers) => Center(
                child: ListView.builder(
                  itemCount: listUsers.length,
                  itemBuilder: ((context, index) {
                    bool userOpenedValue = getUserOpenedValue(
                        listOpenedUsers, listUsers[index].id);
                    return InkWell(
                      onTap: () => Navigator.of(context).push<void>(
                        UserDetailView.route(user: listUsers[index]),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1))),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              listUsers[index].username,
                              style: TextStyle(
                                  fontWeight: userOpenedValue
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            ),
                            Text(
                              listUsers[index].name,
                              style: TextStyle(
                                  fontWeight: userOpenedValue
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              failure: (e) => Center(child: Text(e)),
            );
          },
        ));
  }
}
