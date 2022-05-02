import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/app.dart';
import 'package:yuonsoft/src/board/core/services/service_board.dart';
import 'package:yuonsoft/src/board/core/services/service_setting.dart';
import 'package:yuonsoft/src/settings/settings_controller.dart';
import 'package:yuonsoft/src/settings/settings_service.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  Future<void> initServices() async {
    debugPrint('starting services ...');

    /// Here is where you put get_storage, hive, shared_pref initialization.
    /// or moor connection, or whatever that's async.
    await Get.putAsync(() => ServiceBoard().init());
    await Get.putAsync(() => ServiceSetting().init());
    debugPrint('All services started...');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await _connectToFirebaseEmulator();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.

  await initServices();


  runApp(MyApp(settingsController: settingsController));


}

Future _connectToFirebaseEmulator() async {
  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  await FirebaseAuth.instance.useAuthEmulator('http://$localHostString', 9099);
}
