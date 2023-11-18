import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/globalcolor.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.emailController, required this.validate,
  });

  final TextEditingController emailController;
  final String hintText;
  final String? Function(String?) validate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      validator: validate,
      style: GoogleFonts.poppins(
          color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 234, 233, 233),
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15))),
    );
  }
}
