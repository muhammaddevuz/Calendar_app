import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final IconData? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool ignorePointers;

  const CustomTextfield({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.ignorePointers = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          ignorePointers: ignorePointers,
          onChanged: onChanged,
          onTap: onTap,
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F3F7),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.blue)
                : null,
          ),
        ),
      ],
    );
  }
}