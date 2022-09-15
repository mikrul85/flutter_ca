import 'package:ca_example/get_it.dart';
import 'package:ca_example/view/users_view.dart';
import 'package:flutter/material.dart';

void main() {
  setupGetIt();
  runApp(MyApp.myApp);
}

class MyApp extends StatelessWidget {
  static const MyApp myApp = MyApp._();
  const MyApp._();

  @override
  Widget build(BuildContext context) {
    print('000 ${MyApp.myApp == myApp}');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UsersView(),
    );
  }
}
