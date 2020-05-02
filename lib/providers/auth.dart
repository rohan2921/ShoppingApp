import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String requestOf) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$requestOf?key=AIzaSyA5Ia15BY3PNKQlUIPP8x181VLiCQmnKTo';
    try {
      final response = await http.post(url,
          body: json.encode({
            'returnSecureToken': true,
            'email': email,
            'password': password
          }));
      final receivedData = json.decode(response.body);
      if (receivedData['error'] != null) {
        throw HttpException(receivedData['error']['message']);
      }
      _token = receivedData['idToken'];
      _userId = receivedData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(receivedData['expiresIn'])));
        _autoLogout();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userData=json.encode({'token':_token,'expiryDate':_expiryDate.toIso8601String(),'userId':_userId});
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async{
        final prefs=await SharedPreferences.getInstance();
        if(!prefs.containsKey('userData')){
            return false;
        }
        final extracteduserData=json.decode(prefs.getString('userData')) as Map<String,Object>;
        final expirydate=DateTime.parse(extracteduserData['expiryDate']);

        if(expirydate.isBefore(DateTime.now())){
          return false;
        }
        _token=extracteduserData['token'];
        _expiryDate=expirydate;
        _userId=extracteduserData['userId'];
        notifyListeners();
        _autoLogout();
        return true;

        
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout(){
    _expiryDate=null;
    _token=null;
    _userId=null;
    notifyListeners();
  }
  Future<void> _autoLogout() async{
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    final _timeToExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds:_timeToExpiry), logout);
    final pers= await SharedPreferences.getInstance();
    pers.clear();
  }
}
