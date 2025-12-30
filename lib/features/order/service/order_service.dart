import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:djorder/features/settings/service/settings_service.dart';

class OrderService {
  final Dio _dio = Dio();
  final _settings = SettingsService();

  Future<List<Map<String, dynamic>>> loadAll() async {
    final baseUrl = _settings.apiUrl;

    try {
      if (baseUrl.isEmpty) throw Exception('Url da API não configurada');

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
