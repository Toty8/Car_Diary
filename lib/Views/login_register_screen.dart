import 'package:flutter/material.dart';
import '../Database/database_helper.dart';
import '../models/user.dart';
import '../Views/home_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  String _loginEmail = '';
  String _loginPassword = '';

  String _registerEmail = '';
  String _registerPassword = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _login() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();

      final user = await DatabaseHelper.instance.getUserByEmailAndPassword(_loginEmail, _loginPassword);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Добре дошъл, ${user.email}')),
        );
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ),
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Грешен имейл или парола')),
        );
      }
    }
  }

  void _register() async {
    if (_registerFormKey.currentState!.validate()) {
      _registerFormKey.currentState!.save();

      try {
        await DatabaseHelper.instance.insertUser(
          User(email: _registerEmail, password: _registerPassword),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Успешна регистрация! Влез сега.')),
        );

        _tabController.animateTo(0);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Имейлът вече съществува')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авто Дневник'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Вход'),
            Tab(text: 'Регистрация'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Имейл'),
                    validator: (value) => value == null || value.isEmpty ? 'Въведи имейл' : null,
                    onSaved: (value) => _loginEmail = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Парола'),
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty ? 'Въведи парола' : null,
                    onSaved: (value) => _loginPassword = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Вход'),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _registerFormKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Имейл'),
                    validator: (value) => value == null || value.isEmpty ? 'Въведи имейл' : null,
                    onSaved: (value) => _registerEmail = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Парола'),
                    obscureText: true,
                    validator: (value) => value == null || value.isEmpty ? 'Въведи парола' : null,
                    onSaved: (value) => _registerPassword = value!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Регистрация'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
