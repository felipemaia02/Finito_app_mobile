import 'package:flutter/material.dart';
import 'package:finito_app/components/inputs/custom_text_field.dart';

class OpenGroupCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onOpenGroup;

  const OpenGroupCard({
    super.key,
    required this.controller,
    required this.onOpenGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Abrir grupo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Digite o grupo para acessar',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller,
                    label: 'Grupo',
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onOpenGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10b981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Abrir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
