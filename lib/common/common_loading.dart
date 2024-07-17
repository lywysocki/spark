import 'package:flutter/material.dart';

class CommonLoadingWidget extends StatelessWidget {
  const CommonLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: null,
            child: Text('Loading...'),
          ),
        ],
      ),
    );
  }
}
