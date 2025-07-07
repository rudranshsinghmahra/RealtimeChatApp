import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller, this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(fontWeight: FontWeight.w400,color: Color(0xff8b3b11)),
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              label: Icon(icon, color: Color(0xff8b3b11)),
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xff8b3b11)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8b3b11), width: 2.5),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff8b3b11), width: 5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
