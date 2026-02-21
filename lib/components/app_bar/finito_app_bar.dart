import 'package:flutter/material.dart';

class FinitoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogout;
  final bool showLogout;

  const FinitoAppBar({
    super.key,
    this.onLogout,
    this.showLogout = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF10b981),
      elevation: 0,
      title: Row(
        children: const [
          Icon(Icons.account_balance_wallet, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Finito',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: showLogout && onLogout != null
          ? [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: onLogout,
                tooltip: 'Sair',
              ),
            ]
          : null,
    );
  }
}
