import 'package:flutter/material.dart';

class CommonCardTile extends StatelessWidget {
  const CommonCardTile({
    super.key,
    required this.title,
    required this.destination,
    required this.trailingIcon,
  });

  final String title;
  final Widget destination;
  final Widget trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: trailingIcon,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return destination;
              },
            ),
          );
        },
      ),
    );
  }
}
