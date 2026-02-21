import 'package:flutter/material.dart';
import 'package:finito_app/data/service_locator.dart';
import 'package:finito_app/domain/models/auth.dart';
import 'package:finito_app/data/services/auth_service.dart';
import 'package:finito_app/components/inputs/custom_text_field.dart';
import 'package:finito_app/components/buttons/primary_button.dart';
import 'package:finito_app/components/auth/auth_header.dart';
import 'package:finito_app/components/auth/auth_card.dart';
import 'package:finito_app/components/auth/auth_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _clearStorage();
  }

  Future<void> _clearStorage() async {
    final storageService = serviceLocator.storageService;
    await storageService.clearTokens();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = serviceLocator.authService;
      final storageService = serviceLocator.storageService;

      final loginRequest = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final tokens = await authService.login(loginRequest);

      // Salvar tokens no storage
      await storageService.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        expiresAt: tokens.expiresAt,
      );

      // Configurar tokens nos services
      serviceLocator.userService.setAccessToken(tokens.accessToken);
      serviceLocator.expenseService.setAccessToken(tokens.accessToken);

      if (!mounted) return;

      // Navegar para home
      Navigator.of(context).pushReplacementNamed('/home');
    } on AuthenticationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } on ValidationException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao fazer login. Tente novamente.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF10b981), Color(0xFF059669)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      const AuthHeader(
                        title: 'Finito',
                        subtitle: 'Entre na sua conta',
                      ),
                      const SizedBox(height: 32),

                      // Campo Email
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          if (!value.contains('@')) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Senha',
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black54,
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão Entrar
                      PrimaryButton(
                        text: 'Entrar',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Links
                      AuthFooter(
                        onCreateAccount: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registro em desenvolvimento'),
                            ),
                          );
                        },
                        onForgotPassword: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Recuperação de senha em desenvolvimento'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
