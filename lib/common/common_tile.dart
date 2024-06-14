import 'package:flutter/material.dart';
import 'package:spark/theme.dart';

class CommonCardTile extends StatelessWidget {
  const CommonCardTile({
    super.key,
    required this.title,
    this.subtitle,
    this.destination,
    this.trailingWidget,
    this.leadingWidget,
    this.category,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? destination;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final String? category;

  Widget cardColorWrap(BuildContext context, String category, Widget child) {
    final brightness = Theme.of(context).brightness;
    Color? cardColor;
    Color? borderColor;
    switch (category) {
      case 'education':
        cardColor = redLight;
        borderColor = redDark;
      case 'exercise':
        cardColor = orangeLight;
        borderColor = orangeDark;
      case 'health':
        cardColor = yellowLight;
        borderColor = yellowDark;
      case 'lifestyle':
        cardColor = greenLight;
        borderColor = greenDark;
      case 'mental health':
        cardColor = blueLight;
        borderColor = blueDark;
      case 'work':
        cardColor = purpleLight;
        borderColor = purpleDark;
      case 'common':
        cardColor = const Color.fromARGB(255, 255, 232, 232);
        borderColor = const Color(0xffd83831);
      case '_':
        break;
    }
    if (brightness == Brightness.dark) {
      final temp = cardColor;
      cardColor = borderColor;
      borderColor = temp;
    }
    return Card(
      color: cardColor,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        side: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.outline,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return cardColorWrap(
      context,
      category ?? '',
      ListTile(
        title: title,
        subtitle: subtitle,
        trailing: trailingWidget,
        leading: leadingWidget,
        onTap: destination != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return destination!;
                    },
                  ),
                );
              }
            : null,
      ),
    );
  }
}
