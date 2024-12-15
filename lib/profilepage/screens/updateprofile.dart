import 'package:flutter/material.dart';
import 'package:jawa_app/home.dart';
import 'package:jawa_app/profilepage/models/profile.dart';
import 'package:jawa_app/shared/widgets/drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

// masih belum munculin gambar
// gambar masih pake link
// belum disambungin sama yg ada di django

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  Future<int> fetchProfile(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/users/json/');
    

    return 0;
  }
  
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _avatarUrl = ''; // Gambar dari URL (link)


  // Fungsi untuk menyimpan perubahan
  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      // Simulasi proses pengiriman data ke server
      String username = _username.toString();
      String avatarUrl = _avatarUrl;

      print('Username: $username');
      print('Avatar URL: $avatarUrl');

      // Tambahkan logika pengiriman data ke backend di sini
      // Contoh: Gunakan http.post atau Dio untuk mengirim data username dan avatar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Update Profile',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(), // drawer
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
              children: [
                // Field untuk mengubah URL gambar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Link Gambar Profil',
                      hintText: 'Masukkan URL gambar',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _avatarUrl = value;
                      });
                    },
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!Uri.tryParse(value)!.hasAbsolutePath) {
                          return 'URL gambar tidak valid';
                        }
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Field untuk mengubah username
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Masukkan username',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username tidak boleh kosong';
                      }
                      if (value.length > 100) {
                        return 'Username tidak boleh lebih dari 100 karakter';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

