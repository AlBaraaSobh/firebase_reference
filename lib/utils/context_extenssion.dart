import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension ContextExtenssion on BuildContext {
  void showSnackBar({required String message, bool error = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: error ? Colors.red.shade800 : Colors.green.shade800,
        dismissDirection: DismissDirection.horizontal,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
