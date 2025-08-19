import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _phoneNumber;
  bool _isCodeSent = false;
  bool _isPasswordNeeded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация Telegram')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSent) {
            setState(() {
              _isCodeSent = true;
            });
          } else if (state is AuthPasswordNeeded) {
            setState(() {
              _isPasswordNeeded = true;
            });
          } else if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/chats');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isCodeSent && !_isPasswordNeeded) _buildPhoneInput(state),
                if (_isCodeSent) _buildCodeInput(state),
                if (_isPasswordNeeded) _buildPasswordInput(state),
                if (state is AuthError) 
                  Text(state.message, style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneInput(AuthState state) {
    return Column(
      children: [
        TextField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Номер телефона',
            hintText: '+79123456789',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state is AuthLoading ? null : _submitPhone,
          child: state is AuthLoading 
              ? const CircularProgressIndicator()
              : const Text('Продолжить'),
        ),
      ],
    );
  }

  Widget _buildCodeInput(AuthState state) {
    return Column(
      children: [
        Text('Код отправлен на $_phoneNumber'),
        const SizedBox(height: 20),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Код из Telegram',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state is AuthLoading ? null : _submitCode,
          child: state is AuthLoading 
              ? const CircularProgressIndicator()
              : const Text('Войти'),
        ),
      ],
    );
  }

  Widget _buildPasswordInput(AuthState state) {
    return Column(
      children: [
        const Text('Введите пароль'),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Пароль',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: state is AuthLoading ? null : _submitPassword,
          child: state is AuthLoading 
              ? const CircularProgressIndicator()
              : const Text('Продолжить'),
        ),
      ],
    );
  }

  void _submitPhone() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      setState(() {
        _phoneNumber = phone;
      });
      context.read<AuthBloc>().add(SendPhoneNumber(phoneNumber: phone));
    }
  }

  void _submitCode() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      context.read<AuthBloc>().add(SendAuthCode(code: code));
    }
  }

  void _submitPassword() {
    final password = _passwordController.text.trim();
    if (password.isNotEmpty) {
      context.read<AuthBloc>().add(SendPassword(password: password));
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}