import 'dart:convert';

import 'package:helios_test/model/user.dart';
import 'package:http/http.dart';

abstract class UsersRepository {
  Future<List<User>> fetchUsers();
  int get getLimitUsersFetched;
}

class UsersAPIRepository implements UsersRepository {
  const UsersAPIRepository(this.httpClient);

  final Client httpClient;

  @override
  Future<List<User>> fetchUsers() async {
    final request = await httpClient.get(
        Uri.parse("https://randomuser.me/api/?results=$getLimitUsersFetched"));

    if (request.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(request.body);
      final List<dynamic> results = response['results'];

      return results.map<User>((result) => User.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  int get getLimitUsersFetched => 20;
}
