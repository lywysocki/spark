import 'package:flutter/material.dart';
import 'package:spark/common/common_textfield.dart';

class CommonDuration extends StatefulWidget {
  const CommonDuration({
    super.key,
    required this.headerText,
    required this.onTap,
    required this.date,
  });

  final String headerText;
  final VoidCallback? onTap;
  final DateTime? date;

  @override
  State<CommonDuration> createState() => _CommonDurationState();
}

class _CommonDurationState extends State<CommonDuration> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' ${widget.headerText}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          width: 105,
          height: 33,
          child: Stack(
            children: [
              const CommonTextfield(
                isTapped: true,
              ),
              TextButton(
                onPressed: widget.onTap,
                child: Center(
                  child: Text(
                    widget.date != null
                        ? widget.date.toString().substring(0, 10)
                        : 'None',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
