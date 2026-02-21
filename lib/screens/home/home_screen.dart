import 'package:flutter/material.dart';
import 'package:finito_app/data/service_locator.dart';
import 'package:finito_app/components/user/user_greeting.dart';
import 'package:finito_app/components/cards/group_card.dart';
import 'package:finito_app/components/cards/open_group_card.dart';
import 'package:finito_app/components/app_bar/finito_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _groupIdController = TextEditingController();
  int _selectedNavIndex = 0;
  String _userName = '';
  bool _isLoadingUser = true;

  final List<Map<String, dynamic>> _recentGroups = [
    {
      'id': '507f1f77bcf86cd799439012',
      'name': 'Casa',
      'memberCount': 3,
      'lastActivity': 'Última atividade há 2 dias',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = serviceLocator.authService;
      final userService = serviceLocator.userService;
      final storageService = serviceLocator.storageService;

      final accessToken = await storageService.getAccessToken();
      if (accessToken == null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }

      final validationResponse = await authService.validateToken(accessToken);

      if (validationResponse.valid && validationResponse.email != null) {
        final userResponse = await userService.getUserByEmail(
          validationResponse.email!,
        );

        setState(() {
          _userName = userResponse.name;
          _isLoadingUser = false;
        });
      } else {
        await storageService.clearTokens();
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userName = 'Usuário';
        _isLoadingUser = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados do usuário: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _groupIdController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    try {
      final storageService = serviceLocator.storageService;
      await storageService.clearTokens();
      serviceLocator.userService.setAccessToken(null);
      serviceLocator.expenseService.setAccessToken(null);

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao fazer logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleOpenGroup() {
    final groupId = _groupIdController.text.trim();
    if (groupId.isEmpty) return;

    // Por enquanto, apenas mostra uma mensagem
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedNavIndex == 0
              ? 'Abrindo despesas do grupo: $groupId'
              : 'Abrindo analytics do grupo: $groupId',
        ),
        backgroundColor: const Color(0xFF10b981),
      ),
    );

  }

  void _handleGroupClick(String groupId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedNavIndex == 0
              ? 'Abrindo despesas do grupo: $groupId'
              : 'Abrindo analytics do grupo: $groupId',
        ),
        backgroundColor: const Color(0xFF10b981),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinitoAppBar(onLogout: _handleLogout),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoadingUser
                  ? const SizedBox(
                      height: 56,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF10b981),
                        ),
                      ),
                    )
                  : UserGreeting(userName: _userName),
              const SizedBox(height: 24),

              OpenGroupCard(
                controller: _groupIdController,
                onOpenGroup: _handleOpenGroup,
              ),
              const SizedBox(height: 24),

              const Text(
                'Últimos grupos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de grupos
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentGroups.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final group = _recentGroups[index];
                  return GroupCard(
                    groupName: group['name'] as String,
                    groupId: group['id'] as String,
                    memberCount: group['memberCount'] as int?,
                    lastActivity: group['lastActivity'] as String?,
                    onTap: () => _handleGroupClick(group['id'] as String),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF10b981),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
