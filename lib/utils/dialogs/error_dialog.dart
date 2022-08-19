import 'package:flutter/material.dart';
import 'package:marego_app/utils/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
      context: context,
      title: 'Uh oh...!',
      content: text,
      optionsBuilder: () => {
            'OK': null,
          });
}
