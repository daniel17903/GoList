import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class GoListPlatformTextFormField
    extends PlatformWidgetBase<Widget, TextFormField> {
  final String? labelText;
  final TextEditingController? controller;

  const GoListPlatformTextFormField({Key? key, this.labelText, this.controller})
      : super(key: key);

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: const TextStyle(fontSize: 14),
            ),
          CupertinoTextField(controller: controller)
        ],
      ),
    );
  }

  @override
  TextFormField createMaterialWidget(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
        ));
  }
}
