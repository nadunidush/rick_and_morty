import 'package:flutter/material.dart';

Widget buildMetadataItem(String text, IconData icon, BuildContext context, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color ?? Colors.white54, size: 16),
        const SizedBox(width: 4.0),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color ?? Colors.white54),
        ),
      ],
    );
  }