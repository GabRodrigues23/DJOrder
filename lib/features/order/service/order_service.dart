import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:djorder/features/settings/service/settings_service.dart';

class OrderService {
  final Dio dio;
  final SettingsService settings;

  OrderService(this.dio, this.settings);

  Future<List<Map<String, dynamic>>> loadAll() async {
    final baseUrl = settings.apiUrl;

    try {
      if (baseUrl.isEmpty) throw Exception('Url da API não configurada');

      final response = await dio.get('$baseUrl/orders');

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

  Future<void> updateOrder(
    int idOrder, {
    String? clientName,
    int? tableId,
    bool? isCanceled,
    bool? isBlocked,
  }) async {
    final baseUrl = settings.apiUrl;
    final Map<String, dynamic> data = {};

    if (clientName != null) data['clientName'] = clientName;
    if (tableId != null) data['tableId'] = tableId;
    if (isCanceled != null) data['isCanceled'] = isCanceled;
    if (isBlocked != null) data['isBlocked'] = isBlocked;

    if (data.isEmpty) return;

    try {
      await dio.put('$baseUrl/orders/$idOrder', data: data);
    } catch (e) {
      throw Exception('Falha na comunicação com servidor: $e');
    }
  }

  Future<List<Map<String, dynamic>>> loadProducts() async {
    final baseUrl = settings.apiUrl;

    try {
      if (baseUrl.isEmpty) throw Exception('Url da API não configurada');

      final response = await dio.get('$baseUrl/products');

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
      throw Exception('Erro ao carregar lista de produtos');
    }
  }

  Future<void> addProduct(
    int idPreSale, {
    required int visualId,
    required int idProduct,
    required double qtd,
    required double unitPrice,
    List<Map<String, dynamic>>? additionals,
  }) async {
    final baseUrl = settings.apiUrl;
    try {
      await dio.post(
        '$baseUrl/orders/$idPreSale/products',
        data: {
          'idOrder': visualId,
          'idProduct': idProduct,
          'quantity': qtd,
          'unitPrice': unitPrice,
          'additionals': additionals ?? [],
        },
      );
    } catch (e) {
      throw Exception('Erro ao adicionar item: $e');
    }
  }
}
