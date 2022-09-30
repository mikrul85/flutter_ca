import 'package:ca_example/data/services/user_service.dart';
import 'package:ca_example/domain/users_bloc/users_bloc.dart';
import 'package:ca_example/get_it.dart';
import 'package:ca_example/view/users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupGetIt();
  runApp(MyApp.myApp);
}

class MyApp extends StatelessWidget {
  static const MyApp myApp = MyApp._();
  const MyApp._();

  @override
  Widget build(BuildContext context) {
    final UserService userService = GetIt.instance<UserService>();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => UsersBloc(
                    userService: userService,
                  )),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const UsersView(),
        ));
  }
}
