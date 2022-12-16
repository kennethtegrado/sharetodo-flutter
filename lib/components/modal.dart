import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/config/index.dart';

class ConfirmModal extends StatelessWidget {
  final String title;
  final String modalBody;
  final void Function() confirm;
  final bool passive;
  const ConfirmModal(
      {super.key,
      required this.title,
      required this.modalBody,
      required this.confirm,
      required this.passive});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: BrandColor.background.shade700),
      ),
      content: Text(
        modalBody,
        style: TextStyle(color: BrandColor.background.shade300),
      ),
      actions: [
        // The "Yes" button
        TextButton(
            onPressed: () {
              confirm();
              Navigator.of(context).pop();
            },
            child: Text(
              'Yes',
              style: passive
                  ? TextStyle(color: BrandColor.background.shade400)
                  : TextStyle(color: BrandColor.primary.shade500),
            )),
        TextButton(
            onPressed: () =>
                // Close the dialog
                Navigator.of(context).pop(),
            child: Text(
              'No',
              style: passive
                  ? TextStyle(color: BrandColor.primary.shade500)
                  : TextStyle(color: BrandColor.background.shade400),
            ))
      ],
    );
  }
}
