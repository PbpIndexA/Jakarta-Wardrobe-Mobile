import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  String imageUrl = '';

  Future<void> submitArticle(
      BuildContext context, String title, String content, String imageUrl) async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    final response = await request.post(
      'http://127.0.0.1:8000/articles/add/',
      jsonEncode({
        "title": title,
        "content": content,
        "image_url": imageUrl,
      }),
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Artikel berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // Kembali ke list artikel dan kirim 'true'
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah artikel: ${response['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Artikel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul Artikel'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
                onSaved: (value) => title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Isi Artikel'),
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Isi tidak boleh kosong' : null,
                onSaved: (value) => content = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'URL gambar tidak boleh kosong' : null,
                onSaved: (value) => imageUrl = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    submitArticle(context, title, content, imageUrl);
                  }
                },
                child: const Text('Tambah Artikel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
