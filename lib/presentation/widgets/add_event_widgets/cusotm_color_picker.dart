import 'package:flutter/material.dart';
import 'package:flutter_color_picker_plus/flutter_color_picker_plus.dart';

class CustomColorPicker extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const CustomColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Color'),
      content: BlockPicker(
        pickerColor: initialColor,
        onColorChanged: onColorSelected,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}