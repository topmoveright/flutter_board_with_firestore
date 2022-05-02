
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yuonsoft/src/board/controllers/controller_board.dart';
import 'package:yuonsoft/src/core/routes/route_default.dart';
import 'package:yuonsoft/src/views/view_layout.dart';

class ViewWriteCreate extends StatefulWidget {
  const ViewWriteCreate({Key? key}) : super(key: key);

  @override
  State<ViewWriteCreate> createState() => _ViewWriteCreateState();
}

class _ViewWriteCreateState extends State<ViewWriteCreate> {
  late ControllerBoard boardController;

  final formKey = GlobalKey<FormState>();
  final tecPassword = TextEditingController();
  final tecSubject = TextEditingController();
  final tecName = TextEditingController();
  final tecPhone = TextEditingController();
  final tecEmail = TextEditingController();
  final tecContent = TextEditingController();

  late List<PlatformFile?> images;

  @override
  void initState() {
    try {
      boardController = Get.arguments as ControllerBoard;
    } catch (e) {
      debugPrint(e.toString());
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Get.offAndToNamed(RouteDefault.home);
      });
    }

    images = List.generate(boardController.writeMaxImageCount, (index) => null);

    super.initState();
  }

  @override
  void dispose() {
    tecPassword.dispose();
    tecSubject.dispose();
    tecName.dispose();
    tecPhone.dispose();
    tecEmail.dispose();
    tecContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      child: Center(
        child: SizedBox(
          width: 800,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                // TODO : 최대 8자리 영문숫자 비밀번호만
                buildTextFormField(
                  isObscure: true,
                  controller: tecPassword,
                  hint: '최대 8자리 (영문, 숫자)',
                  label: const Text('비밀번호'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  controller: tecSubject,
                  label: const Text('제목'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  controller: tecName,
                  label: const Text('이름'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                buildTextFormField(
                  controller: tecPhone,
                  label: const Text('연락처'),
                  validator: (value) {
                    return null;
                  },
                ),
                buildTextFormField(
                  controller: tecEmail,
                  label: const Text('이메일'),
                  validator: (value) {
                    return null;
                  },
                ),
                buildTextFormField(
                  controller: tecContent,
                  label: const Text('내용'),
                  isTextarea: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력해 주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ...List.generate(
                  boardController.writeMaxImageCount,
                  (index) => buildImageInput(
                    Text('파일첨부 ${index + 1}'),
                    index,
                  ),
                ),
                const SizedBox(height: 40),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('취소'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          var password = tecPassword.text;
                          var subject = tecSubject.text;
                          var name = tecName.text;
                          var phone = tecPhone.text;
                          var email = tecEmail.text;
                          var content = tecContent.text;

                          await boardController.actWriteCreate(
                            password: password,
                            subject: subject,
                            name: name,
                            content: content,
                            phone: phone,
                            email: email,
                            images: images,
                          );

                          Get.back();
                        }
                      },
                      child: const Text('등록'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImageInput(
    Widget title,
    int index,
  ) {
    return ButtonBar(
      alignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () async {
            var file = await boardController.fileSelect();
            if (file != null) {
              setState(() {
                images[index] = file;
              });
            }
          },
          child: title,
        ),
        const SizedBox(width: 4),
        Text(images[index] != null ? images[index]!.name : '...'),
        if (images[index] != null)
          TextButton(
            onPressed: () {
              setState(() {
                images[index] = null;
              });
            },
            child: const Icon(Icons.close),
          ),
      ],
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required Widget label,
    required FormFieldValidator<String> validator,
    bool isObscure = false,
    String hint = '',
    bool isTextarea = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      enableSuggestions: !isObscure,
      autocorrect: !isObscure,
      validator: validator,
      keyboardType: isTextarea ? TextInputType.multiline : TextInputType.text,
      maxLines: isTextarea ? null : 1,
      minLines: isTextarea ? 20 : 1,
      decoration: InputDecoration(
        hintText: hint,
        label: label,
      ),
    );
  }
}
