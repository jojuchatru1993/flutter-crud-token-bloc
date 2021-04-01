import 'dart:convert';

import 'package:form/src/shared_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  // final _firebaseToken = '';
  final _urlRegister = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCsRaNXdtFFUUmSH73GuVXzUsE8JWKDwNk');

  final _urlLogin = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCsRaNXdtFFUUmSH73GuVXzUsE8JWKDwNk');

  final _preferences = new UserPreferences();

  Future<Map<String, dynamic>> register(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final request = await http.post(_urlRegister, body: json.encode(authData));

    Map<String, dynamic> decodeRequest = json.decode(request.body);

    print(decodeRequest);

    if (decodeRequest.containsKey('idToken')) {
      _preferences.token = decodeRequest['idToken'];

      return {'ok': true, 'token': decodeRequest['idToken']};
    } else {
      return {'ok': false, 'message': decodeRequest['error']['message']};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final request = await http.post(_urlLogin, body: json.encode(authData));

    Map<String, dynamic> decodeRequest = json.decode(request.body);

    print(decodeRequest);

    if (decodeRequest.containsKey('idToken')) {
      _preferences.token = decodeRequest['idToken'];

      return {'ok': true, 'token': decodeRequest['idToken']};
    } else {
      return {'ok': false, 'message': decodeRequest['error']['message']};
    }
  }
}
