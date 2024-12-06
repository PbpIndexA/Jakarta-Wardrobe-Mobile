import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jawa_app/menu.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.grey,
          )),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      )),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Image(
                    image: AssetImage('images/logo.png'),
                    height: 100,
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLogin
                              ? Color.fromARGB(255, 61, 61, 67)
                              : Colors.grey,
                          textStyle: TextStyle(
                              color: const Color.fromARGB(255, 27, 26, 26)),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLogin
                              ? Color.fromARGB(255, 61, 61, 67)
                              : Colors.grey,
                          textStyle: TextStyle(
                              color: const Color.fromARGB(255, 27, 26, 26)),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  _isLogin
                      ? _buildLoginForm(request)
                      : _buildRegisterForm(request),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(CookieRequest request) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        const SizedBox(height: 12.0),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: () async {
            String username = _usernameController.text;
            String password = _passwordController.text;

            final response =
                await request.login("http://127.0.0.1:8000/auth/login/", {
              'username': username,
              'password': password,
            });

            if (request.loggedIn) {
              String message = response['message'];
              String uname = response['username'];
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text("$message Selamat datang, $uname.")),
                  );
              }
            } else {
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Login Gagal'),
                    content: Text(response['message']),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Color.fromARGB(255, 58, 66, 58),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(CookieRequest request) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
        ),
        const SizedBox(height: 12.0),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 12.0),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            return null;
          },
        ),
        const SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: () async {
            String username = _usernameController.text;
            String password1 = _passwordController.text;
            String password2 = _confirmPasswordController.text;

            final response = await request.postJson(
                "http://127.0.0.1:8000/auth/register/",
                jsonEncode({
                  "username": username,
                  "password1": password1,
                  "password2": password2,
                }));
            if (context.mounted) {
              if (response['status'] == 'success') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully registered!'),
                  ),
                );
                setState(() {
                  _isLogin = true;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to register!'),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Color.fromARGB(255, 99, 101, 99),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text('Register'),
        ),
      ],
    );
  }
}
