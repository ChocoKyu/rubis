// ignore_for_file: file_names

import "package:flutter_secure_storage/flutter_secure_storage.dart";

class UserSecureStorage {
  final _storage = const FlutterSecureStorage();

  String pseudo = "pseudo";
  String password = "password";

  Future setPseudo(String username) async {
    await _storage.write(key: pseudo, value: username);
  }

  Future setPassword(String mdp) async {
    await _storage.write(key: password, value: mdp);
  }

  Future<String> getPseudo() async => await _storage.read(key: pseudo);
  Future<String> getPassword() async => await _storage.read(key: password);

  Future clearStorage() async {
    await _storage.deleteAll();
  }
}
