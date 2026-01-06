import 'package:djorder/features/order/interfaces/order_repository_interface.dart';
import 'package:djorder/features/product/model/additional.dart';
import 'package:djorder/features/product/model/product.dart';
import 'package:flutter/material.dart';

class ProductViewModel extends ChangeNotifier {
  final OrderRepositoryInterface _repository;
  ProductViewModel(this._repository);

  List<Product> _allProducts = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  Product? selectedProduct;
  double quantity = 1;
  final List<AdditionalItem> _selectedAdditionals = [];
  List<AdditionalItem> get selectedAdditionals => _selectedAdditionals;

  Future<void> loadCatalog() async {
    isLoading = true;
    notifyListeners();
    try {
      _allProducts = await _repository.getCatalog();
      filteredProducts = List.from(_allProducts);
    } catch (e) {
      debugPrint('Erro ao carregar produtos: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredProducts = List.from(_allProducts);
    } else {
      final q = query.toUpperCase();
      filteredProducts = _allProducts.where((p) {
        return p.description.toUpperCase().contains(q) || p.id.toString() == q;
      }).toList();
    }
    notifyListeners();
  }

  void selectProduct(Product product) {
    selectedProduct = product;
    _selectedAdditionals.clear();
    quantity = 1;
    notifyListeners();
  }

  void incrementQty() {
    quantity++;
    notifyListeners();
  }

  void decrementQty() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  int _countSelectedInGroup(AdditionalGroup group) {
    int count = 0;
    for (var selected in _selectedAdditionals) {
      if (group.items.any((item) => item.id == selected.id)) {
        count++;
      }
    }
    return count;
  }

  void toggleAdditional(AdditionalGroup group, AdditionalItem item) {
    final isSelected = _selectedAdditionals.contains(item);
    if (isSelected) {
      _selectedAdditionals.remove(item);
    } else {
      if (group.max == 1) {
        _selectedAdditionals.removeWhere(
          (existing) => group.items.contains(existing),
        );
        _selectedAdditionals.add(item);
      } else {
        final currentCount = _countSelectedInGroup(group);
        if (currentCount < group.max) {
          _selectedAdditionals.add(item);
        } else {
          debugPrint('Max de ${group.max} atingido para este grupo');
          return;
        }
      }
    }
    notifyListeners();
  }

  String? validate() {
    if (selectedProduct == null) return null;

    for (var group in selectedProduct!.additionalGroups) {
      final count = _countSelectedInGroup(group);
      if (count < group.min) {
        return 'Selecione pelo menos ${group.min} opções em "${group.description}"';
      }
    }
    return null;
  }

  Future<void> confirmAdd(int idPreSale, int visualId) async {
    if (selectedProduct == null) return;
    await _repository.includeProduct(
      idPreSale,
      visualId,
      selectedProduct!,
      quantity,
      selectedAdditionals,
    );
  }
}
