class OrderService {
  Future<List<Map<String, dynamic>>> fetchOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        "CODPREVENDA": 1,
        "ID_COMANDA": 1,
        "IDMESA": null,
        "STATUS_PEDIDO": "N",
        "NOME_CLIENTE": "Gabriel Rodrigues",
        "SUBTOTAL": 50.00,
        "TAXA_SERVICO": 5.0,
        "DATAHORA_INICIO": DateTime.now().toIso8601String(),
        "products": [
          {
            "CODPRODUTO": 1,
            "DESCRICAO": "Coca-Cola",
            "QTD": 2.0,
            "PRECO_UNITARIO": 5.0,
            "CANCELADO": "N",
          },
          {
            "CODPRODUTO": 2,
            "DESCRICAO": "Porção Batata",
            "QTD": 1.0,
            "PRECO_UNITARIO": 30.0,
            "CANCELADO": "N",
          },
        ],
      },
    ];
  }
}
