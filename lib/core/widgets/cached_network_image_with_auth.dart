import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled8/core/di/injection.dart';

class CachedNetworkImageWithAuth extends StatelessWidget {
  final String imageUrl;

  const CachedNetworkImageWithAuth({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final token = snapshot.data;
        final headers = <String, String>{};
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }

        return Image(
          image: NetworkImage(imageUrl, headers: headers),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.error),
        );
      },
    );
  }

  Future<String?> _getToken() async {
    final storage = sl<FlutterSecureStorage>();
    return await storage.read(key: 'auth_token');
  }
}
