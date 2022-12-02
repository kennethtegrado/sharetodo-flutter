import 'package:flutter/material.dart';

class ConfirmModal extends StatelessWidget {
  final String title;
  final String modalBody;
  final void Function() confirm;
  const ConfirmModal(
      {super.key,
      required this.title,
      required this.modalBody,
      required this.confirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(modalBody),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              confirm();
              Navigator.of(context).pop();
            },
            child: const Text('Yes')),
        TextButton(
            onPressed: () =>
                // Close the dialog
                Navigator.of(context).pop(),
            child: const Text('No'))
      ],
    );
  }
}
