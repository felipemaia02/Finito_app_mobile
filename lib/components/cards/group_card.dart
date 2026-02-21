import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final String groupId;
  final VoidCallback onTap;
  final int? memberCount;
  final String? lastActivity;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.groupId,
    required this.onTap,
    this.memberCount,
    this.lastActivity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícone do grupo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.group,
                  color: Color(0xFF10b981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Informações do grupo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (memberCount != null || lastActivity != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (memberCount != null) ...[
                            Icon(
                              Icons.people,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$memberCount',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (memberCount != null && lastActivity != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '•',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          if (lastActivity != null)
                            Expanded(
                              child: Text(
                                lastActivity!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Ícone de navegação
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
