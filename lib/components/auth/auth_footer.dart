import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final VoidCallback onForgotPassword;

  const AuthFooter({
    super.key,
    required this.onCreateAccount,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: onCreateAccount,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: const Text(
            'Criar conta',
            style: TextStyle(
              color: Color(0xFF10b981),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onForgotPassword,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: const Text(
            'Esqueci minha senha',
            style: TextStyle(
              color: Color(0xFF10b981),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
