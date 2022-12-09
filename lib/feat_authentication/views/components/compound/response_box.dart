import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/utils/response.dart';

class HelperInfo extends StatelessWidget {
  const HelperInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Response? response = context.watch<AuthProvider>().response;

    if (response == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: response is ErrorResponse
              ? Colors.red.shade800
              : Colors.green.shade800),
      child: Row(
        children: [
          Icon(
            response is ErrorResponse ? Icons.dangerous : Icons.check_circle,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(response.message, style: const TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}
