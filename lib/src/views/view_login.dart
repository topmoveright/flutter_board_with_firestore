import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/controllers/controller_auth.dart';
import 'package:yuonsoft/src/core/routes/route_default.dart';

class ViewLogin extends GetView<ControllerAuth> {
  ViewLogin({Key? key}) : super(key: key);
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthFlowBuilder<EmailFlowController>(
        listener: (oldState, state, controller) {
          if (state is SignedIn) {
            Get.offAndToNamed(RouteDefault.home);
          }
        },
        builder: (context, state, controller, _) {
          if (state is AwaitingEmailAndPassword) {
            return Column(
              children: [
                TextField(
                  controller: emailCtrl,
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.setEmailAndPassword(
                      emailCtrl.text,
                      passwordCtrl.text,
                    );
                  },
                  child: const Text('Sign in'),
                ),
              ],
            );
          } else if (state is AuthFailed) {
            // FlutterFireUIWidget that shows a human-readable error message.
            return ErrorText(exception: state.exception);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
