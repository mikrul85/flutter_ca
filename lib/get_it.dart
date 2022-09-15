import 'package:ca_example/data/services/user_service.dart';
import 'package:get_it/get_it.dart';

void setupGetIt() {
  GetIt.instance.registerSingleton<UserService>(UserService());
}
