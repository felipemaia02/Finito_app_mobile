import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ícone com fundo verde
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF10b981),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        // Título
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // Subtítulo
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
