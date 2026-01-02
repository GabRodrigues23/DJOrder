import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:djorder/features/order/model/order.dart';
import 'package:printing/printing.dart';

class PrintOrderService {
  Future<void> generateAndPrintOrder(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'COMANDA #${order.idOrder}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Cliente: ${order.clientName ?? "Consumidor"}'),
              pw.Divider(),
              ...order.products.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${item.qtd}x ${item.description}'),
                      pw.Text(
                        'R\$ ${(item.price * item.qtd).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),

              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: R\$ ${order.totalValue.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
