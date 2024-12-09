import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jawa_app/home.dart';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
        child: Column(children: [
          Image(
            image: AssetImage('images/logo.png'),
            height: 200,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = true;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: !_isLogin
                                ? const Color.fromARGB(255, 58, 56, 56)
                                : const Color.fromARGB(255, 201, 201, 197),
                            textStyle: TextStyle(),
                          ),
                          child: Text('Login',
                              style: TextStyle(
                                color: !_isLogin
                                    ? const Color.fromARGB(255, 226, 226, 225)
                                    : const Color.fromARGB(255, 39, 37, 37),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = false;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: !_isLogin
                                ? const Color.fromARGB(255, 201, 201, 197)
                                : const Color.fromARGB(255, 58, 56, 56),
                            textStyle: TextStyle(),
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: !_isLogin
                                  ? const Color.fromARGB(255, 39, 37, 37)
                                  : const Color.fromARGB(255, 226, 226, 225),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
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
        ]),
      ),
    );
  }

  Widget _buildLoginForm(CookieRequest request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username'),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Enter your username',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2,
                )),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        const SizedBox(height: 12.0),
        const Text('Password'),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create an Account',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        const Text('Username'),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            hintText: 'Enter your username',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          ),
        ),
        const SizedBox(height: 12.0),
        const Text('Password'),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
        ),
        const SizedBox(height: 12.0),
        const Text('Confirm Password'),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            hintText: 'Confirm your password',
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          obscureText: _obscureConfirmPassword,
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
