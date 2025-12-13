import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  final Dio _dio = Dio();

  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_base_url');
    if (url == null || url.isEmpty) {
      throw Exception('Servidor não configurado corretamente');
    }
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  Future<List<Map<String, dynamic>>> loadAll() async {
    final baseUrl = await _getBaseUrl();
    try {
      final response = await _dio.get('$baseUrl/orders');

      if (response.data is List) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('Erro dio: ${e.response?.statusCode} - ${e.message}');
        throw Exception('Erro de conexão: $e');
      }
      throw Exception('Erro ao carregar lista de comandas');
    }
  }
}
