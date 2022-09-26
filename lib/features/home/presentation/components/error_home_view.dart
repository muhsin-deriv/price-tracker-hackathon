import 'package:flutter/material.dart';

class ErrorHomeView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorHomeView({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Error message to be displayed
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
        ),

        // Retry button
        MaterialButton(
          onPressed: onRetry,
          child: Text('Tap here to retry'),
        ),
      ],
    );
  }
}
