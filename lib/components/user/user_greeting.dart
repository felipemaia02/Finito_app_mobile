import 'package:flutter/material.dart';

class UserGreeting extends StatelessWidget {
  final String userName;
  final String subtitle;

  const UserGreeting({
    super.key,
    required this.userName,
    this.subtitle = 'Bem-vindo de volta!',
  });

  String _getInitials() {
    if (userName.isEmpty) return '?';
    return userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF10b981),
          child: Text(
            _getInitials(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, $userName',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
