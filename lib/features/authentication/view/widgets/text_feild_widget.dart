import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextFieldWidget extends HookWidget {
  final TextEditingController? controller;
  final String fieldname;
  final String? Function(String?)? validator;
  final bool isPassword;

  const TextFieldWidget({
    super.key,
    required this.fieldname,
    this.controller,
    this.validator,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldname,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible.value,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
