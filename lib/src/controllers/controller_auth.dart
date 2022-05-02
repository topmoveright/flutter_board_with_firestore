import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/views/view_login.dart';

class ControllerAuth extends GetxController {
  final _user = Rx<User?>(FirebaseAuth.instance.currentUser);

  User? get user => _user.value;

  bool get isLoggedIn => user != null;

  Future<void> login() async {
    if (!isLoggedIn) {
      Get.offAll(() => ViewLogin());
    }
  }

  Future<void> logout() async {
    if (isLoggedIn) {
      await FirebaseAuth.instance.signOut();
    }
  }

  void _handleAuthChanged() {
    if (isLoggedIn) {
    } else {}
  }

  @override
  void onInit() {
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever<User?>(_user, (_) {
      update();
      _handleAuthChanged();
    });
    super.onInit();
  }
}
