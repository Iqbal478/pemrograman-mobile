import 'package:flutter/material.dart';
import 'feedback_form_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Di sini, kita langsung me-redirect ke halaman formulir feedback.
    return const FeedbackFormPage();
  }
}
